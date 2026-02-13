import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controllers.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Consumer<NotificationsController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.textSecondary),
            );
          }

          final unread =
              ctrl.notifications.where((n) => !n.isRead).toList();
          final read =
              ctrl.notifications.where((n) => n.isRead).toList();

          return ListView(
            children: [
              // Follow requests teaser
              _FollowRequestsBanner(),
              // Unread
              if (unread.isNotEmpty) ...[
                _SectionHeader(
                    title: 'New', action: 'Mark all as read', onAction: ctrl.markAllRead),
                ...unread.map((n) => _NotificationTile(n: n)),
              ],
              // Read
              if (read.isNotEmpty) ...[
                const _SectionHeader(title: 'Earlier'),
                ...read.map((n) => _NotificationTile(n: n)),
              ],
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel n;
  const _NotificationTile({required this.n});

  String get _message {
    switch (n.type) {
      case NotificationType.like:
        return 'liked your photo.';
      case NotificationType.comment:
        return 'commented on your photo.';
      case NotificationType.follow:
        return 'started following you.';
      case NotificationType.mention:
        return 'mentioned you in a comment.';
      case NotificationType.tag:
        return 'tagged you in a photo.';
      case NotificationType.reelLike:
        return 'liked your reel.';
      case NotificationType.storyReaction:
        return 'reacted to your story.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: n.isRead ? Colors.transparent : AppTheme.surfaceVariant,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: n.isRead
                        ? null
                        : AppTheme.storyGradient,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(n.isRead ? 0 : 2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: n.isRead
                            ? Colors.transparent
                            : AppTheme.background,
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(n.actor.avatarUrl),
                      ),
                    ),
                  ),
                ),
                // Type icon
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _TypeIcon(type: n.type),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${n.actor.username} ',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: _message,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: ' ${FormatUtils.timeAgo(n.createdAt)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Post thumbnail or follow button
            if (n.postThumbnail != null)
              SizedBox(
                width: 44,
                height: 44,
                child: AppNetworkImage(
                  url: n.postThumbnail!,
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            else if (n.type == NotificationType.follow)
              AppButton(
                label: 'Follow',
                isSmall: true,
              ),
          ],
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final NotificationType type;
  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;

    switch (type) {
      case NotificationType.like:
      case NotificationType.reelLike:
        bgColor = AppTheme.like;
        icon = Icons.favorite;
        break;
      case NotificationType.comment:
      case NotificationType.mention:
        bgColor = AppTheme.accent;
        icon = Icons.mode_comment;
        break;
      case NotificationType.follow:
        bgColor = const Color(0xFF9B59B6);
        icon = Icons.person;
        break;
      case NotificationType.tag:
        bgColor = const Color(0xFF2ECC71);
        icon = Icons.label;
        break;
      case NotificationType.storyReaction:
        bgColor = AppTheme.storyGradientStart;
        icon = Icons.emoji_emotions;
        break;
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: AppTheme.background, width: 1.5),
      ),
      child: Icon(icon, size: 10, color: Colors.white),
    );
  }
}

class _FollowRequestsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Stacked avatars
            SizedBox(
              width: 60,
              height: 46,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: const CircleAvatar(
                      radius: 23,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=40'),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.background, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 23,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=45'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Follow requests',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Approve or ignore requests',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
