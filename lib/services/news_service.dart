import 'package:dio/dio.dart';

import '../models/article_model.dart';
import '../models/category_model.dart';

class NewsServiceException implements Exception {
  final String message;
  final bool isNetworkError;

  const NewsServiceException(this.message, {this.isNetworkError = false});

  @override
  String toString() => message;
}

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'b85127eeaf034680aad281985ce951bc';
  static const int _pageSize = 20;
  static const int _timeoutSeconds = 15;
  static const int _maxImageValidationAttempts = 3;

  late final Dio _dio;

  NewsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: _timeoutSeconds),
        receiveTimeout: const Duration(seconds: _timeoutSeconds),
        queryParameters: {'apiKey': _apiKey},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          handler.next(e);
        },
      ),
    );
  }

  Future<List<ArticleModel>> fetchByCategory({
    required NewsCategory category,
    int page = 1,
  }) async {
    try {
      if (category == NewsCategory.pakistan) {
        final pakistanArticles = await _fetchPakistanArticles(page: page);
        if (pakistanArticles.isNotEmpty) {
          return pakistanArticles;
        }
      }

      final Map<String, dynamic> params = {
        'pageSize': _pageSize,
        'page': page,
      };

      String endpoint;

      if (category == NewsCategory.topHeadlines) {
        endpoint = '/top-headlines';
        params['country'] = category.country;
      } else {
        endpoint = '/top-headlines';
        params['country'] = 'us';
        if (category.apiCategory != null) {
          params['category'] = category.apiCategory;
        }
      }

      return _fetchValidatedArticles(
        endpoint: endpoint,
        baseQueryParameters: params,
        startPage: page,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NewsServiceException('Unexpected error: $e');
    }
  }

  Future<List<ArticleModel>> searchArticles({
    required String query,
    int page = 1,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return _fetchValidatedArticles(
        endpoint: '/everything',
        baseQueryParameters: {
          'q': query.trim(),
          'pageSize': _pageSize,
          'language': 'en',
          'sortBy': 'publishedAt',
        },
        startPage: page,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NewsServiceException('Unexpected error: $e');
    }
  }

  Future<List<ArticleModel>> fetchNotificationArticles() {
    return fetchByCategory(category: NewsCategory.topHeadlines);
  }

  Future<List<ArticleModel>> _fetchPakistanArticles({required int page}) async {
    final topHeadlines = await _fetchValidatedArticles(
      endpoint: '/top-headlines',
      baseQueryParameters: {
        'country': 'pk',
        'pageSize': _pageSize,
      },
      startPage: page,
    );
    if (topHeadlines.isNotEmpty) {
      return topHeadlines;
    }

    return _fetchValidatedArticles(
      endpoint: '/everything',
      baseQueryParameters: {
        'q': 'Pakistan OR Karachi OR Lahore OR Islamabad',
        'searchIn': 'title,description',
        'sortBy': 'publishedAt',
        'language': 'en',
        'pageSize': _pageSize,
      },
      startPage: page,
    );
  }

  List<ArticleModel> _parseArticles(dynamic data) {
    if (data == null || data['articles'] == null) {
      return [];
    }

    final List articles = data['articles'] as List;

    return articles
        .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
        .where(
          (article) =>
              article.title != null &&
              article.title != '[Removed]' &&
              article.url != null &&
              _hasUsableImage(article),
        )
        .toList();
  }

  Future<List<ArticleModel>> _fetchValidatedArticles({
    required String endpoint,
    required Map<String, dynamic> baseQueryParameters,
    required int startPage,
  }) async {
    final collected = <ArticleModel>[];
    final seenUrls = <String>{};

    for (var attempt = 0; attempt < _maxImageValidationAttempts; attempt++) {
      final page = startPage + attempt;
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          ...baseQueryParameters,
          'pageSize': _pageSize,
          'page': page,
        },
      );

      final parsed = _parseArticles(response.data);
      if (parsed.isEmpty) {
        if (attempt == 0) {
          return [];
        }
        break;
      }

      final validated = await _filterLoadableArticles(parsed);
      for (final article in validated) {
        final url = article.url;
        if (url == null || !seenUrls.add(url)) {
          continue;
        }
        collected.add(article);
        if (collected.length >= _pageSize) {
          return collected;
        }
      }
    }

    return collected;
  }

  Future<List<ArticleModel>> _filterLoadableArticles(
    List<ArticleModel> articles,
  ) async {
    final results = await Future.wait(
      articles.map((article) async {
        final imageUrl = article.urlToImage;
        if (imageUrl == null || imageUrl.isEmpty) {
          return null;
        }

        final isReachable = await _isImageLoadable(imageUrl);
        return isReachable ? article : null;
      }),
    );

    return results.whereType<ArticleModel>().toList();
  }

  bool _hasUsableImage(ArticleModel article) {
    final imageUrl = article.urlToImage;
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(imageUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return false;
    }

    final lowerUrl = imageUrl.toLowerCase();
    return !lowerUrl.contains('default') &&
        !lowerUrl.contains('placeholder') &&
        !lowerUrl.contains('removed') &&
        !lowerUrl.contains('/logo') &&
        !lowerUrl.contains('/icon') &&
        !lowerUrl.endsWith('.svg');
  }

  Future<bool> _isImageLoadable(String imageUrl) async {
    try {
      final response = await _dio.headUri(
        Uri.parse(imageUrl),
        options: Options(
          receiveTimeout: const Duration(seconds: 6),
          sendTimeout: const Duration(seconds: 6),
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final contentType = response.headers.value('content-type')?.toLowerCase();
      return contentType != null && contentType.startsWith('image/');
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  NewsServiceException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return const NewsServiceException(
          'Connection timed out. Please check your internet.',
          isNetworkError: true,
        );
      case DioExceptionType.connectionError:
        return const NewsServiceException(
          'No internet connection. Please try again.',
          isNetworkError: true,
        );
      default:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const NewsServiceException(
            'Invalid API key. Please check your NewsAPI key.',
          );
        }
        if (statusCode == 429) {
          return const NewsServiceException(
            'Too many requests. Please wait a moment and try again.',
          );
        }
        return NewsServiceException(
          'Failed to fetch news (${statusCode ?? 'unknown'}). Please try again.',
        );
    }
  }
}
