import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';
import 'package:threekm/UI/main/News/Widgets/comment_Loading.dart';
import 'package:threekm/UI/main/News/Widgets/likes_Loading.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:provider/provider.dart';
import 'package:threekm/widgets/emotion_Button.dart';
import 'package:threekm/widgets/video_widget.dart';

import 'package:threekm/widgets/reactions_assets.dart' as reactionAssets;

class NewsListPage extends StatefulWidget {
  final String title;
  NewsListPage({required this.title, Key? key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  String? initJson;

  pageInit() {
    //context.read<NewsListProvider>().state != 'loaded'
    if (true) {
      initJson =
          json.encode({"lat": '', "lng": '', "query": this.widget.title});
      Future.delayed(Duration.zero, () {
        context
            .read<NewsListProvider>()
            .featchPostIds(initJson, mounted)
            .whenComplete(() {
          context
              .read<NewsListProvider>()
              .getNewsPost(widget.title, mounted, 10, 0, true);
        });
      });
    }
  }

  @override
  void initState() {
    pageInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsListProvider>();
    return IndexedStack(children: [
      Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: ThreeKmTextConstants.tk18PXLatoBlackMedium,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return context
                .read<NewsListProvider>()
                .onRefresh(initJson, widget.title, mounted, 10, 0, true);
          },
          child: Builder(
            builder: (context) {
              if (newsProvider.state == "loading") {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (newsProvider.state == "error") {
                return Center(
                  child: Lottie.asset("assets/Caterror.json"),
                );
              } else if (newsProvider.state == "loaded") {
                return newsProvider.newsBycategory != null
                    ? NewsPostCard(
                        newsListProvider: newsProvider,
                        name: widget.title,
                      )
                    : Text("null");
              }
              return Container();
            },
          ),
        ),
      ),
    ]);
  }
}

class NewsPostCard extends StatefulWidget {
  final NewsListProvider newsListProvider;
  final String name;
  NewsPostCard({required this.newsListProvider, required this.name, Key? key})
      : super(key: key);

  @override
  _NewsPostCardState createState() => _NewsPostCardState();
}

