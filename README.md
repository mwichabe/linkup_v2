# Instagram MVP – Flutter

A pixel-perfect Instagram clone built with Flutter using the **MVC (Model-View-Controller)** architecture pattern.

---

## 📁 Project Structure

```
lib/
├── main.dart                   ← App entry point + Root scaffold
├── models/
│   ├── user_model.dart         ← User data model
│   ├── post_model.dart         ← Post, Story, Reel, Comment, Notification models
│   └── mock_data.dart          ← Realistic mock data service
├── controllers/
│   ├── feed_controller.dart    ← Feed state management
│   └── app_controllers.dart    ← Explore, Reels, Notifications, Profile, Nav controllers
├── views/
│   ├── home_view.dart          ← Feed + Stories + Story viewer
│   ├── explore_view.dart       ← Search + Grid explore
│   ├── reels_view.dart         ← Vertical reels pager
│   ├── notifications_view.dart ← Activity notifications
│   └── profile_view.dart       ← User profile + grid
├── widgets/
│   ├── shared_widgets.dart     ← Reusable: StoryRing, Avatar, Buttons, Stats
│   └── post_card.dart          ← Full post card with interactions
└── theme/
    └── app_theme.dart          ← Colors, typography, gradients, format utils
```

---

## 🏗️ Architecture: MVC

| Layer | Role | Examples |
|-------|------|---------|
| **Model** | Data + business logic | `UserModel`, `PostModel`, `MockData` |
| **View** | UI rendering only | `HomeView`, `ExploreView`, `ReelsView` |
| **Controller** | State management | `FeedController`, `ReelsController` |

> State management uses **`provider`** (`ChangeNotifier` + `Consumer<T>`) — lightweight and idiomatic Flutter MVC.

---

## ✨ Features

### 🏠 Home Feed
- Instagram-style scrollable story rail
- Full-screen story viewer with progress bar timer
- Post cards with:
  - Single image, carousel, and multi-image support
  - Double-tap heart animation
  - Like/comment/share/save actions
  - Caption with hashtag display
  - Location tags
  - Preview comments
  - Time ago display
  - Author header with story ring
- Pull-to-refresh
- Skeleton loading

### 🔍 Explore
- Animated search bar with cancel
- Category filter chips (For You, Reels, Photos, etc.)
- 3-column masonry grid
- Reel & carousel indicators on thumbnails
- User search results with follow state

### 🎬 Reels
- Full-screen vertical swipe pager
- Double-tap like animation
- Side action panel (like, comment, share, save, mute)
- Follow inline from reel
- Author info overlay with audio track

### 🔔 Notifications
- Grouped: New / Earlier
- Type-specific icons (like, comment, follow, mention)
- Story ring on unread notifications
- Post thumbnail previews
- Follow request banner
- Mark all as read

### 👤 Profile
- Stats (posts, followers, following)
- Bio, website
- Story highlights row
- 3-tab grid (Posts, Reels, Tagged)
- Edit/Share profile buttons

### 🎨 Design System
- True dark mode (#000000 background)
- Instagram gradient (orange→pink→purple)
- Accent blue (#0095F6)
- Like red (#ED4956)
- Verified badge component

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Install & Run

```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Build release APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management (MVC controllers) |
| `google_fonts` | Typography |
| `cached_network_image` | Efficient image loading |
| `shimmer` | Skeleton loading effect |
| `timeago` | Human-readable timestamps |
| `image_picker` | Camera/gallery access |
| `flutter_animate` | Smooth animations |

---

## 🔮 Extending to Production

To evolve this MVP into a production app:

1. **Backend**: Swap `MockData` with Firebase/Supabase/REST API
2. **Video**: Integrate `video_player` in `ReelsView` for real playback
3. **Auth**: Add Firebase Auth with `auth_controller.dart`
4. **Upload**: Wire `image_picker` to a real upload flow
5. **DMs**: Create a `messages_view.dart` + WebSocket controller
6. **Push Notifications**: Add Firebase Messaging to `NotificationsController`
7. **Caching**: Use `hive` or `sqflite` for offline-first data

---

## 📱 Screenshots

The app renders across iOS and Android with:
- Full dark theme
- Native system font
- System status bar integrated
- Safe area handling
- Responsive to screen sizes
# linkup_v2
