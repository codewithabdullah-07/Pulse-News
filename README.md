# 📰 Pulse News

> A premium Flutter news app — real-time, minimal, and production-ready.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Riverpod](https://img.shields.io/badge/State-Riverpod-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📱 Screenshots

> Coming soon — run locally and take your own!

---

## ✨ Features

| Feature | Status |
|---|---|
| Real-time news via NewsAPI | ✅ |
| 7 category filters (Pakistan, Global, Sports, Tech…) | ✅ |
| Horizontal animated category chips | ✅ |
| Pull-to-refresh | ✅ |
| Infinite scroll pagination | ✅ |
| Full article detail view | ✅ |
| Shimmer / skeleton loading UI | ✅ |
| Error handling with retry | ✅ |
| Keyword search with debounce | ✅ |
| Trending topics shortcuts | ✅ |
| Dark mode (persistent) | ✅ |
| Bookmark / save articles (Hive) | ✅ |
| Swipe-to-delete bookmarks | ✅ |
| Open article in browser | ✅ |
| Smooth page transitions | ✅ |
| Micro-animations (flutter_animate) | ✅ |
| Animated splash screen | ✅ |

---

## 🏗 Architecture

```
lib/
├── main.dart                     # App entry point
├── theme/
│   └── app_theme.dart            # Light/dark themes, colors, typography
├── models/
│   ├── article_model.dart        # Article data model + Hive adapter
│   └── category_model.dart       # NewsCategory enum with metadata
├── services/
│   ├── news_service.dart         # NewsAPI HTTP client (Dio)
│   └── bookmark_service.dart     # Hive local storage
├── providers/
│   └── app_providers.dart        # All Riverpod providers
├── widgets/
│   ├── news_card.dart            # Featured / Compact / Minimal cards
│   ├── shimmer_card.dart         # Skeleton loading placeholders
│   ├── category_chips.dart       # Animated chip selector
│   ├── error_view.dart           # Error state with retry
│   └── pulse_app_bar.dart        # Custom app bar
├── screens/
│   ├── splash_screen.dart        # Animated logo splash
│   ├── home_screen.dart          # Main feed + bottom navigation
│   ├── article_detail_screen.dart# Full article view
│   ├── search_screen.dart        # Search + trending topics
│   └── bookmarks_screen.dart     # Saved articles
└── utils/
    └── app_utils.dart            # Constants, extensions, helpers
```

---

## 🚀 Getting Started

### 1. Clone the project
```bash
git clone https://github.com/codewithabdullah-07/Pulse_News.git
cd pulse_news
```

### 2. Get your free API key
Sign up at [newsapi.org/register](https://newsapi.org/register) — it's free.

### 3. Add your API key
Open `lib/services/news_service.dart` and replace:
```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Run the app
```bash
flutter run
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `dio` | HTTP client with interceptors |
| `hive_flutter` | Local storage for bookmarks |
| `cached_network_image` | Efficient image loading/caching |
| `shimmer` | Skeleton loading UI |
| `flutter_animate` | Micro-animations |
| `google_fonts` | DM Sans + Playfair Display |
| `url_launcher` | Open articles in browser |
| `timeago` | Relative timestamps |
| `shared_preferences` | Persist dark mode preference |
| `iconsax` | Premium icon set |

---

## 🔑 API Notes

This app uses the [NewsAPI](https://newsapi.org) free tier:
- **Free plan**: 100 requests/day, dev use only
- **Paid plan**: For production / Play Store release
- Endpoint used: `top-headlines` (by country/category) and `everything` (search)

---

## 🎨 Design System

| Token | Value |
|---|---|
| Primary color | `#E63946` (Pulse Red) |
| Accent | `#457B9D` (Steel Blue) |
| Title font | Playfair Display |
| Body font | DM Sans |
| Card radius | 16–18px |
| Dark background | `#0A0A0F` |

---

## 🛣 Roadmap

- [ ] Notifications for breaking news
- [ ] Offline reading (full article cache)
- [ ] Share article functionality
- [ ] Source filter (BBC, CNN, etc.)
- [ ] Language preference setting
- [ ] iPad / tablet layout

---

## 👨‍💻 Built With

Flutter + Riverpod + Hive + NewsAPI  
Designed for portfolio showcase 🚀
