import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_clone/Common/URLs.dart';
import 'package:youtube_clone/Common/Widget/user_profile.dart';

import '../Utils/colors.dart';
import 'fade_page_route.dart';

class AppBarMethod {
  static PreferredSize appBarMethod({
    bool isBack = false,
    bool isNav = false,
    bool isChatScreen = false,
    bool isNotificationPage = false,
    required BuildContext context,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<ConnectivityResult>(
        builder: (context, value, child) {
          return AppBar(
            backgroundColor: value != ConnectivityResult.none
                ? appBarColor
                : const Color(0xDFFF2029),
            centerTitle: true,
            elevation: 0,
            titleSpacing: 0,
            leadingWidth: 200,
            leading: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Container(
                  child: Row(
                    children: [
                      if (isBack && !isNav)
                        IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      if (!isBack)
                        Row(
                          children: [
                            Image.asset(
                              "assets/youtube.png", height: 32, width: 32,),
                            SizedBox(width: 10),
                            Text(
                              "YouTube",
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 22
                              ),
                            )
                          ],
                        )
                    ],
                  )),
            ),
            actions: [
              SizedBox(width: 10),
              if (!isNotificationPage)
                Center(
                  child: Row(
                    children: [
                      Icon(Icons.cast,size: 25,),
                      SizedBox(width: 5),
                      Icon(Icons.search,size: 30,),
                      SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 17.0),
                        child: Stack(
                          children: [
                            Icon(Icons.notifications,size: 30,),
                            Positioned(
                              right: 0,
                              child: Container(

                                decoration: BoxDecoration(
                                    color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(9))
                                ),

                                child: Center(child: Text("+9",style: GoogleFonts.openSans(),)),
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  profileBottomSheet(context);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: secondaryColor, width: 1),
                  ),
                  child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: Image.network(ImageUrls.img),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.25),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
