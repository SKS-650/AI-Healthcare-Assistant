// lib/features/home/presentation/widgets/articles/article_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/article.dart';

class LatestArticlesList extends StatelessWidget {
  final List<Article> articles;
  const LatestArticlesList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final art = articles[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.article_outlined, color: Colors.grey.shade400, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
                      child: Text(art.category, style: TextStyle(color: Colors.blue.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Text(art.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2)),
                    const SizedBox(height: 4),
                    Text(art.readTime, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}