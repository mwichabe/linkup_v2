class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final String bio;
  final String website;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;
  final bool isPrivate;
  final bool isFollowing;
  final List<String> highlights;

  const UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    this.bio = '',
    this.website = '',
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
    this.isPrivate = false,
    this.isFollowing = false,
    this.highlights = const [],
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? website,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isVerified,
    bool? isPrivate,
    bool? isFollowing,
    List<String>? highlights,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      isFollowing: isFollowing ?? this.isFollowing,
      highlights: highlights ?? this.highlights,
    );
  }
}
