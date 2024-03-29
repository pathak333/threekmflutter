import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/Commet_Model.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/main.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class CommentProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  List<AllComments>? _commentList;

  List<AllComments>? get commentList => _commentList;
  bool _isGettingComments = false;
  bool get isGettingComments => _isGettingComments;
  Future<Null> postCommentApi(int postId, String? comment) async {
    print("this is new post:$postId");
    String _token = await _apiProvider.getToken();
    String _requestJson = json.encode({
      "module": "news_post",
      "entity_id": postId,
      "comment": "$comment",
      "token": _token
    });
    final response = await _apiProvider.post(postComment, _requestJson);
    if (response != null && response['status'] == 'success') {
      //print(response);
      if (response['data']['result']['comments'] != null) {
        var data = response['data']['result']['comments'] as List;
        _commentList = data.map((e) => AllComments.fromJson(e)).toList();
      }
      _isGettingComments = false;
      notifyListeners();
    } else {
      _isGettingComments = false;
      notifyListeners();
      CustomSnackBar(
          navigatorKey.currentContext!, Text("Error while posting Comment"));
    }
  }

  Future<Null> removeComment(int _commentID, int _postId) async {
    _isGettingComments = true;
    String _requestJson = json.encode({
      "module": "news_post",
      "entity_id": _postId,
      "comment_id": _commentID
    });

    final response = await _apiProvider.post(deleteComment, _requestJson);
    if (response != null) {
      if (response != null && response['status'] == 'success') {
        //print(response);
        // if (response['data']['result']['comments'] != null) {
        //   var data = response['data']['result']['comments'] as List;
        //   _commentList = data.map((e) => AllComments.fromJson(e)).toList();
        // }
        // _isGettingComments = false;
        getAllCommentsApi(_postId).then((value) => notifyListeners());
      } else {
        CustomSnackBar(
            navigatorKey.currentContext!, Text("Error while Deleting Comment"));
        _isGettingComments = false;
        notifyListeners();
      }
    }
  }

  Future<Null> getAllCommentsApi(int _postId) async {
    _isGettingComments = true;
    notifyListeners();
    String _token = await _apiProvider.getToken();
    String _requestJson = json
        .encode({"module": "news_post", "entity_id": _postId, "token": _token});
    try {
      final response = await _apiProvider.post(getAllComments, _requestJson);
      if (response != null && response['status'] == 'success') {
        //print(response);
        if (response['data']['result']['comments'] != null) {
          var data = response['data']['result']['comments'] as List;
          _commentList = data.map((e) => AllComments.fromJson(e)).toList();
          _isGettingComments = false;
          notifyListeners();
        }
      }
    } on Exception catch (e) {
      _isGettingComments = false;
      notifyListeners();
      CustomSnackBar(navigatorKey.currentContext!,
          Text("Error while featching Comments!"));
    }
  }
}
