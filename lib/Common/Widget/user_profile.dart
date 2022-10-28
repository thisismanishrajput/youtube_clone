import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../URLs.dart';

Future<dynamic> profileBottomSheet(BuildContext context) {
  bool isCustomReport = false;
  TextEditingController reportController = new TextEditingController();

  return showModalBottomSheet(
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              // color: Colors.black87,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            profileHeading(),
                            SizedBox(height: 10),
                            contentTile(icon: Icons.person_pin_outlined, name: "Your Channel"),
                            contentTile(icon: Icons.person_add, name: "Add account"),
                            Divider(color: Colors.grey,),
                            contentTile(icon: CupertinoIcons.play_rectangle, name: "Get YouTube Premium"),
                            contentTile(icon: CupertinoIcons.money_dollar_circle, name: "Purchases and memberships"),
                            contentTile(icon: Icons.bar_chart, name: "Timed Watch"),
                            contentTile(icon: Icons.security, name: "Your Data in YouTube"),
                            Divider(color: Colors.grey,),
                            contentTile(icon: Icons.settings, name: "Settings"),
                            contentTile(icon: Icons.help_outline, name: "Help and feedback")
                          ],
                        )
                      ),
                    ),
                  ]));
        });
      });
}

Widget profileHeading() {
  return Row(
    children: [
      CircleAvatar(
        radius: 30.0,
        child: ClipOval(
          child: Image.network(ImageUrls.img),
        ),
        backgroundColor: Colors.blue.withOpacity(0.25),
      ),
      Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manish Rajput",
                  style: GoogleFonts.openSans(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "Manage your Google Account",
              style: GoogleFonts.openSans(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 16),
            ),
        ],
      ),
          ))
    ],
  );
}

Widget contentTile({required IconData icon, required String name}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 27,
        ),
        SizedBox(width: 35),
        Text(
          name,
          style: GoogleFonts.openSans(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),
        )
      ],
    ),
  );
}
