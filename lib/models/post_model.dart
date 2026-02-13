import 'user_model.dart';

enum MediaType { image, video, carousel }

class MediaItem {
  final String url;
  final MediaType type;
  final double? aspectRatio;

  const MediaItem({
    required this.url,
    required this.type,
    this.aspectRatio,
  });
}

class CommentModel {
  final String id;
  final UserModel author;
  final String text;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;
  final List<CommentModel> replies;

  const CommentModel({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}

class PostModel {
  final String id;
  final UserModel author;
  final List<MediaItem> media;
  final String caption;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isSaved;
  final String? location;
  final List<String> tags;
  final List<CommentModel> previewComments;

  const PostModel({
    required this.id,
    required this.author,
    required this.media,
    this.caption = '',
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.location,
    this.tags = const [],
    this.previewComments = const [],
  });

  PostModel copyWith({
    String? id,
    UserModel? author,
    List<MediaItem>? media,
    String? caption,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isSaved,
    String? location,
    List<String>? tags,
    List<CommentModel>? previewComments,
  }) {
    return PostModel(
      id: id ?? this.id,
      author: author ?? this.author,
      media: media ?? this.media,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      previewComments: previewComments ?? this.previewComments,
    );
  }
}

class StoryModel {
  final String id;
  final UserModel author;
  final List<StoryItem> items;
  final bool isViewed;
  final bool hasActiveStory;

  const StoryModel({
    required this.id,
    required this.author,
    required this.items,
    this.isViewed = false,
    this.hasActiveStory = true,
  });
}

class StoryItem {
  final String id;
  final String url;
  final MediaType type;
  final DateTime expiresAt;
  final String? text;
  final bool isViewed;

  const StoryItem({
    required this.id,
    required this.url,
    required this.type,
    required this.expiresAt,
    this.text,
    this.isViewed = false,
  });
}

class ReelModel {
  final String id;
  final UserModel author;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String audioName;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isSaved;
  final bool isFollowing;
  final DateTime createdAt;

  const ReelModel({
    required this.id,
    required this.author,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.caption = '',
    this.audioName = 'Original Audio',
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.isFollowing = false,
    required this.createdAt,
  });

  ReelModel copyWith({
    bool? isLiked,
    bool? isSaved,
    bool? isFollowing,
    int? likesCount,
  }) {
    return ReelModel(
      id: id,
      author: author,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      caption: caption,
      audioName: audioName,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      viewsCount: viewsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt,
    );
  }
}

class NotificationModel {
  final String id;
  final UserModel actor;
  final NotificationType type;
  final String? postThumbnail;
  final String? postId;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.actor,
    required this.type,
    this.postThumbnail,
    this.postId,
    required this.createdAt,
    this.isRead = false,
  });
}

enum NotificationType {
  like,
  comment,
  follow,
  mention,
  tag,
  reelLike,
  storyReaction,
}
