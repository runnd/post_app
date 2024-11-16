import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/data/remote/api_url.dart';
import 'package:product_app/data/status.dart';
import 'package:product_app/post/post/view_model/post_view_model.dart';
import 'package:product_app/routes/app_routes.dart';

class PostView extends StatelessWidget {
  var viewModel = Get.put(PostViewModel());
  PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2), // Updated color for AppBar
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Manage Post",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // viewModel.onCreate();
            },
            icon: Icon(Icons.add, color: Colors.white), // White color for icon
          )
        ],
      ),
      body: Obx(
        () {
          switch (viewModel.requestLoadingPostStatus.value) {
            case Status.loading:
              return Center(
                child: CircularProgressIndicator(
                  color:
                      Color(0xFF4A90E2), // Updated color for loading indicator
                ),
              );
            case Status.error:
              return Center(
                child: Text(
                  "Error loading data...",
                  style:
                      TextStyle(color: Color(0xFFB00020)), // Red for error text
                ),
              );
            case Status.completed:
              return ListView.builder(
                itemCount: viewModel.postList.length,
                itemBuilder: (context, index) {
                  var data = viewModel.postList[index];
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: "${ApiUrl.imageViewPath}1730532748284.jpg",
                        placeholder: (context, url) =>
                            Image.asset("assets/images/icons/no-image.jpg"),
                      ),
                      title: Text(
                        "${data.title}",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("${data.category?.name ?? 'No Category'}"),
                      trailing: GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteName.postManageCategoryCreatePath,
                              parameters: {"id": "${data.id}"});
                        },
                        child: Icon(
                          Icons.edit,
                          color:
                              Color(0xFF4A90E2), // Updated color for edit icon
                        ),
                      ),
                      onTap: () {
                        // Define what happens when a category is tapped
                        // For example, navigate to edit category screen
                      },
                    ),
                  );
                },
              );
            default:
              return SizedBox(); // Default case
          }
        },
      ),
    );
    ;
  }
}
