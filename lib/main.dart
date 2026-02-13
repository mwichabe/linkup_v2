import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/feed_controller.dart';
import 'controllers/app_controllers.dart';
import 'views/home_view.dart';
import 'views/explore_view.dart';
import 'views/reels_view.dart';
import 'views/notifications_view.dart';
import 'views/profile_view.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const InstagramApp());
}

class InstagramApp extends StatelessWidget {
  const InstagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => FeedController()),
        ChangeNotifierProvider(create: (_) => ExploreController()),
        ChangeNotifierProvider(create: (_) => ReelsController()),
        ChangeNotifierProvider(create: (_) => NotificationsController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        title: 'Instagram MVP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const RootScaffold(),
      ),
    );
  }
}

class RootScaffold extends StatelessWidget {
  const RootScaffold({super.key});

  static const _screens = [
    HomeView(),
    ExploreView(),
    ReelsView(),
    NotificationsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (_, ctrl, __) {
        final isReels = ctrl.selectedIndex == 2;
        return Scaffold(
          backgroundColor: AppTheme.background,
          extendBody: true,
          body: IndexedStack(
            index: ctrl.selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: _AppBottomNav(
            selectedIndex: ctrl.selectedIndex,
            onTap: ctrl.setIndex,
            isReels: isReels,
          ),
        );
      },
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isReels;

  const _AppBottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.isReels,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isReels ? Colors.black : AppTheme.background;

    return Consumer<NotificationsController>(
      builder: (_, notifCtrl, __) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              top: BorderSide(
                color: isReels
                    ? Colors.transparent
                    : AppTheme.divider,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    isSelected: selectedIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.search,
                    activeIcon: Icons.search,
                    isSelected: selectedIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavItem(
                    icon: Icons.add_box_outlined,
                    activeIcon: Icons.add_box,
                    isSelected: selectedIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    isSelected: selectedIndex == 3,
                    badgeCount: notifCtrl.unreadCount,
                    onTap: () => onTap(3),
                  ),
                  _ProfileNavItem(
                    isSelected: selectedIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: Colors.white,
              size: 28,
            ),
            if (badgeCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.like,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _ProfileNavItem({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: ClipOval(
            child: Image.network(
              'https://i.pravatar.cc/150?img=1',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const CircleAvatar(
                backgroundColor: AppTheme.surfaceVariant,
                child: Icon(Icons.person, size: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
