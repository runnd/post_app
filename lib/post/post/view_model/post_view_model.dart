import 'package:get/get.dart';
import 'package:product_app/data/status.dart';
import 'package:product_app/models/post/Base_post_request.dart';
import 'package:product_app/models/post/response/Post_response.dart';
import 'package:product_app/repository/post/post_repository.dart';

class PostViewModel extends GetxController {
  var postList = <PostResponse>[].obs;
  var requestLoadingPostStatus = Status.loading.obs;

  void setRequestLoadingPostStatus(Status value) {
    requestLoadingPostStatus.value = value;
  }

  final _postRepository = PostRepository();

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    setRequestLoadingPostStatus(Status.loading);
    // try {
      _getAllPost();
    // } finally {
      setRequestLoadingPostStatus(Status.completed);
    // }
  }

  _getAllPost() async {
    var req = BasePostRequest();
    var response = await _postRepository.getAllPosts(req);
    if (response.data != null) {
      response.data.forEach((data) {
        postList.add(PostResponse.fromJson(data));
      });
    }
  }
}
