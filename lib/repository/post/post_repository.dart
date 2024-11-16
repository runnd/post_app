import 'package:product_app/data/remote/api_url.dart';
import 'package:product_app/data/remote/network_api_service.dart';
import 'package:product_app/models/post/Base_post_request.dart';
import 'package:product_app/models/post/post_base_response.dart';
import 'package:product_app/models/post/post_category.dart';



class PostRepository{
  final _api = NetworkApiService();

  Future<PostBaseResponse> getAllPostCategories(BasePostRequest req) async {
    var response = await _api.postApi(ApiUrl.postAppCategories, req.toJson());
    return PostBaseResponse.fromJson(response);
  }

  Future<PostBaseResponse> createPostCategory(PostCategory req) async {
    var response = await _api.postApi(ApiUrl.postCreateCategoryPath, req.toJson());
    return PostBaseResponse.fromJson(response);
  }

  Future<PostBaseResponse> getCategoryById(BasePostRequest req) async {
    var response = await _api.postApi(ApiUrl.postCategoryByIdPath+req.id.toString(), req.toJson());
    return PostBaseResponse.fromJson(response);
  }

  Future<PostBaseResponse> getAllPosts(BasePostRequest req) async {
    var response = await _api.postApi(ApiUrl.getAllPostPath, req.toJson());
    return PostBaseResponse.fromJson(response);
  }

  Future<PostBaseResponse> getPostById(BasePostRequest req) async {
    var response = await _api.postApi(ApiUrl.getPostByIdPath, req.toJson());
    return PostBaseResponse.fromJson(response);
  }

  Future<PostBaseResponse> createPost(BasePostRequest req) async {
    var response = await _api.postApi(ApiUrl.createPostPath, req.toJson());
    return PostBaseResponse.fromJson(response);
  }


}