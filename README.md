<<<<<<< HEAD
# 🛍️ E-Commerce Prof

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Bloc](https://img.shields.io/badge/Bloc%20%2F%20Cubit-9.x-FF6B6B?style=for-the-badge&logo=bloc&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-Local%20DB-FF7043?style=for-the-badge)
![DummyJSON](https://img.shields.io/badge/API-DummyJSON-6C63FF?style=for-the-badge)

**A full-featured Flutter e-commerce app with Clean Architecture, Cubit state management, and offline-first local storage.**

</div>

---

## 📱 Features

| Feature | Description |
|---|---|
| 🔐 Authentication | Login with JWT token, persistent session |
| 🛒 Shopping Cart | Add / Remove / Clear — saved locally with Hive |
| ❤️ Wishlist | Favorite products & recipes — persisted with Hive |
| 🍲 Recipes | Browse, search, sort, paginate recipes by tag |
| 🗂️ Categories | Filter products by category with real-time switching |
| 🔍 Search | Search products & recipes from API |
| ➕ Add Product | POST new products to the API |
| 👤 Profile | View user info, logout |
| 🌑 Onboarding | Shown only once on first launch |
| 💾 Offline Support | Cart & Favorites survive app restarts |

---

## 🏗️ Architecture

```
lib/
├── Business_logic_layer/       # Cubits & States
│   ├── cart/
│   ├── favorite/
│   ├── login/
│   ├── products/
│   ├── recipes/
│   └── user/
│
├── data_layer/                 # Models, Repositories, Web Services
│   ├── products/
│   ├── Recipes/
│   ├── categories/
│   ├── user/
│   └── helper/                 # DioHelper
│
├── Presentation_layer/         # UI Screens & Widgets
│   ├── screens/
│   │   ├── login/
│   │   ├── mainLayout/
│   │   ├── products/
│   │   ├── recipes/
│   │   ├── cart/
│   │   ├── favorite/
│   │   └── profile_screen/
│   └── widgets/
│
├── app_initializer.dart        # Hive + Dio init
├── main.dart                   # MultiBlocProvider + AppRouter
└── styles/                     # Colors, Strings
```

---

## 🧠 State Management — Cubit

| Cubit | Responsibility |
|---|---|
| `CartCubit` | Manage cart items via Hive box |
| `FaveroiteCubit` | Toggle favorites for products & recipes |
| `ProductsCubit` | Load, filter, sort, search, add products |
| `RecipesCubit` | Paginate, tag-filter, sort, search recipes |
| `UserCubit` | Fetch & cache user info |
| `LoginCubit` | Handle login flow & token saving |

---

## 💾 Local Storage Strategy

| Data | Storage | Reason |
|---|---|---|
| 🛒 Cart items (full objects) | **Hive** | Complex objects need fast read/write |
| ❤️ Favorite products | **Hive** | Complex objects |
| ❤️ Favorite recipes | **Hive** | Complex objects |
| 🔑 Access Token | **SharedPreferences** | Simple string, reliable on all Android versions |
| 👤 User info | **SharedPreferences** | Simple key-value fields |
| 🎬 Onboarding seen flag | **SharedPreferences** | Single boolean |

---

## 🌐 API — DummyJSON

Base URL: `https://dummyjson.com/`

| Endpoint | Usage |
|---|---|
| `POST /auth/login` | User login |
| `GET /auth/me` | Get current user |
| `GET /products` | All products |
| `GET /products/{id}` | Single product |
| `GET /products/search?q=` | Search products |
| `GET /products/category/{name}` | Products by category |
| `GET /products/categories` | All categories |
| `POST /products/add` | Add new product |
| `GET /recipes` | All recipes (paginated) |
| `GET /recipes/{id}` | Single recipe |
| `GET /recipes/search?q=` | Search recipes |
| `GET /recipes/tag/{tag}` | Recipes by tag |
| `POST /recipes/add` | Add new recipe |

---

## 📦 Dependencies

```yaml
# State Management
flutter_bloc: ^9.1.1

# Networking
dio: ^5.9.2
retrofit: ^4.9.2

# Local Storage
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.5.5

# UI
lottie: ^3.3.2
smooth_page_indicator: ^2.0.1
flutter_native_splash: ^2.4.7
flutter_launcher_icons: ^0.14.4
font_awesome_flutter: ^11.0.0

# Utilities
equatable: ^2.0.8
json_annotation: ^4.11.0
uuid: ^4.5.3
```

---

## 🚀 Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/your-username/e_commerce_prof.git
cd e_commerce_prof

# 2. Install dependencies
flutter pub get

# 3. Generate splash screen
dart run flutter_native_splash:create

# 4. Generate launcher icons
dart run flutter_launcher_icons

# 5. Run the app
flutter run
```

---

## 🔄 App Flow

```
Launch
  └── SplashDecider
        ├── First time?        → OnBoarding → Login
        ├── Has token?         → MainLayout (auto-login)
        └── No token?          → Login
```

---

## 🧩 Hive Adapters (Manual — No Code Generation)

```dart
// Products — typeId: 1
class ProductsAdapter extends TypeAdapter<Products> { ... }

// Recipes — typeId: 2
class RecipesAdapter extends TypeAdapter<Recipes> { ... }
```

Adapters are registered in `AppInitializer.init()` before `runApp()`.

---

## 📁 Key Files

| File | Purpose |
|---|---|
| `app_initializer.dart` | Initialize Hive, Dio, SharedPreferences |
| `main.dart` | MultiBlocProvider, AppRouter, MaterialApp |
| `splash_decider.dart` | Decide first screen based on token & onboarding |
| `user_local_data.dart` | Token + user info read/write |
| `cart_cubit.dart` | Cart logic with Hive persistence |
| `favorite_cubit.dart` | Favorites logic with Hive persistence |

---

## 👨‍💻 Author

Built with ❤️ using Flutter & DummyJSON API.
=======
# e-commerce-demo-
>>>>>>> 8376569f28264255ced37d5d3b164322891b711e
