import '../models/user_model.dart';
import '../models/post_model.dart';

class MockData {
  // ─── Users ───────────────────────────────────────────────────────────────
  static final UserModel currentUser = UserModel(
    id: 'u0',
    username: 'you',
    displayName: 'Your Name',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    bio: '📸 Photography | ✈️ Travel | 🌿 Nature\nLiving every moment.',
    website: 'yourwebsite.com',
    followersCount: 1284,
    followingCount: 412,
    postsCount: 47,
    isVerified: false,
  );

  static final List<UserModel> users = [
    UserModel(
      id: 'u1',
      username: 'alexandramorgan',
      displayName: 'Alexandra Morgan',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      bio: '🌊 Ocean lover | 📸 Photographer\nCapturing life\'s beauty',
      followersCount: 124500,
      followingCount: 312,
      postsCount: 283,
      isVerified: true,
      isFollowing: true,
    ),
    UserModel(
      id: 'u2',
      username: 'traveljake',
      displayName: 'Jake Wanderer',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      bio: '✈️ 47 countries and counting\n🗺️ Travel photographer',
      followersCount: 89200,
      followingCount: 502,
      postsCount: 612,
      isVerified: false,
      isFollowing: true,
    ),
    UserModel(
      id: 'u3',
      username: 'chefmia',
      displayName: 'Mia Chen',
      avatarUrl: 'https://i.pravatar.cc/150?img=20',
      bio: '👩‍🍳 Food creator & chef\n🍜 Sharing recipes daily',
      followersCount: 342000,
      followingCount: 891,
      postsCount: 1204,
      isVerified: true,
      isFollowing: false,
    ),
    UserModel(
      id: 'u4',
      username: 'fitnesswithomar',
      displayName: 'Omar Fitness',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      bio: '💪 Personal Trainer\n🏋️ Helping you reach your goals',
      followersCount: 56700,
      followingCount: 234,
      postsCount: 389,
      isVerified: false,
      isFollowing: true,
    ),
    UserModel(
      id: 'u5',
      username: 'artbyluna',
      displayName: 'Luna Art',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
      bio: '🎨 Digital artist | 🖌️ Illustrations\nCommissions open',
      followersCount: 78900,
      followingCount: 654,
      postsCount: 201,
      isVerified: false,
      isFollowing: false,
    ),
    UserModel(
      id: 'u6',
      username: 'urbanlens',
      displayName: 'Urban Lens',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      bio: '🏙️ City photography\n📷 Street & Architecture',
      followersCount: 212000,
      followingCount: 412,
      postsCount: 834,
      isVerified: true,
      isFollowing: true,
    ),
  ];

  // ─── Stories ─────────────────────────────────────────────────────────────
  static List<StoryModel> get stories {
    final now = DateTime.now();
    final expiry = now.add(const Duration(hours: 24));
    return [
      StoryModel(
        id: 's0',
        author: currentUser,
        items: [],
        isViewed: false,
        hasActiveStory: false,
      ),
      ...users.asMap().entries.map((e) {
        final i = e.key;
        final u = e.value;
        return StoryModel(
          id: 's${i + 1}',
          author: u,
          isViewed: i > 2,
          hasActiveStory: true,
          items: [
            StoryItem(
              id: 'si${i}_0',
              url: 'https://picsum.photos/seed/story${i}a/400/700',
              type: MediaType.image,
              expiresAt: expiry,
            ),
            StoryItem(
              id: 'si${i}_1',
              url: 'https://picsum.photos/seed/story${i}b/400/700',
              type: MediaType.image,
              expiresAt: expiry,
            ),
          ],
        );
      }),
    ];
  }

