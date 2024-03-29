import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/geoListIds_model.dart';
import 'package:threekm/Models/newsByCategories_model.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/main.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class NewsListProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;
  GeoListIds? _geoListIds;
  GeoListIds? get geoListIDS => _geoListIds;

  Future<Null> featchPostIds(requestJson, mounted) async {
    if (mounted) {
      try {
        _state = "loading";
        notifyListeners();
        final response =
            await _apiProvider.post(news_geo_list_category, requestJson);
        if (response != null) {
          if (response['status'] == 'success') {
            _geoListIds = GeoListIds.fromJson(response);
            notifyListeners();
          } else if (response['status'] == 'failed') {
            showMessage(response['error']);
          }
        }
      } on Exception catch (_) {
        _state = 'error';
        notifyListeners();
        showMessage("Error occured");
      }
    }
  }

  // getter for news
  NewsbyCategoryModel? _newsbyCategories;
  NewsbyCategoryModel? get newsBycategory => _newsbyCategories;

  Future<Null> getNewsPost(
      title, mounted, int takeCOunt, int skipCount, bool isNewCall) async {
    var tempList = _newsbyCategories?.data?.result?.posts;
    List postIds = [];
    final posts = geoListIDS!.data!.result!.posts;
    posts!.forEach((element) {
      postIds.add(element.postId);
    });
    //debugPrint("${partition(postIds, 10).take(2)}");

    debugPrint("${postIds.skip(0).take(10)}");
    String _token = await _apiProvider.getToken();
    String platForm = Platform.isAndroid ? 'Android' : 'Ios';
    String requestJson = json.encode({
      "post_ids": postIds.skip(skipCount).take(takeCOunt).toList(),
      "lang": "en",
      "page": 1,
      "token": _token,
      "query": title,
      "os": platForm
    });
    debugPrint("$requestJson");
    if (mounted) {
      try {
        final response =
            await _apiProvider.post(news_geo_page_list, requestJson);
        if (response != null && response["status"] == "success") {
          _newsbyCategories = NewsbyCategoryModel.fromJson(response);
          _state = 'loaded';
          if (tempList != null && isNewCall == false) {
            tempList.addAll(_newsbyCategories!.data!.result!.posts!);
            _newsbyCategories!.data!.result!.posts = tempList;
          }
          notifyListeners();
        } else if (response["status"] == "failed") {
          _state = "error";
          notifyListeners();
          CustomSnackBar(navigatorKey.currentContext!, Text(response["error"]));
        }
      } on Exception catch (e) {
        _state = 'error';
        notifyListeners();
        _newsbyCategories = null;
      }
    } else {
      _newsbyCategories?.data?.result?.posts?.clear();
    }
  }

  Future<Null> deleteList() async {
    _newsbyCategories?.data?.result?.posts?.clear();
  }

  Future<Null> postLike(String postId, String? emotion) async {
    String requestJson = json.encode(
        {"module": "news_post", "entity_id": postId, "emotion": "$emotion"});
    _newsbyCategories!.data!.result!.posts!.forEach((element) {
      if (element.postId.toString() == postId) {
        element.likes = element.likes! + 1;
        element.isLiked = true;
        notifyListeners();
      }
      //notifyListeners();
    });
    final response = await _apiProvider.post(like, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  Future<Null> postUnLike(String postId) async {
    String requestJson =
        json.encode({"module": "news_post", "entity_id": postId});
    _newsbyCategories!.data!.result!.posts!.forEach((element) {
      if (element.postId.toString() == postId) {
        element.isLiked = false;
        element.likes = element.likes! - 1;
        notifyListeners();
      }
    });
    final response = await _apiProvider.post(unlike, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  Future<void> onRefresh(requestJson, title, mounted, int takeCOunt,
      int skipCount, bool isNewCall) async {
    featchPostIds(requestJson, mounted).whenComplete(
        () => getNewsPost(title, mounted, takeCOunt, skipCount, isNewCall));
  }

  Future<Null> followUser(int autherId) async {
    String requestJson =
        json.encode({"entity": "user", "type": "user", "entity_id": autherId});
    final response = await _apiProvider.post(follow_User, requestJson);
    print(response);
    notifyListeners();
    try {
      if (response != null && response["status"] == "success") {
        _newsbyCategories!.data!.result!.posts!.forEach((element) {
          if (element.author?.id == autherId) {
            element.author!.isFollowed = true;
            notifyListeners();
            print(element.author!.isFollowed);
          }
        });
        notifyListeners();
      } else {
        CustomSnackBar(navigatorKey.currentContext!,
            Text("Error occuered.Please try later.!"));
      }
    } on SocketException {
      print("socket Exception");
      CustomSnackBar(
          navigatorKey.currentContext!, Text("Check your internet Connection"));
    }
  }

  Future<Null> unfollowUser(int autherId) async {
    String requestJson =
        json.encode({"entity": "user", "type": "user", "entity_id": autherId});
    final response = await _apiProvider.post(unfollow_user, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {
      _newsbyCategories!.data!.result!.posts!.forEach((element) {
        if (element.author?.id == autherId) {
          element.author!.isFollowed = false;
          notifyListeners();
          print(element.author!.isFollowed);
        }
      });
      //notifyListeners();
    }
    notifyListeners();
  }
}
