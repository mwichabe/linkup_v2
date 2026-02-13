import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controllers.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (_, ctrl, __) => Scaffold(
        backgroundColor: AppTheme.background,
        body: ctrl.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.textSecondary),
              )
            : CustomScrollView(
                slivers: [
                  _buildAppBar(ctrl),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _ProfileHeader(ctrl: ctrl),
                        _ProfileHighlights(),
                        const Divider(
                            color: AppTheme.divider, height: 0.5),
                        _ProfileTabs(ctrl: ctrl),
                        const Divider(
                            color: AppTheme.divider, height: 0.5),
                      ],
                    ),
                  ),
                  _buildGrid(ctrl),
                  const SliverToBoxAdapter(
                      child: SizedBox(height: 80)),
                ],
              ),
      ),
    );
  }

  SliverAppBar _buildAppBar(ProfileController ctrl) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.background,
      elevation: 0,
      title: Row(
        children: [
          Text(
            ctrl.user.username,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.textPrimary,
            size: 22,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box_outlined,
              color: AppTheme.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  SliverPadding _buildGrid(ProfileController ctrl) {
    if (ctrl.selectedTab == 0) {
      return SliverPadding(
        padding: const EdgeInsets.all(2),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, i) {
              final post = ctrl.posts[i % ctrl.posts.length];
              return Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(url: post.media.first.url),
                  if (post.media.length > 1)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: 18,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 4)
                        ],
                      ),
                    ),
                ],
              );
            },
            childCount: ctrl.user.postsCount,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
        ),
      );
    }

    // Reels tab
    return SliverPadding(
      padding: const EdgeInsets.all(2),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(
                  url:
                      'https://picsum.photos/seed/reel${i + 10}/400/500'),
              const Positioned(
                bottom: 8,
                left: 8,
                child: Icon(Icons.play_arrow,
                    color: Colors.white, size: 20,
                    shadows: [
                      Shadow(color: Colors.black, blurRadius: 4)
                    ]),
              ),
            ],
          ),
          childCount: 9,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
      ),
    );
  }
}

// ─── Profile Header ──────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final ProfileController ctrl;
  const _ProfileHeader({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final u = ctrl.user;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Stats
          Row(
            children: [
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.storyGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.background,
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(u.avatarUrl),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ProfileStat(count: u.postsCount, label: 'Posts'),
              const Spacer(),
              ProfileStat(
                  count: u.followersCount, label: 'Followers'),
              const Spacer(),
              ProfileStat(
                  count: u.followingCount, label: 'Following'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          // Display name
          Text(
            u.displayName,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          // Bio
          if (u.bio.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              u.bio,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
          // Website
          if (u.website.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              u.website,
              style: const TextStyle(
                color: AppTheme.accent,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Edit profile',
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Share profile',
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 8),
              AppButton(
                label: '',
                isOutlined: true,
                icon: Icons.person_add_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Highlights ───────────────────────────────────────────────────────────────
class _ProfileHighlights extends StatelessWidget {
  final _highlightLabels = const [
    'Travel',
    'Food',
    'Fitness',
    'Art',
    'Friends',
  ];
  final _highlightImages = const [
    'https://picsum.photos/seed/hl1/200/200',
    'https://picsum.photos/seed/hl2/200/200',
    'https://picsum.photos/seed/hl3/200/200',
    'https://picsum.photos/seed/hl4/200/200',
    'https://picsum.photos/seed/hl5/200/200',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _highlightLabels.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, i) {
          if (i == 0) return _NewHighlight();
          final idx = i - 1;
          return _HighlightItem(
            label: _highlightLabels[idx],
            imageUrl: _highlightImages[idx],
          );
        },
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final String label;
  final String imageUrl;
  const _HighlightItem({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceVariant,
            ),
            child: ClipOval(child: AppNetworkImage(url: imageUrl)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewHighlight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppTheme.divider, width: 1),
            ),
            child: const Icon(
              Icons.add,
              color: AppTheme.textPrimary,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'New',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Tabs ─────────────────────────────────────────────────────────────
class _ProfileTabs extends StatelessWidget {
  final ProfileController ctrl;
  const _ProfileTabs({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            icon: Icons.grid_on,
            isSelected: ctrl.selectedTab == 0,
            onTap: () => ctrl.setTab(0),
          ),
        ),
        Expanded(
          child: _TabButton(
            icon: Icons.play_circle_outline,
            isSelected: ctrl.selectedTab == 1,
            onTap: () => ctrl.setTab(1),
          ),
        ),
        Expanded(
          child: _TabButton(
            icon: Icons.person_pin_outlined,
            isSelected: ctrl.selectedTab == 2,
            onTap: () => ctrl.setTab(2),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  isSelected ? AppTheme.textPrimary : Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? AppTheme.textPrimary
              : AppTheme.textTertiary,
          size: 24,
        ),
      ),
    );
  }
}
