import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<dynamic> reportCommentBottomSheet(BuildContext context) {
  bool isCustomReport = false;
  TextEditingController reportController = new TextEditingController();
  List<Map> content = [
  {
    "icon":Icons.watch_later_outlined,
    "name":"Save to Watch Later"
  },
    {
    "icon":Icons.library_add,
    "name":"Save to Playlist"
  },
    {
    "icon":Icons.download_rounded,
    "name":"Download Video"
  },
    {
    "icon":FontAwesomeIcons.share,
    "name":"Share"
  },
    {
    "icon":Icons.report,
    "name":"Report"
  },
  ];
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
                  height: MediaQuery.of(context).size.height * 0.35,
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Expanded(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView.builder(
                                    itemCount: content.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: new AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                     return Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                          children: [
                                            Icon(content[index]["icon"],color: Colors.white,),
                                            SizedBox(width: 30),
                                            Text(content[index]['name'],style: GoogleFonts.openSans(color: Colors.white),)
                                          ],
                                        ),
                                     );
                                    }
                                    ),
                              ),
                            ),
                          ),
                      ]));
            });
      });
}



