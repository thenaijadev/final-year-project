import 'package:flutter/material.dart';
import 'package:minimalist_social_app/features/daily_news/presentation/widgets/article_title_and_description.dart';
import 'package:minimalist_social_app/features/daily_news/presentation/widgets/news_image.dart';

class ArticleWidget extends StatelessWidget {
  final Map<String, dynamic>? article;
  final bool? isRemovable;
  // final void Function(Article article)? onRemove;
  // final void Function(Article article)? onArticlePressed;

  const ArticleWidget({
    Key? key,
    this.article,
    // this.onArticlePressed,
    this.isRemovable = false,
    // this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
            start: 14, end: 14, bottom: 7, top: 7),
        height: MediaQuery.of(context).size.width / 2.2,
        child: Row(
          children: [
            NewsImage(article: article),
            ArticleTitleAndDescription(article: article!),
            _buildRemovableArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea() {
    if (isRemovable!) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(Icons.remove_circle_outline, color: Colors.red),
      );
    }
    return Container();
  }

  // void _onTap() {
  //   if (onArticlePressed != null) {
  //     onArticlePressed!(article!);
  //   }
  // }

  // void _onRemove() {
  //   if (onRemove != null) {
  //     onRemove!(article!);
  //   }
  // }
}
