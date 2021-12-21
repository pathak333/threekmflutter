import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/widgets/shop/restaurants/restaurants_menu.dart';


class RestaurantsHome extends StatelessWidget {
  const RestaurantsHome({Key? key, this.data}) : super(key: key);
  final Result? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F3F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 30),
            width: ThreeKmScreenUtil.screenWidthDp / 1.3,
            child: TextFormField(
              keyboardType: TextInputType.text,
              // controller: _firstName,
              validator: (val) {},

              decoration: const InputDecoration(
                hintText: 'Search Restaurant or Cusines',
                hintStyle: TextStyle(color: Color(0xFF0F0F2D)),
                counterText: '',
                filled: true,
                prefixIcon: Icon(Icons.search, color: Color(0xFF0F0F2D)),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Baner-Pashan Link Road'),
                  Text('Change Location')
                ],
              ),
            ),
            // Container(child: ListView.builder(
            //                 //controller: _scrollController,
            //                 shrinkWrap: true,
            //                 scrollDirection: Axis.horizontal,
            //                 itemCount: 2,
            //                 itemBuilder: (context, i) {
            //                   return Padding(
            //                     padding: const EdgeInsets.only(
            //                         left: 20, top: 10, bottom: 10),
            //                     child: ClipRRect(
            //                         borderRadius: BorderRadius.circular(10),
            //                         child: Image(
            //                             image: NetworkImage(data.advertisements[i].images.),
            //                             width: ThreeKmScreenUtil.screenWidthDp / 1.1888,
            //                             height: ThreeKmScreenUtil.screenHeightDp / 5,
            //                             fit: BoxFit.fill)),
            //                   );
            //                 }),,)
            // Row(
            //   children: const [
            //     Text(
            //       'Top Rated by Foodies',
            //       style: TextStyle(
            //           color: Color(0xFF0F0F2D),
            //           fontSize: 19,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     Spacer(),
            //     Text(
            //       'Sponsored',
            //       style: TextStyle(color: Color(0xFF8A939B)),
            //     )
            //   ],
            // ),
            // Container(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   margin: const EdgeInsets.only(bottom: 10),
            //   height: 330.0,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 10,
            //     itemBuilder: (BuildContext ctxt, int i) {
            //       return Container(
            //           // color: Colors.red,
            //           padding: const EdgeInsets.all(10),
            //           width: ThreeKmScreenUtil.screenWidthDp / 1.45,
            //           child: Material(
            //             elevation: 4,
            //             borderRadius:
            //                 const BorderRadius.all(Radius.circular(20)),
            //             child: Container(
            //                 padding: const EdgeInsets.only(
            //                     left: 3, right: 3, top: 3),
            //                 margin: const EdgeInsets.all(3),
            //                 decoration: const BoxDecoration(
            //                   color: Colors.white,
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(20)),
            //                 ),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Container(
            //                       height: 190.0,
            //                       child: ClipRRect(
            //                         borderRadius: const BorderRadius.all(
            //                             Radius.circular(20)),
            //                         child: CachedNetworkImage(
            //                           alignment: Alignment.topCenter,
            //                           placeholder: (context, url) =>
            //                               Transform.scale(
            //                             scale: 0.5,
            //                             child: CircularProgressIndicator(
            //                               color: Colors.grey[400],
            //                             ),
            //                           ),
            //                           imageUrl: '${data?.creators?[i].cover}',
            //                           height: ThreeKmScreenUtil.screenHeightDp / 1.8,
            //                           width: ThreeKmScreenUtil.screenWidthDp,
            //                           fit: BoxFit.fill,
            //                         ),
            //                       ),
            //                     ),
            //                     Container(
            //                       padding: const EdgeInsets.only(
            //                           left: 16, right: 16, top: 13),
            //                       alignment: Alignment.centerLeft,
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             '${data?.creators?[i].businessName}',
            //                             style: TextStyle(fontSize: 18),
            //                             maxLines: 2,
            //                           ),
            //                           Padding(
            //                               padding:
            //                                   const EdgeInsets.only(top: 10),
            //                               child: Text(
            //                                   '${data?.creators?[i].restaurant!.cuisines?.join(", ")}'))
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 )),
            //           ));
            //     },
            //   ),
            // ),
            // const Text(
            //   'Its 8:30PM, Breakfast Time!',
            //   style: TextStyle(
            //       color: Color(0xFF0F0F2D),
            //       fontSize: 19,
            //       fontWeight: FontWeight.bold),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   margin: const EdgeInsets.only(bottom: 10),
            //   height: 330.0,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 10,
            //     itemBuilder: (BuildContext ctxt, int i) {
            //       return Container(
            //           // color: Colors.red,
            //           padding: const EdgeInsets.all(10),
            //           width: ThreeKmScreenUtil.screenWidthDp / 1.45,
            //           child: Material(
            //             elevation: 4,
            //             borderRadius:
            //                 const BorderRadius.all(Radius.circular(20)),
            //             child: Container(
            //                 padding: const EdgeInsets.only(
            //                     left: 3, right: 3, top: 3),
            //                 margin: const EdgeInsets.all(3),
            //                 decoration: const BoxDecoration(
            //                   color: Colors.white,
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(20)),
            //                 ),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Container(
            //                       height: 190.0,
            //                       child: ClipRRect(
            //                         borderRadius: const BorderRadius.all(
            //                             Radius.circular(20)),
            //                         child: CachedNetworkImage(
            //                           alignment: Alignment.topCenter,
            //                           placeholder: (context, url) =>
            //                               Transform.scale(
            //                             scale: 0.5,
            //                             child: CircularProgressIndicator(
            //                               color: Colors.grey[400],
            //                             ),
            //                           ),
            //                           imageUrl: '${data?.creators?[i].cover}',
            //                           height: ThreeKmScreenUtil.screenHeightDp / 1.8,
            //                           width: ThreeKmScreenUtil.screenWidthDp,
            //                           fit: BoxFit.fill,
            //                         ),
            //                       ),
            //                     ),
            //                     Container(
            //                       padding: const EdgeInsets.only(
            //                           left: 16, right: 16, top: 13),
            //                       alignment: Alignment.centerLeft,
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             '${data?.creators?[i].businessName}',
            //                             style: TextStyle(fontSize: 18),
            //                             maxLines: 2,
            //                           ),
            //                           Padding(
            //                               padding:
            //                                   const EdgeInsets.only(top: 10),
            //                               child: Text(
            //                                   '${data?.creators?[i].restaurant!.cuisines?.join(", ")}'))
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 )),
            //           ));
            //     },
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          color: Color(0xFF0F0F2D),
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: data?.trending?.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        return Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE2E4E6)),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                alignment: Alignment.topCenter,
                                placeholder: (context, url) => Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                imageUrl: '${data?.trending?[i].image}',
                                height: ThreeKmScreenUtil.screenHeightDp / 15,
                                width: ThreeKmScreenUtil.screenWidthDp / 7,
                                fit: BoxFit.fill,
                              ),
                              Spacer(),
                              Text('${data?.trending?[i].name}')
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Restaurants',
                    style: TextStyle(
                        color: Color(0xFF0F0F2D),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  // Spacer(),
                  Row(
                    children: const [
                      Text(
                        'View all',
                        style: TextStyle(color: Color(0xFF43B978)),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF43B978),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data?.creators?.length,
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RestaurantMenu(
                                    data: data?.creators?[i],
                                  )));
                    },
                    child: Container(
                      // padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFE2E4E6))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ThreeKmScreenUtil.screenHeightDp / 4,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    alignment: Alignment.topCenter,
                                    placeholder: (context, url) =>
                                        Transform.scale(
                                      scale: 0.5,
                                      child: CircularProgressIndicator(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    imageUrl: '${data?.creators?[i].cover}',
                                    //height: ThreeKmScreenUtil.screenHeightDp / 5,
                                    width: ThreeKmScreenUtil.screenWidthDp,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      child: const Text(
                                        'Best Safety',
                                        style:
                                            TextStyle(color: Color(0xFF3E7EFF)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFF5C3D),
                                                Color(0xFFFF2A5F)
                                              ])),
                                      child: const Text(
                                        '50% off',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${data?.creators?[i].businessName}',
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF0F0F2D),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: ThreeKmScreenUtil.screenWidthDp / 1.3,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${data?.creators?[i].restaurant!.cuisines?.join(", ")}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF7572ED),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_forward_rounded),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}