import 'package:dio/dio.dart';
import 'package:e_commerce_prof/Presentation_layer/screens/signup/sign_up.dart';
import 'package:e_commerce_prof/data_layer/user/user_repository.dart';
import 'package:e_commerce_prof/data_layer/user/user_webservices.dart';
import 'package:e_commerce_prof/styles/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'Business_logic_layer/cart/cart_cubit.dart';
import 'Business_logic_layer/favorite/favorite_cubit.dart';
import 'Business_logic_layer/login/login_cubit.dart';
import 'Business_logic_layer/products/products_cubit.dart';
import 'Business_logic_layer/user/user_cubit.dart';
import 'Presentation_layer/screens/cart/cart.dart';
import 'Presentation_layer/screens/favorite/favorite.dart';
import 'Presentation_layer/screens/home_page.dart';
import 'Presentation_layer/screens/login/login_screen.dart';
import 'Presentation_layer/screens/mainLayout/MainLayout.dart';
import 'Presentation_layer/screens/on_boarding/on_boarding_screen.dart';
import 'Presentation_layer/screens/on_boarding/splashdecider.dart';
import 'Presentation_layer/screens/products/products.dart';
import 'Presentation_layer/screens/products/singleProduct.dart';
import 'Presentation_layer/screens/profile_screen/profile_screen.dart';
import 'Presentation_layer/screens/recipes/recipes.dart';
import 'Presentation_layer/screens/recipes/single_recipes.dart';
import 'app_initializer.dart';
import 'data_layer/categories/categories_repository.dart';
import 'data_layer/categories/categories_web_services.dart';
import 'data_layer/products/products_repository.dart';
import 'data_layer/products/products_web_services.dart';

final AppRouter appRouter = AppRouter();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // ← مهم
  await AppInitializer.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ProductsRepository productsRepository =
  ProductsRepository(productsWebServices: ProductsWebServices());

  final CategoriesRepository categoriesRepository =
  CategoriesRepository(categoriesWebServices: CategoriesWebServices());
  final dio = Dio();
  late final userWebservices = UserWebservices(dio);
  late final userRepository = UserRepository(userWebservices);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (context) => ProductsCubit(
            repository: productsRepository,
            categoriesRepository: categoriesRepository,
          ),
        ),
        BlocProvider(
          create: (_) => CartCubit()..getCartItem(),
        ),
        BlocProvider(create: (_) => FaveroiteCubit()),
        BlocProvider(create: (_) => UserCubit(userRepository)),
        BlocProvider(
          create: (context) => LoginCubit(
            userRepository: userRepository,
            userCubit: context.read<UserCubit>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRoute,
        home: const SplashDecider(),
      ),
    );
  }
}

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (context) => const OnBoardingScreen());
      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case sign_up:
        return MaterialPageRoute(builder: (context) => const SignUp());
      case home_page:
        return MaterialPageRoute(builder: (context) =>  HomeScreen(changeIndex: (int p1) {  },));

      case mainLayout:
        return MaterialPageRoute(builder: (context) => const MainLayout());
      case products_ui:
        return MaterialPageRoute(builder: (context) => const ProductsScreen());
      case singleproduct_ui:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => SingleProductScreen(productId: productId),
        );
      case recipes_ui:
        return MaterialPageRoute(builder: (context) => const RecipesScreen());
      case single_recipe_ui:
        final recipeId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => SingleRecipeScreen(recipeId: recipeId),
        );
      case cart_ui:
        return MaterialPageRoute(builder: (context) => const CartScreen());
      case profile_ui:
        return MaterialPageRoute(builder: (context) =>  ProfileScreen());
      case favorite_ui:
        return MaterialPageRoute(builder: (context) =>  FavoriteScreen());


    }
    return null;
  }
}