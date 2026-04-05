# 🛍️ E-Commerce Prof

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/Cubit%20%2F%20BLoC-9.x-FF6B35?style=for-the-badge)
![Hive](https://img.shields.io/badge/Hive-Local%20DB-FF7043?style=for-the-badge)
![Dio](https://img.shields.io/badge/Dio-Networking-6C63FF?style=for-the-badge)
![DummyJSON](https://img.shields.io/badge/API-DummyJSON-00C896?style=for-the-badge)

<br/>

> A full-featured Flutter e-commerce application built with **Clean Architecture**, **Cubit** state management, and **offline-first** local storage using Hive & SharedPreferences.

<br/>

[🚀 Getting Started](#-getting-started) · [🏗️ Architecture](#️-architecture) · [💾 Storage](#-local-storage-strategy) · [🌐 API](#-api--dummyjson)

</div>

---

## ✨ Features

<table>
<tr>
<td>

**🔐 Authentication**
- Login with JWT token
- Persistent session across restarts
- Auto-login on relaunch
- Secure logout with full data cleanup

</td>
<td>

**🛒 Shopping Cart**
- Add / Remove products
- Clear entire cart
- Persisted locally with Hive
- Survives app restarts & relaunch

</td>
</tr>
<tr>
<td>

**❤️ Wishlist**
- Favorite products & recipes
- Toggle with one tap
- Persisted with Hive
- Cleared on logout (per-user data)

</td>
<td>

**🍲 Recipes**
- Browse by tags
- Infinite scroll pagination
- Sort by name / cook time
- Full-text search

</td>
</tr>
<tr>
<td>

**🗂️ Products**
- Filter by category
- Sort by name / price
- Full-text search
- Add new products (POST API)

</td>
<td>

**👤 Profile**
- View full user info & avatar
- Wishlist shortcut
- Logout with confirmation dialog

</td>
</tr>
</table>

**+ OnBoarding** shown only once · **Smart Splash** with auto-routing based on session

---

## 🏗️ Architecture

```
lib/
│
├── Business_logic_layer/              # 🧠 Cubits & States
│   ├── cart/
│   │   ├── cart_cubit.dart
│   │   └── cart_state.dart
│   ├── favorite/
│   ├── login/
│   ├── products/
│   ├── recipes/
│   └── user/
│
├── data_layer/                        # 📦 Models, Repos, Services
│   ├── products/
│   │   ├── products.dart              # Model + toJson/fromJson
│   │   ├── products_adapter.dart      # Hive TypeAdapter (manual)
│   │   ├── products_repository.dart
│   │   └── products_web_services.dart
│   ├── Recipes/
│   │   ├── recipes.dart
│   │   ├── recipes_adapter.dart       # Hive TypeAdapter (manual)
│   │   ├── recipes_repository.dart
│   │   └── recipes_webservices.dart
│   ├── categories/
│   ├── user/
│   │   ├── user.dart
│   │   ├── user_local_data.dart       # Token + UserInfo persistence
│   │   ├── user_repository.dart
│   │   └── user_webservices.dart
│   └── helper/
│       ├── dio_helper.dart
│       └── dio_helper_recipes.dart
│
├── Presentation_layer/                # 🎨 UI Screens & Widgets
│   └── screens/
│       ├── on_boarding/
│       │   ├── on_boarding_screen.dart
│       │   └── splash_decider.dart    # Smart routing logic
│       ├── login/
│       ├── mainLayout/
│       ├── products/
│       ├── recipes/
│       ├── cart/
│       ├── favorite/
│       └── profile_screen/
│
├── app_initializer.dart               # Hive + Dio + SharedPrefs init
├── main.dart                          # MultiBlocProvider + AppRouter
└── styles/                            # Colors, Strings
```

---

## 🧠 Cubit — State Management

| Cubit | Responsibility |
|---|---|
| `CartCubit` | Add / Remove / Clear cart — Hive persisted |
| `FaveroiteCubit` | Toggle favorites for products & recipes |
| `ProductsCubit` | Load, filter by category, sort, search, add |
| `RecipesCubit` | Paginate, filter by tag, sort, search |
| `UserCubit` | Fetch & cache user, handle logout |
| `LoginCubit` | Login flow, token saving, error states |

---

## 💾 Local Storage Strategy

| Data | Storage | Why |
|---|---|---|
| 🛒 Cart (full Product objects) | **Hive** | Fast R/W for complex objects |
| ❤️ Favorite Products | **Hive** | Fast R/W for complex objects |
| ❤️ Favorite Recipes | **Hive** | Fast R/W for complex objects |
| 🔑 Access Token | **SharedPreferences** | Reliable on all Android versions |
| 👤 User Info (id, name, email…) | **SharedPreferences** | Simple key-value fields |
| 🎬 OnBoarding seen flag | **SharedPreferences** | Single boolean |

### Hive Setup

```dart
// AppInitializer — runs before runApp()
Hive.registerAdapter(ProductsAdapter()); // typeId: 1
Hive.registerAdapter(RecipesAdapter());  // typeId: 2

await Hive.openBox<Products>('cart_box');
await Hive.openBox<Products>('fav_products_box');
await Hive.openBox<Recipes>('fav_recipes_box');
```

> ✅ Manual TypeAdapters — no build_runner needed for storage

---

## 🌐 API — DummyJSON

**Base URL:** `https://dummyjson.com/`

| Method | Endpoint | Usage |
|---|---|---|
| `POST` | `/auth/login` | Login → JWT token |
| `GET` | `/auth/me` | Current user info |
| `GET` | `/products` | All products |
| `GET` | `/products/{id}` | Single product |
| `GET` | `/products/search?q=` | Search products |
| `GET` | `/products/category/{name}` | By category |
| `GET` | `/products/categories` | All categories |
| `POST` | `/products/add` | Add product |
| `GET` | `/recipes` | All recipes (paginated) |
| `GET` | `/recipes/{id}` | Single recipe |
| `GET` | `/recipes/search?q=` | Search recipes |
| `GET` | `/recipes/tag/{tag}` | By tag |
| `POST` | `/recipes/add` | Add recipe |
| `DELETE` | `/recipes/{id}` | Delete recipe |

---

## 🔄 App Flow

```
App Launch
    └── AppInitializer.init()
          ├── Hive.initFlutter()
          ├── Register Adapters (Products, Recipes)
          ├── Open Hive Boxes
          └── SharedPreferences.getInstance()

              └── SplashDecider
                    ├── seen_onboarding = false  →  OnBoarding → Login
                    ├── token exists             →  MainLayout ✅
                    └── no token                 →  Login

Logout
    ├── UserRepository.logout()              # clear token + user info
    ├── CartCubit.clearCartOnLogout()        # clear Hive cart_box
    └── FavoriteCubit.clearFavoritesOnLogout() # clear Hive fav boxes
         └── Navigate → Login
```

---

## 📦 Dependencies

```yaml
flutter_bloc: ^9.1.1        # State management
dio: ^5.9.2                 # HTTP client
retrofit: ^4.9.2            # Type-safe API calls
hive: ^2.2.3                # Local NoSQL database
hive_flutter: ^1.1.0        # Hive Flutter integration
shared_preferences: ^2.5.5  # Simple key-value storage
lottie: ^3.3.2              # Animations
smooth_page_indicator: ^2.0.1
flutter_native_splash: ^2.4.7
font_awesome_flutter: ^11.0.0
equatable: ^2.0.8
```

---

## 🚀 Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/Malak987/e-commerce-demo-.git
cd e-commerce-demo-

# 2. Install dependencies
flutter pub get

# 3. Generate splash screen
dart run flutter_native_splash:create

# 4. Generate launcher icons
dart run flutter_launcher_icons

# 5. Run
flutter run
```

> **Test credentials** (DummyJSON API):
> ```
> username: emilys
> password: emilyspass
> ```

---

## 👩‍💻 Author

<div align="center">

**Malak** — Flutter Developer

[![GitHub](https://img.shields.io/badge/GitHub-Malak987-181717?style=for-the-badge&logo=github)](https://github.com/Malak987/e-commerce-demo-)

</div>
