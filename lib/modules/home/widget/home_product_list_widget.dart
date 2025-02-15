import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/modules/home/controller/home_controller.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widgets/product_card_widget.dart';

class HomeProductListWidget extends StatelessWidget {
  HomeProductListWidget({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.loadingProduct.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.black12,
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
            itemCount: homeController.products.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var product = homeController.products[index];
              return ProductCardWidget(product: product, onTabImage: (){
                Get.toNamed("${RouteName.productDetailScreen}", arguments: product.id );
              },);
            }),
      );
    });
  }
}
