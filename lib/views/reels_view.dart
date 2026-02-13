import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controllers.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReelsController>(
      builder: (_, ctrl, __) {
        if (ctrl.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
            ),
            title: const Text(
              'Reels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: Colors.white, size: 28),
                onPressed: () {},
              ),
            ],
          ),
          body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: ctrl.reels.length,
            onPageChanged: ctrl.setCurrentIndex,
            itemBuilder: (_, i) => _ReelPage(
              reel: ctrl.reels[i],
              onLike: () => ctrl.toggleLike(ctrl.reels[i].id),
              onSave: () => ctrl.toggleSave(ctrl.reels[i].id),
              onFollow: () => ctrl.toggleFollow(ctrl.reels[i].id),
            ),
          ),
        );
      },
    );
  }
}

class _ReelPage extends StatefulWidget {
  final ReelModel reel;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onFollow;

  const _ReelPage({
    required this.reel,
    required this.onLike,
    required this.onSave,
    required this.onFollow,
  });

  @override
  State<_ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<_ReelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;
  late Animation<double> _heartAnim;
  bool _showHeart = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heartAnim = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.3)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.3, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
    ]).animate(_heartCtrl);
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (!widget.reel.isLiked) widget.onLike();
    HapticFeedback.mediumImpact();
    setState(() => _showHeart = true);
    _heartCtrl.forward(from: 0).then((_) {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reel = widget.reel;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background thumbnail
        AppNetworkImage(url: reel.thumbnailUrl),

        // Video overlay (simulated)
        Container(color: Colors.black.withOpacity(0.1)),

        // Play icon indicator
        Center(
          child: Icon(
            Icons.play_circle_fill,
            color: Colors.white.withOpacity(0.3),
            size: 64,
          ),
        ),

        // Double tap gesture
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Container(color: Colors.transparent),
        ),

        // Heart animation
        if (_showHeart)
          Center(
            child: ScaleTransition(
              scale: _heartAnim,
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),

        // Gradient overlay bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // Right side actions
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              _ReelAction(
                icon: reel.isLiked ? Icons.favorite : Icons.favorite_border,
                label: FormatUtils.formatCount(reel.likesCount),
                color: reel.isLiked ? AppTheme.like : Colors.white,
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onLike();
                },
              ),
              const SizedBox(height: 20),
              _ReelAction(
                icon: Icons.mode_comment_outlined,
                label: FormatUtils.formatCount(reel.commentsCount),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              _ReelAction(
                icon: Icons.send_outlined,
                label: FormatUtils.formatCount(reel.sharesCount),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              _ReelAction(
                icon: reel.isSaved ? Icons.bookmark : Icons.bookmark_border,
                label: '',
                onTap: widget.onSave,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => setState(() => _isMuted = !_isMuted),
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 20),
              // Author mini-avatar
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceVariant,
                  ),
                  child: ClipOval(
                    child: AppNetworkImage(url: reel.author.avatarUrl),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom info
        Positioned(
          left: 16,
          right: 80,
          bottom: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author
              Row(
                children: [
                  Text(
                    reel.author.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  if (reel.author.isVerified) ...[
                    const SizedBox(width: 4),
                    const VerifiedBadge(size: 14),
                  ],
                  if (!reel.isFollowing) ...[
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: widget.onFollow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Caption
              Text(
                reel.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Audio
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reel.audioName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Bottom nav safe area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
      ],
    );
  }
}

class _ReelAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ReelAction({
    required this.icon,
    required this.label,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
