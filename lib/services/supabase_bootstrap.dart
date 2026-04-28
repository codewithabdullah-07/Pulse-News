import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBootstrap {
  SupabaseBootstrap._();

  static bool _initialized = false;

  static String get url => dotenv.env['SUPABASE_URL']?.trim() ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
  static bool get isInitialized => _initialized;

  static SupabaseClient? get clientOrNull {
    if (!_initialized) {
      return null;
    }
    return Supabase.instance.client;
  }

  static Future<void> initialize() async {
    if (_initialized || !isConfigured) {
      return;
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _initialized = true;
  }
}