class _NewsPostCardState extends State<NewsPostCard>
    with AutomaticKeepAliveClientMixin {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController _commentController = TextEditingController();
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  // for feching next post
  ScrollController _scrollController = ScrollController();
  int takeCount = 10;
  int skipCount = 0;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        takeCount += 10;
        skipCount += 10;
        context
            .read<NewsListProvider>()
            .getNewsPost(widget.name, mounted, takeCount, skipCount, false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    print("disposssssssssssssssssssssssssssssss");
    NewsListProvider? _newslistp;
    _newslistp?.deleteList();
    _newslistp?.newsBycategory?.data = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: widget.newsListProvider.newsBycategory?.data?.result?.posts != null
          ? ListView.builder(
              controller: _scrollController,
              itemCount: //50,
                  widget.newsListProvider.newsBycategory!.data!.result!.posts!
                      .length,
              itemBuilder: (context, postIndex) {
                final newsData = widget.newsListProvider.newsBycategory!.data!
                    .result!.posts![postIndex];
                if (newsData.postId != null) {
                  return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 8, bottom: 8),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xff32335E26),
                                        blurRadius: 8),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              newsData
                                                                  .author!.image
                                                                  .toString()))),
                                              child: newsData.isVerified == true
                                                  ? Stack(
                                                      children: [
                                                        Positioned(
                                                            left: 0,
                                                            child: Image.asset(
                                                              'assets/verified.png',
                                                              height: 15,
                                                              width: 15,
                                                              fit: BoxFit.cover,
                                                            ))
                                                      ],
                                                    )
                                                  : Container(),
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
                                                  0.35,
                                              child: Text(
                                                newsData.author!.name
                                                    .toString(),
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackBold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                                newsData.createdDate.toString())
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Consumer<NewsListProvider>(builder:
                                            (context, newsProvider, _) {
                                          return TextButton(
                                              onPressed: () {
                                                print(
                                                    "is foloowed:${newsData.author!.isFollowed}---------------------");
                                                print(
                                                    "post id is: ${newsData.postId}");
                                                if (newsData
                                                        .author!.isFollowed ==
                                                    true) {
                                                  print("is followed: true");
                                                  context
                                                      .read<NewsListProvider>()
                                                      .unfollowUser(newsData
                                                          .author!.id!
                                                          .toInt());
                                                } else if (newsData
                                                        .author!.isFollowed ==
                                                    false) {
                                                  print("is followed: false");
                                                  context
                                                      .read<NewsListProvider>()
                                                      .followUser(
                                                        newsData.author!.id!
                                                            .toInt(),
                                                      );
                                                }
                                              },
                                              child: newsData
                                                          .author!.isFollowed ==
                                                      true
                                                  ? Text("Following",
                                                      style: ThreeKmTextConstants
                                                          .tk11PXLatoGreyBold)
                                                  : Text("Follow",
                                                      style: ThreeKmTextConstants
                                                          .tk14PXPoppinsBlueMedium)
                                              // child: Text(
                                              //   newsData.author!.isFollowed != true
                                              //       ? "follow"
                                              //       : "following",
                                              //   style: newsData.author!.isFollowed == true
                                              //       ? ThreeKmTextConstants.tk11PXLatoGreyBold
                                              //       : ThreeKmTextConstants
                                              //           .tk14PXPoppinsBlueMedium,
                                              // ),
                                              );
                                        }),
                                        Spacer(),
                                        showPopMenu(newsData.postId.toString(),
                                            newsData)
                                        // IconButton(
                                        //     onPressed: () {}, icon: Icon(Icons.more_vert))
                                      ],
                                    ),
                                  ),
                                  //pic
                                  if (newsData.images != null &&
                                      newsData.images!.length > 0)
                                    CachedNetworkImage(
                                      height: 254,
                                      width: 338,
                                      fit: BoxFit.fill,
                                      imageUrl: '${newsData.images!.first}',
                                    )
                                  else if (newsData.videos != null &&
                                      newsData.videos!.length > 0)
                                    Stack(children: [
                                      Container(
                                        height: 254,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: VideoWidget(
                                            thubnail: newsData.videos?.first
                                                        .thumbnail !=
                                                    null
                                                ? newsData
                                                    .videos!.first.thumbnail
                                                    .toString()
                                                : '',
                                            url: newsData.videos!.first.src
                                                .toString(),
                                            play: false),
                                      ),
                                    ]),
                                  Row(children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 5, bottom: 2),
                                        child: InkWell(
                                          onTap: () {
                                            _showLikedBottomModalSheet(
                                                newsData.postId!.toInt(),
                                                newsData.likes);
                                          },
                                          child: Row(
                                            children: [
                                              Text('👍❤️😩'),
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffFC5E6A)),
                                                child: Center(
                                                    child: Text('+' +
                                                        newsData.likes
                                                            .toString())),
                                              )
                                            ],
                                          ),
                                        )),
                                    Spacer(),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, right: 5, bottom: 2),
                                        child: Text(newsData.views.toString() +
                                            ' Views'))
                                  ]),
                                  Text(
                                    newsData.submittedHeadline.toString(),
                                    style: ThreeKmTextConstants
                                        .tk14PXLatoBlackMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return newsDetails(newsData, context);
                                        }));
                                      },
                                      child: Text(
                                        "Read More",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      )),
                                  SizedBox(
                                    height: 35,
                                  ),
                                ],
                              )),
                            )
                          ]),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              height: 60,
                              width: 230,
                              child: ButtonBar(children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: EmotionButton(
                                      isLiked: newsData.isLiked!,
                                      initalReaction: newsData.isLiked!
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
                                      postId: newsData.postId!.toInt(),
                                      reactions: reactionAssets.reactions),
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
                                      onPressed: () async {
                                        // showLoading();
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
                                            newsData.createdDate,
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
                            )),
                      ]);
                } else {
                  return Container();
                }
                // return Container();
              },
            )
          : Text("No data"),
    );
  }

  // previous param String imgUrl, String name, String newsHeadLine, int index
  handleShare(String authorName, String authorProfile, String headLine,
      String thumbnail, date, String postId) async {
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
                    date,
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

  Widget newsDetails(newsData, context) {
    return Material(
      //color: Colors.black.withOpacity(0.1),
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
                                    left: 15, top: 5, right: 15, bottom: 10),
                                child: Row(
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
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          newsData.author!.image
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
                                            newsData.author!.name.toString(),
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsBlackBold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(newsData.createdDate.toString())
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    newsData.isVerified == true
                                        ? Image.asset(
                                            'assets/verified.png',
                                            height: 15,
                                            width: 15,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(),
                                    Spacer(),
                                    showPopMenu(
                                        newsData.postId.toString(), newsData)
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(Icons.more_vert))
                                  ],
                                ),
                              ),
                              if (newsData.images != null &&
                                  newsData.images!.length > 0)
                                CachedNetworkImage(
                                  height: 254,
                                  width: 338,
                                  fit: BoxFit.fill,
                                  imageUrl: '${newsData.images!.first}',
                                )
                              else if (newsData.videos != null &&
                                  newsData.videos!.length > 0)
                                Stack(children: [
                                  Container(
                                    height: 254,
                                    width: MediaQuery.of(context).size.width,
                                    child: VideoWidget(
                                        thubnail: newsData
                                                    .videos?.first.thumbnail !=
                                                null
                                            ? newsData.videos!.first.thumbnail
                                                .toString()
                                            : '',
                                        url: newsData.videos!.first.src
                                            .toString(),
                                        play: true),
                                  ),
                                ]),
                              Row(children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 2, left: 5, bottom: 2),
                                    child: Consumer<NewsListProvider>(
                                      builder: (context, newsProvider, _) {
                                        return Text(newsData.likes.toString() +
                                            ' Likes');
                                      },
                                    )),
                                Spacer(),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 2, right: 5, bottom: 2),
                                    child: Text(
                                        newsData.views.toString() + ' Views')),
                              ]),
                              SizedBox(height: 20),
                              Text(
                                newsData.submittedHeadline.toString(),
                                style:
                                    ThreeKmTextConstants.tk14PXLatoBlackMedium,
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: MediaQuery.of(context).size.height *
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
                  child:
                      ButtonBar(alignment: MainAxisAlignment.center, children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: Consumer<NewsListProvider>(
                        builder: (context, newslistProvider, _) {
                          return EmotionButton(
                              isLiked: newsData.isLiked!,
                              initalReaction: newsData.isLiked!
                                  ? Reaction(
                                      icon: Image.asset(
                                          "assets/thumbs_up_red.png"))
                                  : Reaction(
                                      icon:
                                          Image.asset("assets/thumbs-up.png")),
                              selectedReaction: newsData.isLiked!
                                  ? Reaction(
                                      icon: Image.asset(
                                          "assets/thumbs_up_red.png"))
                                  : Reaction(
                                      icon:
                                          Image.asset("assets/thumbs-up.png")),
                              postId: newsData.postId!.toInt(),
                              reactions: reactionAssets.reactions);
                        },
                      ),
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
                            _showCommentsBottomModalSheet(
                                context, newsData.postId);
                          },
                          icon: Image.asset('assets/icons-topic.png',
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
                            String imgUrl = newsData.images != null &&
                                    newsData.images!.length > 0
                                ? newsData.images!.first.toString()
                                : newsData.videos!.first.thumbnail.toString();
                            handleShare(
                                newsData.author!.name.toString(),
                                newsData.author!.image.toString(),
                                newsData.submittedHeadline.toString(),
                                imgUrl,
                                newsData.createdDate,
                                newsData.postId.toString());
                          },
                          icon: Center(
                            child: Image.asset('assets/icons-share.png',
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
    );
  }

  _showLikedBottomModalSheet(int postId, totalLikes) {
    context.read<LikeListProvider>().showLikes(context, postId);
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        final _likeProvider = context.watch<LikeListProvider>();
        return Padding(
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, _) {
                return Container(
                  color: Colors.white,
                  height: 192,
                  width: MediaQuery.of(context).size.width,
                  child: _likeProvider.isLoading
                      ? LikesLoding()
                      : Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 24, left: 18, bottom: 34),
                                  child: Text(
                                      "$totalLikes People reacted to this"),
                                ),
                              ],
                            ),
                            Container(
                              height: 90,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _likeProvider
                                    .likeList!.data!.result!.users!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: EdgeInsets.only(
                                        left: 21,
                                      ),
                                      height: 85,
                                      width: 85,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(_likeProvider
                                                  .likeList!
                                                  .data!
                                                  .result!
                                                  .users![index]
                                                  .avatar
                                                  .toString()))),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              right: 0,
                                              child: Image.asset(
                                                'assets/fblike2x.png',
                                                height: 15,
                                                width: 15,
                                                fit: BoxFit.cover,
                                              )),
                                          _likeProvider
                                                      .likeList!
                                                      .data!
                                                      .result!
                                                      .users![index]
                                                      .isUnknown !=
                                                  null
                                              ? Center(
                                                  child: Text(
                                                      "+${_likeProvider.likeList!.data!.result!.anonymousCount}",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                )
                                              : SizedBox.shrink()
                                        ],
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                );
              },
            ));
      },
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
              String imgUrl =
                  newsData.images != null && newsData.images!.length > 0
                      ? newsData.images!.first.toString()
                      : newsData.videos!.first.thumbnail.toString();
              handleShare(
                  newsData.author!.name.toString(),
                  newsData.author!.image.toString(),
                  newsData.submittedHeadline.toString(),
                  imgUrl,
                  newsData.createdDate,
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
}

/// Clip widget in oval shape at top side
class OvalTopBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 20);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
