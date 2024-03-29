import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';
import 'package:threekm/Custom_library/src/reaction.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/Widgets/singlePost_Loading.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:provider/provider.dart';
import 'package:threekm/widgets/video_widget.dart';
import 'package:threekm/widgets/reactions_assets.dart' as reactionAsset;

import 'Widgets/comment_Loading.dart';

class Postview extends StatefulWidget {
  final String postId;
  final String? image;
  Postview({required this.postId, this.image, Key? key}) : super(key: key);

  @override
  _PostviewState createState() => _PostviewState();
}

class _PostviewState extends State<Postview> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<SinglePostProvider>().getPostDetails(widget.postId, mounted);
    });
    super.initState();
  }

  @override
  void dispose() {
    SinglePostProvider? _singlepost;
    _singlepost!.resetRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postData = context.watch<SinglePostProvider>();
    final newsData = postData.postDetails?.data?.result?.post;
    return postData.isLoading != true
        ? Scaffold(
            body: Material(
              color: Colors.white,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 44,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop(false);
                              // setState(() => showNewsDetails = !showNewsDetails);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(left: 18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Color(0xFF0F0F2D),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            top: 5,
                                            right: 15,
                                            bottom: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                height: 50,
                                                width: 50,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: CachedNetworkImageProvider(
                                                              newsData!
                                                                  .author!.image
                                                                  .toString()))),
                                                )),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Text(
                                                    newsData.author!.name
                                                        .toString(),
                                                    style: ThreeKmTextConstants
                                                        .tk14PXPoppinsBlackBold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(newsData.author!.type
                                                    .toString())
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // newsData.author. == true
                                            //     ? Image.asset(
                                            //         'assets/verified.png',
                                            //         height: 15,
                                            //         width: 15,
                                            //         fit: BoxFit.cover,
                                            //       )
                                            //     : Container(),
                                            Spacer(),
                                            showPopMenu(
                                                newsData.postId.toString(),
                                                newsData)
                                          ],
                                        ),
                                      ),
                                      if (newsData.images!.isNotEmpty ||
                                          newsData.images!.length > 0) ...{
                                        CachedNetworkImage(
                                          height: 254,
                                          width: 338,
                                          fit: BoxFit.cover,
                                          imageUrl: '${newsData.images!.first}',
                                        )
                                      } else if (newsData.videos!.isNotEmpty ||
                                          newsData.videos!.length > 0) ...{
                                        Container(
                                          height: 254,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: VideoWidget(
                                            play: true,
                                            thubnail: newsData
                                                .videos!.first.thumbnail,
                                            url: newsData.videos!.first.src
                                                .toString(),
                                          ),
                                        )
                                      },
                                      // if (newsData.images != null &&
                                      //     newsData.images!.length > 0)
                                      //   CachedNetworkImage(
                                      //     height: 254,
                                      //     width: 338,
                                      //     fit: BoxFit.fill,
                                      //     imageUrl: '${newsData.images!.first}',
                                      //   )
                                      // else if (newsData.videos != null ||
                                      //     newsData.videos!.length > 0)
                                      //   Stack(children: [
                                      //     Container(
                                      //       height: 254,
                                      //       width:
                                      //           MediaQuery.of(context).size.width,
                                      //       child: VideoWidget(
                                      //           thubnail: newsData.videos?.first
                                      //                       .thumbnail !=
                                      //                   null
                                      //               ? newsData
                                      //                   .videos!.first.thumbnail
                                      //                   .toString()
                                      //               : '',
                                      //           url: newsData.videos!.first.src
                                      //               .toString(),
                                      //           play: true),
                                      //     ),
                                      //   ])
                                      // else
                                      //   Container(
                                      //     child: Text("no data"),
                                      //   ),
                                      Row(children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 2, left: 5, bottom: 2),
                                            child: Text(
                                                newsData.likes.toString() +
                                                    ' Likes')),
                                        Spacer(),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 2, right: 5, bottom: 2),
                                            child: Text(
                                                newsData.views.toString() +
                                                    ' Views')),
                                      ]),
                                      SizedBox(height: 20),
                                      Text(
                                        newsData.submittedHeadline.toString(),
                                        style: ThreeKmTextConstants
                                            .tk14PXLatoBlackMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1),
                                        child: HtmlWidget(
                                          newsData.story.toString(),
                                          textStyle: TextStyle(),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          color: Colors.blueAccent,
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.06,
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                Consumer<SinglePostProvider>(
                                    builder: (context, singlePost, _) {
                                  return Container(
                                    height: 60,
                                    width: 60,
                                    child: newsData.isLiked != null
                                        ? FlutterReactionButtonCheck(
                                            boxAlignment: Alignment.center,
                                            boxPosition: Position.TOP,
                                            onReactionChanged:
                                                (reaction, index, isChecked) {
                                              print(
                                                  'reaction selected index: $index');
                                              print("is checked $isChecked");
                                              if (newsData.isLiked == true) {
                                                print("remove Like");
                                                context
                                                    .read<SinglePostProvider>()
                                                    .postUnLike(newsData.postId
                                                        .toString());
                                              } else {
                                                print("Liked");
                                                context
                                                    .read<SinglePostProvider>()
                                                    .postLike(
                                                        newsData.postId
                                                            .toString(),
                                                        null);
                                              }
                                            },
                                            reactions: reactionAsset.reactions,
                                            initialReaction: newsData.isLiked!
                                                ? Reaction(
                                                    icon: Image.asset(
                                                        "assets/thumbs_up_red.png"))
                                                : Reaction(
                                                    icon: Image.asset(
                                                        "assets/thumbs-up.png")),
                                            selectedReaction: newsData.isLiked!
                                                ? Reaction(
                                                    icon: Image.asset(
                                                        "assets/thumbs_up_red.png"))
                                                : Reaction(
                                                    icon: Image.asset(
                                                        "assets/thumbs-up.png")),
                                          )
                                        : Container(),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                          )
                                        ]),
                                  );
                                }),
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: IconButton(
                                      onPressed: () {
                                        _showCommentsBottomModalSheet(
                                            context, newsData.postId!.toInt());
                                      },
                                      icon: Image.asset(
                                          'assets/icons-topic.png',
                                          fit: BoxFit.cover)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                        )
                                      ]),
                                ),
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: IconButton(
                                      onPressed: () {
                                        String imgUrl = newsData.images !=
                                                    null &&
                                                newsData.images!.length > 0
                                            ? newsData.images!.first.toString()
                                            : newsData.videos!.first.thumbnail
                                                .toString();
                                        handleShare(
                                            newsData.author!.name.toString(),
                                            newsData.author!.image.toString(),
                                            newsData.submittedHeadline
                                                .toString(),
                                            imgUrl,
                                            DateFormat('yyyy-MM-dd').format(
                                                newsData.postCreatedDate!),
                                            newsData.postId.toString());
                                      },
                                      icon: Center(
                                        child: Image.asset(
                                            'assets/icons-share.png',
                                            fit: BoxFit.contain),
                                      )),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                        )
                                      ]),
                                ),
                              ]),
                        ),
                      )
                    ],
                  )),
            ),
          )
        : SinglePostLoading();
  }

  PopupMenuButton showPopMenu(String postID, newsData) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            title: Text('Copy link'),
            onTap: () {
              Clipboard.setData(ClipboardData(
                      text: "https://3km.in/post-detail?id=$postID&lang=en"))
                  .then((value) => CustomSnackBar(
                      context, Text("Link has been coppied to clipboard")))
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              print("entry of share");
              String imgUrl =
                  newsData.images != null && newsData.images!.length > 0
                      ? newsData.images!.first.toString()
                      : newsData.videos!.first.thumbnail.toString();
              handleShare(
                  newsData.author!.name.toString(),
                  newsData.author!.image.toString(),
                  newsData.submittedHeadline.toString(),
                  imgUrl,
                  DateFormat('yyyy-MM-dd').format(newsData.postCreatedDate!),
                  newsData.postId.toString());
            },
            title: Text('Share to..',
                style: ThreeKmTextConstants.tk16PXLatoBlackRegular),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(
              'Cancel',
              style: ThreeKmTextConstants.tk16PXPoppinsRedSemiBold,
            ),
          ),
        ),
      ],
    );
  }

  _showCommentsBottomModalSheet(BuildContext context, int postId) {
    //print("this is new :$postId");
    context.read<CommentProvider>().getAllCommentsApi(postId);
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: 30,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                              height: 20,
                              width: 20,
                              child: Image.asset('assets/icons-topic.png')),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Consumer<CommentProvider>(
                              builder: (context, commentProvider, _) {
                            return commentProvider.commentList?.length != null
                                ? Text(
                                    "${commentProvider.commentList!.length}\tComments",
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold,
                                  )
                                : Text(
                                    "Comments",
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold,
                                  );
                          })
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<CommentProvider>(
                          builder: (context, commentProvider, _) {
                        return context.read<CommentProvider>().commentList !=
                                null
                            ? Expanded(
                                child: commentProvider.isGettingComments == true
                                    ? CommentsLoadingEffects()
                                    : ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        primary: true,
                                        itemCount:
                                            commentProvider.commentList!.length,
                                        itemBuilder: (context, commentIndex) {
                                          return Container(
                                            margin: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: ListTile(
                                              trailing: commentProvider
                                                          .commentList![
                                                              commentIndex]
                                                          .isself ==
                                                      true
                                                  ? IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                CommentProvider>()
                                                            .removeComment(
                                                                commentProvider
                                                                    .commentList![
                                                                        commentIndex]
                                                                    .commentId!,
                                                                postId);
                                                      },
                                                      icon: Icon(Icons.delete))
                                                  : SizedBox(),
                                              leading: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            commentProvider
                                                                .commentList![
                                                                    commentIndex]
                                                                .avatar
                                                                .toString()))),
                                              ),
                                              title: Text(
                                                commentProvider
                                                    .commentList![commentIndex]
                                                    .username
                                                    .toString(),
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackSemiBold,
                                              ),
                                              subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      commentProvider
                                                          .commentList![
                                                              commentIndex]
                                                          .comment
                                                          .toString(),
                                                      style: ThreeKmTextConstants
                                                          .tk14PXLatoBlackMedium,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                        commentProvider
                                                            .commentList![
                                                                commentIndex]
                                                            .timeLapsed
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic))
                                                  ]),
                                            ),
                                          );
                                        },
                                      ),
                              )
                            : SizedBox();
                      }),
                      Container(
                        height: 116,
                        width: 338,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _commentController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<CommentProvider>()
                                .postCommentApi(postId, _commentController.text)
                                .then((value) => _commentController.clear());
                          },
                          child: Container(
                            height: 36,
                            width: 112,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: ThreeKmTextConstants.blue2),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: ThreeKmTextConstants
                                    .tk14PXPoppinsWhiteMedium,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  handleShare(String authorName, String authorProfile, String headLine,
      String thumbnail, date, String postId) async {
    print("entry of handle share");
    showLoading();
    screenshotController
        .captureFromWidget(Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 50,
                  width: 50,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(authorProfile))),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      authorName,
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    date.toString(),
                    style: ThreeKmTextConstants.tk12PXLatoBlackBold,
                  )
                ],
              ),
              // SizedBox(
              //   width: 10,
              // ),
            ],
          ),
          Container(
              height: 254,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(imageUrl: thumbnail)),
          Text(
            headLine,
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30,
                  width: 250,
                  child: Image.asset(
                    'assets/playstore.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/icon_light.png')),
                )
              ],
            ),
          )
        ],
      ),
    ))
        .then((capturedImage) async {
      try {
        var documentDirectory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        File file = await File('${documentDirectory!.path}/image.png').create();
        file.writeAsBytesSync(capturedImage);
        Share.shareFiles([file.path],
                text: 'https://3km.in/post-detail?id=$postId&lang=en')
            .then((value) => hideLoading());
      } on Exception catch (e) {
        hideLoading();
      }
    });
  }
}
