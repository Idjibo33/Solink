import 'package:flutter/material.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/utils/date_formatter.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        elevation: 0,
        color: Colors.black.withValues(alpha: 0.03),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                spacing: 8,
                children: [
                  UserAvatar(username: comment.userName, size: 16),
                  Expanded(
                    child: Text(
                      comment.userName,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    formatTimestamp(comment.creeLe),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              Text(comment.content, style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
