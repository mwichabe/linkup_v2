import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/feed_controller.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/post_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<FeedController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoading) return const _FeedSkeleton();
          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              // Stories
              SliverToBoxAdapter(child: _StoriesRow(stories: ctrl.stories)),
              const SliverToBoxAdapter(
                child: Divider(color: AppTheme.divider, height: 0.5),
              ),
              // Posts
              if (ctrl.posts.isEmpty)
                const SliverFillRemaining(child: _EmptyFeed())
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final post = ctrl.posts[i];
                      return PostCard(
                        post: post,
                        onLike: () => ctrl.toggleLike(post.id),
                        onSave: () => ctrl.toggleSave(post.id),
                        onComment: () => _showComments(context, post),
                      );
                    },
                    childCount: ctrl.posts.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: AppTheme.background,
      elevation: 0,
      title: ShaderMask(
        shaderCallback: (bounds) =>
            AppTheme.logoGradient.createShader(bounds),
        child: const Text(
          'Instagram',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            fontFamily: 'Billabong',
            letterSpacing: 1,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box_outlined, size: 26),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, size: 26),
          onPressed: () {},
        ),
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.send_outlined, size: 26),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.like,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showComments(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) =>
            _CommentsSheet(post: post, scrollController: controller),
      ),
    );
  }
}

// ─── Stories Row ─────────────────────────────────────────────────────────────
class _StoriesRow extends StatelessWidget {
  final List<StoryModel> stories;
  const _StoriesRow({required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final story = stories[i];
          final isCurrentUser = i == 0;
          return StoryRingAvatar(
            user: story.author,
            hasStory: story.hasActiveStory,
            isViewed: story.isViewed,
            showAddButton: isCurrentUser,
            onTap: () => isCurrentUser
                ? null
                : _openStory(context, story),
          );
        },
      ),
    );
  }

  void _openStory(BuildContext context, StoryModel story) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _StoryViewer(story: story),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }
}

// ─── Story Viewer ─────────────────────────────────────────────────────────────
class _StoryViewer extends StatefulWidget {
  final StoryModel story;
  const _StoryViewer({required this.story});

  @override
  State<_StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<_StoryViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;
  int _currentItem = 0;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _nextItem();
      });
    _progressCtrl.forward();
  }

  void _nextItem() {
    if (_currentItem < widget.story.items.length - 1) {
      setState(() => _currentItem++);
      _progressCtrl.forward(from: 0);
    } else {
      Navigator.pop(context);
    }
  }

  void _prevItem() {
    if (_currentItem > 0) {
      setState(() => _currentItem--);
      _progressCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.story.items;
    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.story.author.avatarUrl),
              ),
              const SizedBox(height: 16),
              Text(widget.story.author.username,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: AppNetworkImage(url: items[_currentItem].url),
          ),
          // Tap zones
          Row(
            children: [
              Expanded(child: GestureDetector(onTap: _prevItem)),
              Expanded(child: GestureDetector(onTap: _nextItem)),
            ],
          ),
          // Progress bars
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: List.generate(items.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: i < _currentItem
                              ? 1.0
                              : i == _currentItem
                                  ? _progressCtrl.value
                                  : 0.0,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 2,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(widget.story.author.avatarUrl),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.story.author.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    FormatUtils.timeAgo(
                        items[_currentItem].expiresAt
                            .subtract(const Duration(hours: 23))),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          // Reply bar
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.6)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'Send message',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.send_outlined, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Comments Sheet ───────────────────────────────────────────────────────────
class _CommentsSheet extends StatelessWidget {
  final PostModel post;
  final ScrollController scrollController;

  const _CommentsSheet(
      {required this.post, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Comments',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.divider, height: 0.5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: post.previewComments.length * 3,
              itemBuilder: (_, i) {
                final comment =
                    post.previewComments[i % post.previewComments.length];
                return _CommentTile(comment: comment);
              },
            ),
          ),
          const Divider(color: AppTheme.divider, height: 0.5),
          _CommentInput(postAuthor: post.author.username),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.author.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${comment.author.username} ',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: comment.text,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      FormatUtils.timeAgo(comment.createdAt),
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${FormatUtils.formatCount(comment.likesCount)} likes',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Reply',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              const Icon(
                Icons.favorite_border,
                size: 14,
                color: AppTheme.textSecondary,
              ),
              Text(
                '${comment.likesCount}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final String postAuthor;
  const _CommentInput({required this.postAuthor});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          top: 8,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?img=1'),
              backgroundColor: AppTheme.surfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: const TextStyle(
                    color: AppTheme.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Add a comment for $postAuthor...',
                  hintStyle: const TextStyle(
                      color: AppTheme.textTertiary, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Post',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skeleton Loader ─────────────────────────────────────────────────────────
class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, i) => const _PostSkeleton(),
    );
  }
}

class _PostSkeleton extends StatefulWidget {
  const _PostSkeleton();

  @override
  State<_PostSkeleton> createState() => _PostSkeletonState();
}

class _PostSkeletonState extends State<_PostSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.7).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final color =
            AppTheme.surfaceVariant.withOpacity(_anim.value + 0.3);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: color, radius: 18),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 120, height: 12, color: color),
                      const SizedBox(height: 4),
                      Container(width: 80, height: 10, color: color),
                    ],
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(color: color),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, color: color),
                  const SizedBox(height: 8),
                  Container(width: double.infinity, height: 12, color: color),
                  const SizedBox(height: 4),
                  Container(width: 200, height: 12, color: color),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined,
              size: 64, color: AppTheme.textTertiary),
          SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
                color: AppTheme.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
