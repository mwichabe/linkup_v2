import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

// ─── Story Ring Avatar ────────────────────────────────────────────────────────
class StoryRingAvatar extends StatelessWidget {
  final UserModel user;
  final double size;
  final bool hasStory;
  final bool isViewed;
  final bool showAddButton;
  final VoidCallback? onTap;

  const StoryRingAvatar({
    super.key,
    required this.user,
    this.size = 60,
    this.hasStory = true,
    this.isViewed = false,
    this.showAddButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: size + 6,
            height: size + 6,
            child: Stack(
              children: [
                // Gradient ring
                Container(
                  width: size + 6,
                  height: size + 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasStory && !isViewed
                        ? AppTheme.storyGradient
                        : null,
                    color: hasStory && isViewed
                        ? AppTheme.textTertiary
                        : null,
                  ),
                ),
                // White gap + avatar
                Center(
                  child: Container(
                    width: size + 2,
                    height: size + 2,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.background,
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: size / 2,
                        backgroundImage: NetworkImage(user.avatarUrl),
                        backgroundColor: AppTheme.surfaceVariant,
                      ),
                    ),
                  ),
                ),
                // Add button
                if (showAddButton)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accent,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: size + 6,
            child: Text(
              showAddButton ? 'Your Story' : user.username,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cached Network Image ────────────────────────────────────────────────────
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: AppTheme.surfaceVariant,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppTheme.textTertiary,
              ),
            ),
          ),
        );
      },
      errorBuilder: (ctx, _, __) => Container(
        width: width,
        height: height,
        color: AppTheme.surfaceVariant,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppTheme.textTertiary),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}

// ─── Verified Badge ──────────────────────────────────────────────────────────
class VerifiedBadge extends StatelessWidget {
  final double size;

  const VerifiedBadge({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified,
      size: size,
      color: AppTheme.accent,
    );
  }
}

// ─── Count + Label Stat ──────────────────────────────────────────────────────
class ProfileStat extends StatelessWidget {
  final int count;
  final String label;

  const ProfileStat({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          FormatUtils.formatCount(count),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── App Button ───────────────────────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isOutlined;
  final bool isSmall;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isOutlined = false,
    this.isSmall = false,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: isSmall ? 30 : 36,
        padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppTheme.accent,
          borderRadius: BorderRadius.circular(8),
          border: isOutlined
              ? Border.all(color: AppTheme.divider, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, size: 14, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isOutlined ? AppTheme.textPrimary : Colors.white,
                  fontSize: isSmall ? 13 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
