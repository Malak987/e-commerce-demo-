import 'package:e_commerce_prof/Presentation_layer/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Business_logic_layer/products/products_cubit.dart';
import '../../../Business_logic_layer/recipes/recipes_cubit.dart';
import '../../../data_layer/Recipes/recipes_repository.dart';
import '../../../data_layer/Recipes/recipes_webservices.dart';
import '../../../data_layer/categories/categories_repository.dart';
import '../../../data_layer/categories/categories_web_services.dart';
import '../../../data_layer/products/products_repository.dart';
import '../../../data_layer/products/products_web_services.dart';
import '../home_page.dart';
import '../products/products.dart';
import '../profile_screen/profile_screen.dart';
import '../recipes/recipes.dart';
import '../../widgets/nav_bar/custom_bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 2; // 2 هو Home

  // قائمة الشاشات بدون BlocProvider هنا (سيتم تمريرها من الأعلى)
  final List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    // تهيئة الشاشات داخل initState لتجنب الأخطاء
    screens.addAll([
      const RecipesScreen(), // 0
      const ProductsScreen(), // 1
      HomeScreen(changeIndex: _changeIndex,), // 2 (نمرر دالة تغيير الـ Index)
      const CartScreen(), // 3
      ProfileScreen(), // 4
    ]);
  }

  // دالة لتغيير الـ Index من أي مكان
  void _changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductsCubit(
            repository: ProductsRepository(productsWebServices: ProductsWebServices()),
            categoriesRepository: CategoriesRepository(categoriesWebServices: CategoriesWebServices()),
          )..loadCategoriesAndFirstProducts(),
        ),
        BlocProvider(
          create: (_) => RecipesCubit(
            repository: RecipesRepository(recipesWebservices: RecipesWebservices()),
          )..loadTagsAndFirstRecipes(),
        ),
      ],
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,
          onTap: _changeIndex,
        ),
      ),
    );
  }
}