import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    this.onComment,
    this.onShare,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  bool _showHeart = false;
  int _currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heartScale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.3)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.3, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
    ]).animate(_heartController);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (!widget.post.isLiked) widget.onLike();
    HapticFeedback.mediumImpact();
    setState(() => _showHeart = true);
    _heartController.forward(from: 0).then((_) {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(post),
        _buildMedia(post),
        _buildActions(post),
        _buildLikesRow(post),
        _buildCaption(post),
        _buildComments(post),
        _buildTimeAgo(post),
        const SizedBox(height: 8),
        const Divider(color: AppTheme.divider, height: 0.5),
      ],
    );
  }

  Widget _buildHeader(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar with story ring
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.storyGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.background,
                  ),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(post.author.avatarUrl),
                    backgroundColor: AppTheme.surfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.author.username,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (post.author.isVerified) ...[
                      const SizedBox(width: 4),
                      const VerifiedBadge(size: 12),
                    ],
                  ],
                ),
                if (post.location != null)
                  Text(
                    post.location!,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showPostOptions(context),
            child: const Icon(
              Icons.more_horiz,
              color: AppTheme.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(PostModel post) {
    if (post.media.isEmpty) return const SizedBox.shrink();

    return Stack(
      alignment: Alignment.center,
      children: [
        // Media
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: post.media.length == 1
              ? _buildSingleMedia(post.media.first)
              : _buildCarousel(post.media),
        ),
        // Heart animation on double tap
        if (_showHeart)
          ScaleTransition(
            scale: _heartScale,
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 90,
            ),
          ),
        // Carousel indicator
        if (post.media.length > 1)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentMediaIndex + 1}/${post.media.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSingleMedia(MediaItem media) {
    return AspectRatio(
      aspectRatio: 1,
      child: AppNetworkImage(url: media.url),
    );
  }

  Widget _buildCarousel(List<MediaItem> media) {
    return AspectRatio(
      aspectRatio: 1,
      child: PageView.builder(
        itemCount: media.length,
        onPageChanged: (i) => setState(() => _currentMediaIndex = i),
        itemBuilder: (_, i) => AppNetworkImage(url: media[i].url),
      ),
    );
  }

  Widget _buildActions(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _ActionButton(
            icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked ? AppTheme.like : AppTheme.textPrimary,
            size: 26,
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onLike();
            },
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: Icons.mode_comment_outlined,
            onTap: widget.onComment,
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: Icons.near_me_outlined,
            onTap: widget.onShare,
          ),
          const Spacer(),
          // Dot indicators for carousel
          if (post.media.length > 1) ...[
            Row(
              children: List.generate(
                post.media.length,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentMediaIndex
                        ? AppTheme.accent
                        : AppTheme.textTertiary,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
          _ActionButton(
            icon: post.isSaved
                ? Icons.bookmark
                : Icons.bookmark_border,
            onTap: widget.onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildLikesRow(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '${FormatUtils.formatCount(post.likesCount)} likes',
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCaption(PostModel post) {
    if (post.caption.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${post.author.username} ',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: post.caption,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComments(PostModel post) {
    if (post.previewComments.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.commentsCount > 2)
            GestureDetector(
              onTap: widget.onComment,
              child: Text(
                'View all ${FormatUtils.formatCount(post.commentsCount)} comments',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ...post.previewComments.take(2).map((c) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${c.author.username} ',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: c.text,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTimeAgo(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        FormatUtils.timeAgo(post.createdAt).toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textTertiary,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => const _PostOptionsSheet(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.color = AppTheme.textPrimary,
    this.size = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: size),
    );
  }
}

class _PostOptionsSheet extends StatelessWidget {
  const _PostOptionsSheet();

  @override
  Widget build(BuildContext context) {
    final options = [
      ('Report', Icons.flag_outlined, false),
      ('Not interested', Icons.do_not_disturb_outlined, false),
      ('Unfollow', Icons.person_remove_outlined, true),
      ('Share to...', Icons.share_outlined, false),
      ('Copy link', Icons.link, false),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ...options.map((o) => ListTile(
                  leading: Icon(
                    o.$2,
                    color: o.$3 ? AppTheme.like : AppTheme.textPrimary,
                  ),
                  title: Text(
                    o.$1,
                    style: TextStyle(
                      color: o.$3 ? AppTheme.like : AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                )),
          ],
        ),
      ),
    );
  }
}
