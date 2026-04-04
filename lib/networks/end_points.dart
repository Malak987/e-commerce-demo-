// lib/networks/end_points.dart

const String LOGIN = "auth/login";
const String CURRENT_USER = "auth/me";

// #############################################################
// Products Endpoints
const String ALLPRODUCTS = "products";
const String PRODUCTS = "products?limit=0";

String singleProductPath(int id) => "products/$id";
const String PRODUCTS_CATEGORIES = "products/categories";
const String PRODUCTS_SEARCH = "products/search";
const String PRODUCTS_ADD = "products/add";
String productsByCategoryPath(String category) => "products/category/$category";

// ##############################################################
// Recipes Endpoints (DummyJSON)
const String RECIPES = "recipes";

// دالة لإنشاء الرابط مع الـ Pagination (limit & skip)
String allRecipesPath({int limit = 10, int skip = 0}) => "recipes?limit=$limit&skip=$skip";

String SingleRECIPESID(int id) => "recipes/$id";

// DummyJSON يبحث في المسار الرئيسي باستخدام query parameter 'q'
const String RECIPES_SEARCH = "recipes";

const String RECIPES_ADD = "recipes/add"; // ملاحظة: DummyJSON لا يدعم الإضافة الحقيقية
String recipesByTagPath(String tag, {int limit = 10, int skip = 0}) =>
    "recipes/tag/$tag?limit=$limit&skip=$skip";