  // ─── Posts ───────────────────────────────────────────────────────────────
  static List<PostModel> get feedPosts {
    final now = DateTime.now();
    return [
      PostModel(
        id: 'p1',
        author: users[0],
        media: [
          MediaItem(
            url: 'https://picsum.photos/seed/post1/800/800',
            type: MediaType.image,
          ),
        ],
        caption:
            '🌅 Golden hour never disappoints. Every sunset is a promise of a new dawn. #photography #goldenhour #nature',
        createdAt: now.subtract(const Duration(minutes: 42)),
        likesCount: 4821,
        commentsCount: 143,
        sharesCount: 87,
        isLiked: true,
        location: 'Malibu, California',
        tags: ['photography', 'goldenhour', 'nature'],
        previewComments: [
          CommentModel(
            id: 'c1',
            author: users[1],
            text: 'Absolutely stunning! 😍',
            createdAt: now.subtract(const Duration(minutes: 30)),
            likesCount: 42,
          ),
          CommentModel(
            id: 'c2',
            author: users[3],
            text: 'The colors are incredible 🔥',
            createdAt: now.subtract(const Duration(minutes: 15)),
            likesCount: 18,
          ),
        ],
      ),
      PostModel(
        id: 'p2',
        author: users[1],
        media: [
          MediaItem(
            url: 'https://picsum.photos/seed/post2/800/1000',
            type: MediaType.image,
          ),
          MediaItem(
            url: 'https://picsum.photos/seed/post3/800/1000',
            type: MediaType.image,
          ),
          MediaItem(
            url: 'https://picsum.photos/seed/post4/800/1000',
            type: MediaType.image,
          ),
        ],
        caption:
            '🗺️ New country unlocked! The streets here are full of history and culture. #travel #wanderlust #explore',
        createdAt: now.subtract(const Duration(hours: 3)),
        likesCount: 7234,
        commentsCount: 298,
        sharesCount: 203,
        isLiked: false,
        location: 'Santorini, Greece',
        tags: ['travel', 'wanderlust', 'explore'],
        previewComments: [
          CommentModel(
            id: 'c3',
            author: users[4],
            text: 'Adding this to my bucket list! 🌍',
            createdAt: now.subtract(const Duration(hours: 2)),
            likesCount: 87,
          ),
        ],
      ),
      PostModel(
        id: 'p3',
        author: users[2],
        media: [
          MediaItem(
            url: 'https://picsum.photos/seed/food1/800/800',
            type: MediaType.image,
          ),
        ],
        caption:
            '🍜 Homemade ramen from scratch — 18 hours of love in every bowl. Recipe in the link in bio! #foodie #ramen #homecooking',
        createdAt: now.subtract(const Duration(hours: 6)),
        likesCount: 12483,
        commentsCount: 512,
        sharesCount: 1024,
        isLiked: false,
        isSaved: true,
        tags: ['foodie', 'ramen', 'homecooking'],
        previewComments: [
          CommentModel(
            id: 'c4',
            author: users[0],
            text: 'Made this last night, absolutely delicious! 😋',
            createdAt: now.subtract(const Duration(hours: 4)),
            likesCount: 156,
          ),
          CommentModel(
            id: 'c5',
            author: users[5],
            text: 'What broth do you use?',
            createdAt: now.subtract(const Duration(hours: 3)),
            likesCount: 23,
          ),
        ],
      ),
      PostModel(
        id: 'p4',
        author: users[3],
        media: [
          MediaItem(
            url: 'https://picsum.photos/seed/fitness1/800/900',
            type: MediaType.image,
          ),
        ],
        caption:
            '💪 Day 30 of the challenge — showing up even when it\'s hard is what builds character. Who\'s still with me? #fitness #motivation #gymlife',
        createdAt: now.subtract(const Duration(hours: 12)),
        likesCount: 3891,
        commentsCount: 247,
        sharesCount: 312,
        isLiked: true,
        tags: ['fitness', 'motivation', 'gymlife'],
        previewComments: [
          CommentModel(
            id: 'c6',
            author: users[2],
            text: 'Still going strong! Day 30! 💪🔥',
            createdAt: now.subtract(const Duration(hours: 10)),
            likesCount: 89,
          ),
        ],
      ),
      PostModel(
        id: 'p5',
        author: users[4],
        media: [
          MediaItem(
            url: 'https://picsum.photos/seed/art1/800/800',
            type: MediaType.image,
          ),
          MediaItem(
            url: 'https://picsum.photos/seed/art2/800/800',
            type: MediaType.image,
          ),
        ],
        caption:
            '🎨 New piece finished after 3 weeks of work. Swipe to see the process shots! What do you think? #digitalart #illustration #art',
        createdAt: now.subtract(const Duration(days: 1)),
        likesCount: 6721,
        commentsCount: 389,
        sharesCount: 445,
        isLiked: false,
        tags: ['digitalart', 'illustration', 'art'],
        previewComments: [
          CommentModel(
            id: 'c7',
            author: users[0],
            text: 'This is breathtaking! 🎨✨',
            createdAt: now.subtract(const Duration(hours: 20)),
            likesCount: 201,
          ),
        ],
      ),
      PostModel(
        id: 'p6',
        author: users[5],
        media: [
          MediaItem(
            url: 'https://picsum.photos/seed/city1/800/600',
            type: MediaType.image,
          ),
        ],
        caption:
            '🏙️ The city never sleeps, and neither does the beauty in its corners. #streetphotography #urban #citylife',
        createdAt: now.subtract(const Duration(days: 2)),
        likesCount: 9102,
        commentsCount: 178,
        sharesCount: 534,
        isLiked: true,
        isSaved: false,
        location: 'New York City, USA',
        tags: ['streetphotography', 'urban', 'citylife'],
        previewComments: [
          CommentModel(
            id: 'c8',
            author: users[3],
            text: 'NYC magic ✨',
            createdAt: now.subtract(const Duration(days: 1, hours: 22)),
            likesCount: 67,
          ),
        ],
      ),
    ];
  }

