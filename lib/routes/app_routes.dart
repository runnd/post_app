import 'package:get/get.dart';
import 'package:product_app/modules/auth/view/login_screen.dart'; // Old Login Screen
import 'package:product_app/modules/home/view/home_screen.dart';
import 'package:product_app/modules/product/view/product_view.dart';
import 'package:product_app/modules/product/view/product_detail_view.dart';
import 'package:product_app/post/auth/login/view/login_view.dart'; // New Login View
import 'package:product_app/post/category/views/post_category_form_view.dart';
import 'package:product_app/post/category/views/post_category_view.dart';
import 'package:product_app/post/category/view_model/post_category_view_model.dart';
import 'package:product_app/post/post/views/post_view.dart';
import 'package:product_app/post/root/view/root_view.dart';
import 'package:product_app/post/splash/view/splash_view.dart';

class RouteName {
  static const String homeScreen = "/";
  static const String productScreen = "/product";
  static const String loginScreen = "/login"; // Old Login Screen route
  static const String productDetailScreen = "/product/details";
  static const String postRoot = "/post/root";
  static const String postLogin = "/post/login"; // New Login View route
  static const String postSplash = "/post/splash";
  static const String postManageCategory = "/post/manage/categories";
  static const String postManageCategoryCreatePath = "/post/manage/categories/create";
  static const String postManagePost = "/post/manage/post";
}

class AppRoute {
  static appRoutes() => [
    GetPage(
      name: RouteName.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.homeScreen,
      page: () => HomeScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RouteName.productScreen,
      page: () => ProductScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RouteName.productDetailScreen,
      page: () => const ProductDetailView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.postRoot,
      page: () => const RootView(),
    ),
    GetPage(
      name: RouteName.postLogin,
      page: () => LoginView(), // New Login View
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.postSplash,
      page: () => SplashView(),
    ),
    GetPage(
      name: RouteName.postManageCategory,
      page: () => PostCategoryView(),
    ),
    GetPage(
      name: RouteName.postManageCategoryCreatePath,
      page: () => PostCategoryFormView(),
    ),

    GetPage(
      name: RouteName.postManagePost,
      page: () => PostView(),
    ),

  ];
}
