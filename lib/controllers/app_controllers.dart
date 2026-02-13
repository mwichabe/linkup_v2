import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/mock_data.dart';

// ─── Explore Controller ──────────────────────────────────────────────────────
class ExploreController extends ChangeNotifier {
  List<Map<String, dynamic>> _grid = [];
  List<UserModel> _suggestedUsers = [];
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isLoading = false;

  List<Map<String, dynamic>> get grid => _grid;
  List<UserModel> get suggestedUsers => _suggestedUsers;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;

  ExploreController() {
    _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _grid = MockData.exploreGrid;
    _suggestedUsers = MockData.suggestedUsers;
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    notifyListeners();
  }
}

// ─── Reels Controller ────────────────────────────────────────────────────────
class ReelsController extends ChangeNotifier {
  List<ReelModel> _reels = [];
  int _currentIndex = 0;
  bool _isLoading = false;

  List<ReelModel> get reels => _reels;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;

  ReelsController() {
    _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _reels = MockData.reels;
    _isLoading = false;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void toggleLike(String reelId) {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index == -1) return;
    final reel = _reels[index];
    _reels[index] = reel.copyWith(
      isLiked: !reel.isLiked,
      likesCount: reel.isLiked ? reel.likesCount - 1 : reel.likesCount + 1,
    );
    notifyListeners();
  }

  void toggleSave(String reelId) {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index == -1) return;
    final reel = _reels[index];
    _reels[index] = reel.copyWith(isSaved: !reel.isSaved);
    notifyListeners();
  }

  void toggleFollow(String reelId) {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index == -1) return;
    final reel = _reels[index];
    _reels[index] = reel.copyWith(isFollowing: !reel.isFollowing);
    notifyListeners();
  }
}

// ─── Notifications Controller ────────────────────────────────────────────────
class NotificationsController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  NotificationsController() {
    _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _notifications = MockData.notifications;
    _isLoading = false;
    notifyListeners();
  }

  void markAllRead() {
    _notifications = _notifications
        .map((n) => NotificationModel(
              id: n.id,
              actor: n.actor,
              type: n.type,
              postThumbnail: n.postThumbnail,
              postId: n.postId,
              createdAt: n.createdAt,
              isRead: true,
            ))
        .toList();
    notifyListeners();
  }
}

// ─── Profile Controller ──────────────────────────────────────────────────────
class ProfileController extends ChangeNotifier {
  UserModel _user = MockData.currentUser;
  List<PostModel> _posts = [];
  bool _isLoading = false;
  int _selectedTab = 0; // 0: grid, 1: reels, 2: tagged

  UserModel get user => _user;
  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  int get selectedTab => _selectedTab;

  ProfileController() {
    _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _posts = MockData.feedPosts.take(6).toList();
    _isLoading = false;
    notifyListeners();
  }

  void setTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }
}

// ─── Navigation Controller ───────────────────────────────────────────────────
class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