  // ─── Reels ───────────────────────────────────────────────────────────────
  static List<ReelModel> get reels {
    final now = DateTime.now();
    return [
      ReelModel(
        id: 'r1',
        author: users[0],
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        thumbnailUrl: 'https://picsum.photos/seed/reel1/400/700',
        caption: '🌊 Ocean therapy hits different ✨ #vibes #ocean #sunset',
        audioName: 'Sunset Dreams - Chill Beats',
        likesCount: 42100,
        commentsCount: 834,
        sharesCount: 2100,
        viewsCount: 284000,
        isLiked: true,
        isFollowing: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      ReelModel(
        id: 'r2',
        author: users[1],
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        thumbnailUrl: 'https://picsum.photos/seed/reel2/400/700',
        caption: '🗺️ Last day in paradise 😭 See you soon Bali! #bali #travel',
        audioName: 'Paradise - Original Sound',
        likesCount: 78300,
        commentsCount: 1203,
        sharesCount: 4500,
        viewsCount: 891000,
        isLiked: false,
        isFollowing: true,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      ReelModel(
        id: 'r3',
        author: users[2],
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        thumbnailUrl: 'https://picsum.photos/seed/reel3/400/700',
        caption: '🍳 5-minute breakfast that changed my life 😍 #foodhacks #cooking',
        audioName: 'Morning Groove - Lo-fi',
        likesCount: 124000,
        commentsCount: 4821,
        sharesCount: 12000,
        viewsCount: 2400000,
        isLiked: false,
        isFollowing: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ReelModel(
        id: 'r4',
        author: users[3],
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        thumbnailUrl: 'https://picsum.photos/seed/reel4/400/700',
        caption: '💪 10 min full body NO equipment workout 🔥 #fitness #workout',
        audioName: 'Power Up - Workout Mix',
        likesCount: 56700,
        commentsCount: 2341,
        sharesCount: 8900,
        viewsCount: 1200000,
        isLiked: true,
        isFollowing: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ReelModel(
        id: 'r5',
        author: users[4],
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        thumbnailUrl: 'https://picsum.photos/seed/reel5/400/700',
        caption: '🎨 Watch me draw this in real time ✍️ #art #timelapse #draw',
        audioName: 'Creative Flow - Ambient',
        likesCount: 34200,
        commentsCount: 987,
        sharesCount: 3400,
        viewsCount: 678000,
        isLiked: false,
        isFollowing: false,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  // ─── Notifications ────────────────────────────────────────────────────────
  static List<NotificationModel> get notifications {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 'n1',
        actor: users[0],
        type: NotificationType.like,
        postThumbnail: 'https://picsum.photos/seed/post1/200/200',
        postId: 'p1',
        createdAt: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n2',
        actor: users[1],
        type: NotificationType.follow,
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n3',
        actor: users[2],
        type: NotificationType.comment,
        postThumbnail: 'https://picsum.photos/seed/post3/200/200',
        postId: 'p3',
        createdAt: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n4',
        actor: users[3],
        type: NotificationType.like,
        postThumbnail: 'https://picsum.photos/seed/fitness1/200/200',
        postId: 'p4',
        createdAt: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n5',
        actor: users[4],
        type: NotificationType.mention,
        postThumbnail: 'https://picsum.photos/seed/art1/200/200',
        postId: 'p5',
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n6',
        actor: users[5],
        type: NotificationType.follow,
        createdAt: now.subtract(const Duration(hours: 12)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n7',
        actor: users[0],
        type: NotificationType.reelLike,
        postThumbnail: 'https://picsum.photos/seed/reel1/200/200',
        postId: 'r1',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  // ─── Explore Grid ─────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> get exploreGrid {
    return List.generate(30, (i) => {
      'id': 'eg$i',
      'url': 'https://picsum.photos/seed/explore$i/400/${i % 3 == 0 ? 600 : 400}',
      'type': i % 5 == 0 ? 'reel' : 'image',
      'isCarousel': i % 4 == 0,
      'likesCount': (1000 + i * 234) % 50000,
    });
  }

  // ─── Suggested Users ─────────────────────────────────────────────────────
  static List<UserModel> get suggestedUsers => [
    users[2],
    users[4],
    UserModel(
      id: 'u7',
      username: 'naturephotog',
      displayName: 'Nature Photos',
      avatarUrl: 'https://i.pravatar.cc/150?img=40',
      followersCount: 45200,
      isVerified: false,
    ),
    UserModel(
      id: 'u8',
      username: 'designbykai',
      displayName: 'Kai Designs',
      avatarUrl: 'https://i.pravatar.cc/150?img=45',
      followersCount: 29800,
      isVerified: false,
    ),
    UserModel(
      id: 'u9',
      username: 'mountainlife',
      displayName: 'Mountain Life',
      avatarUrl: 'https://i.pravatar.cc/150?img=50',
      followersCount: 103400,
      isVerified: true,
    ),
  ];
}
