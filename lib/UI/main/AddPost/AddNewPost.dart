import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:threekm/UI/Location/PostLocation.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/utils/utils.dart';
import 'package:provider/provider.dart';

class AddNewPost extends StatefulWidget {
  const AddNewPost({Key? key}) : super(key: key);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  var padding = EdgeInsets.only(
    right: 18,
    left: 18,
  );

  int headlineCount = 0;
  int descriptionCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NEW POST",
          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Post",
                style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
              ))
        ],
        backgroundColor: Color(0xff0F0F2D),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Space Top of headline
                  SizedBox(
                    height: 18,
                  ),
                  // Headline
                  buildHeadline,
                  // Space top of headline input
                  SizedBox(
                    height: 7,
                  ),
                  // Headline input
                  Container(
                    padding: padding,
                    height: 52,
                    child: TextField(
                      // controller: controller.headlineController,
                      maxLines: 1,
                      minLines: null,
                      expands: false,
                      maxLength: 50,
                      textAlignVertical: TextAlignVertical.top,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        WidgetsBinding.instance!
                            .addPostFrameCallback((timeStamp) {
                          setState(() {
                            headlineCount = currentLength;
                          });
                        });
                        return Container(
                          height: 1,
                        );
                      },
                      style:
                          ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
                        color: Color(0xFF0F0F2D),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Divider
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color(0xFFD5D5D5),
                    thickness: 0.5,
                  ),
                  // Space top of description
                  SizedBox(
                    height: 24,
                  ),
                  // Description
                  buildDescription,
                  // Space top of description input
                  SizedBox(
                    height: 8,
                  ),
                  // Description input
                  Container(
                    padding: padding,
                    height: 135,
                    child: TextField(
                      //controller: controller.descriptionController,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      maxLength: 250,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        WidgetsBinding.instance!
                            .addPostFrameCallback((timeStamp) {
                          setState(() {
                            descriptionCount = currentLength;
                          });
                        });
                        Container(
                          height: 1,
                        );
                      },
                      style:
                          ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
                        color: Color(0xFF0F0F2D),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Spaced before divider
                  SizedBox(
                    height: 32,
                  ),
                  // Divider
                  Divider(
                    color: Color(0xFFD5D5D5),
                    thickness: 0.5,
                  ),
                  // Spacer for tags
                  SizedBox(
                    height: 16,
                  ),
                  // Tags
                  Container(
                    padding: padding,
                    child: Text(
                      "Tags".toUpperCase(),
                      style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular
                          .copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F0F2D),
                      ),
                    ),
                  ),
                  // Spacer after tags
                  SizedBox(
                    height: 12,
                  ),
                  // Tag List
                  //buildTags,
                  // Spacer for divider on location
                  SizedBox(
                    height: 16,
                  ),
                  // Divider
                  Divider(
                    color: Color(0xFFD5D5D5),
                    thickness: 0.5,
                  ),
                  // Location
                  Builder(
                    builder: (_controller) => Container(
                      padding: padding,
                      child: Row(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            margin: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF4F3F8),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.place_rounded,
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              // child: Text(
                              //   "${_controller.address?.street ?? "Unspecified location"}"
                              //       .toUpperCase(),
                              //   style: ThreeKmTextConstants
                              //       .tk12PXPoppinsWhiteRegular
                              //       .copyWith(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w500,
                              //     color: Color(0xFF0F0F2D),
                              //   ),
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ),
                          ),
                          SizedBox(width: 16),
                          InkWell(
                            onTap: () async {
                              context
                                  .read<LocationProvider>()
                                  .getLocation()
                                  .whenComplete(() {
                                final locationProvider =
                                    context.watch<LocationProvider>();
                                if (locationProvider.ispermitionGranted) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostLocation(
                                              lattitude:
                                                  locationProvider.getLatitude!,
                                              longitude: locationProvider
                                                  .getLangitude!)));
                                }
                              });
                              // await Navigator.of(context)
                              //     .pushNamed(LocationBasePage.path);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F3F8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "Change",
                                  style: ThreeKmTextConstants
                                      .tk12PXPoppinsWhiteRegular
                                      .copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF3E7EFF)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider
                  Divider(
                    color: Color(0xFFD5D5D5),
                    thickness: 0.5,
                  ),
                  SizedBox(
                    height: 110,
                  ),
                ],
              ),
            ),
            buildFooter
          ],
        ),
      ),
    );
  }

  Widget get buildHeadline {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Headline".toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: headlineCount > 0 ? Color(0xFF979EA4) : Color(0xFF0F0F2D),
            ),
          ),
          Text(
            "($headlineCount/50)",
            style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF979EA4),
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildDescription {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Description".toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  descriptionCount > 0 ? Color(0xFF979EA4) : Color(0xFF0F0F2D),
            ),
          ),
          Text(
            "($descriptionCount/250)",
            style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF979EA4),
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildFooter {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 84,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        color: Color(0xFFF4F3F8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.grid_view,
              size: 24,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 2),
                child: Text(
                  "Advance".toUpperCase(),
                  style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(
                    color: Color(0xFF0F0F2D),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Icon(
              Icons.arrow_forward,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Widget get buildTags {
  //   return Container(
  //     padding: padding,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Builder(
  //         builder: (controller) => Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: controller.tags.length > 0
  //                 ? [
  //                     ...controller.tags.asMap().entries.map((e) {
  //                       return GestureDetector(
  //                         onTap: () => controller.changeTagStatus(e.key),
  //                         child: Container(
  //                           margin: EdgeInsets.only(right: 12),
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 8, vertical: 4),
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(20),
  //                               color:
  //                                   e.value.active ? Colors.blue : Colors.white,
  //                               border: !e.value.active
  //                                   ? Border.all(
  //                                       color: Color(0xFF979EA4), width: 1)
  //                                   : Border.all(color: Colors.transparent)),
  //                           child: Center(
  //                             child: Text(
  //                               e.value.tag,
  //                               style: e.value.active
  //                                   ? ThreeKmTextConstants
  //                                       .tk12PXPoppinsWhiteRegular
  //                                       .copyWith(
  //                                           fontSize: 12,
  //                                           fontWeight: FontWeight.w700)
  //                                   : ThreeKmTextConstants
  //                                       .tk12PXPoppinsWhiteRegular
  //                                       .copyWith(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w700,
  //                                       color: Color(0xFF979EA4),
  //                                     ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }).toList(),
  //                     InkWell(
  //                       onTap: () => controller.addTag(context),
  //                       child: Container(
  //                         margin: EdgeInsets.only(right: 12),
  //                         padding:
  //                             EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             color: Colors.white,
  //                             border: Border.all(
  //                                 color: Color(0xFF979EA4), width: 1)),
  //                         child: Center(
  //                           child: Text(
  //                             "+ Add",
  //                             style: ThreeKmTextConstants
  //                                 .tk12PXPoppinsWhiteRegular
  //                                 .copyWith(
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               color: Color(0xFF979EA4),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ]
  //                 : [Container()]),
  //       ),
  //     ),
  //   );
  // }

  // Widget get buildFooter {
  //   return Positioned(
  //     bottom: 0,
  //     right: 0,
  //     left: 0,
  //     child: Container(
  //       height: 84,
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
  //       color: Color(0xFFF4F3F8),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.grid_view,
  //             size: 24,
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Expanded(
  //             child: Container(
  //               margin: EdgeInsets.only(top: 2),
  //               child: Text(
  //                 "Advance".toUpperCase(),
  //                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(
  //                   color: Color(0xFF0F0F2D),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Icon(
  //             Icons.arrow_forward,
  //             size: 24,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
