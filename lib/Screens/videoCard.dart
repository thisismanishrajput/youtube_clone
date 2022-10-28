import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_clone/Common/Widget/bottomSheet.dart';
import 'package:youtube_clone/Screens/videoDetailScreen.dart';
import 'package:youtube_clone/Screens/videoScreen.dart';

import '../Common/Widget/fade_page_route.dart';

Widget videoCard(BuildContext context, {
  required String thumbnailImage,
  required String title,
  required String videoUrl,
  required String duration,
  required String channelName,
  required String views,
  required String uploadedOn,
}) {
  final deviceHeight = MediaQuery
      .of(context)
      .size
      .height;
  final deviceWidth = MediaQuery
      .of(context)
      .size
      .width;
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(
              FadePageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return VideoDetailsScreen(
                        videoUrl: videoUrl,
                        description: title,
                        uploadedOn: uploadedOn,
                        views: views);
                  }),
            );
          },
          child: Stack(
            children: [
              Container(
                height: deviceHeight * 0.25,
                width: deviceWidth,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(thumbnailImage),
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        duration,
                        style: GoogleFonts.openSans(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(onTap: () {
              reportCommentBottomSheet(context);
            },
                child: Icon(Icons.more_vert_outlined, color: Colors.white,))
          ],
        ),
        Row(
          children: [
            Text(
              channelName,
              style: GoogleFonts.openSans(fontSize: 14, color: Colors.white54),
            ),
            SizedBox(width: 20),
            Text(
              views,
              style: GoogleFonts.openSans(fontSize: 14, color: Colors.white54),
            ),
            SizedBox(width: 20),
            Text(
              uploadedOn,
              style: GoogleFonts.openSans(fontSize: 14, color: Colors.white54),
            ),

          ],
        )
      ],
    ),
  );
}
