// MODIFIED BY CODEX — UI UPGRADE
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

class ShimmerNewsCard extends StatelessWidget {
  const ShimmerNewsCard({
    super.key,
    this.featured = false,
    required this.isDark,
  });

  final bool featured;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
      child: featured ? const _FeaturedSkeleton() : const _CompactSkeleton(),
    );
  }
}

class _FeaturedSkeleton extends StatelessWidget {
  const _FeaturedSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 92, height: 18),
                SizedBox(height: 14),
                _SkeletonLine(width: double.infinity, height: 20),
                SizedBox(height: 8),
                _SkeletonLine(width: 260, height: 20),
                SizedBox(height: 12),
                _SkeletonLine(width: double.infinity, height: 14),
                SizedBox(height: 8),
                _SkeletonLine(width: 180, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactSkeleton extends StatelessWidget {
  const _CompactSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(18, 8, 18, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 96, height: 12),
                SizedBox(height: 10),
                _SkeletonLine(width: double.infinity, height: 16),
                SizedBox(height: 7),
                _SkeletonLine(width: double.infinity, height: 16),
                SizedBox(height: 7),
                _SkeletonLine(width: 180, height: 16),
                SizedBox(height: 12),
                _SkeletonLine(width: 110, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    required this.isDark,
    this.count = 6,
  });

  final bool isDark;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 120),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (_, i) => ShimmerNewsCard(
        featured: i == 0,
        isDark: isDark,
      ),
    );
  }
}
