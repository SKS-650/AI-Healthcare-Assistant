import 'package:flutter/material.dart';
import '../../../domain/entities/article.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';
import '../../../../../../themes/app_spacing.dart';
import '../../../../../../shared/widgets/animated_press.dart';

class LatestArticlesList extends StatelessWidget {
  final List<Article> articles;
  const LatestArticlesList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _ArticleCard(article: articles[index]);
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final Article article;

  Color _categoryColor(String category) {
    return switch (category.toLowerCase()) {
      'nutrition' => const Color(0xFF22C55E),
      'mental health' => const Color(0xFF8B5CF6),
      'cardiology' => AppColors.emergency,
      'fitness' => const Color(0xFF06B6D4),
      _ => AppColors.primary,
    };
  }

  IconData _categoryIcon(String category) {
    return switch (category.toLowerCase()) {
      'nutrition' => Icons.restaurant_rounded,
      'mental health' => Icons.psychology_rounded,
      'cardiology' => Icons.favorite_rounded,
      'fitness' => Icons.fitness_center_rounded,
      _ => Icons.article_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(article.category);

    return AnimatedPress(
      onTap: () {},
      child: Container(
        width: 195,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.shadowCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 105,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    catColor.withValues(alpha: 0.25),
                    catColor.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _categoryIcon(article.category),
                      size: 44,
                      color: catColor.withValues(alpha: 0.7),
                    ),
                  ),
                  // Bookmark
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bookmark_border_rounded,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                      ),
                      child: Text(
                        article.category,
                        style: AppTextStyles.caption.copyWith(
                          color: catColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      style: AppTextStyles.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(article.readTime, style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
