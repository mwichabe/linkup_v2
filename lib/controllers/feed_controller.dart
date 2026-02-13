import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/mock_data.dart';

class FeedController extends ChangeNotifier {
  List<PostModel> _posts = [];
  List<StoryModel> _stories = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  List<PostModel> get posts => _posts;
  List<StoryModel> get stories => _stories;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  FeedController() {
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));
    _posts = MockData.feedPosts;
    _stories = MockData.stories;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _posts = MockData.feedPosts;
    _stories = MockData.stories;
    _isRefreshing = false;
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    _posts[index] = post.copyWith(
      isLiked: !post.isLiked,
      likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );
    notifyListeners();
  }

  void toggleSave(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    _posts[index] = post.copyWith(isSaved: !post.isSaved);
    notifyListeners();
  }
}
