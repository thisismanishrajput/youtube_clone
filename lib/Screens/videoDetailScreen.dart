import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_clone/Common/Widget/appBar.dart';
import 'package:youtube_clone/Screens/videoCard.dart';
import 'package:youtube_clone/Screens/videoScreen.dart';

import '../Common/URLs.dart';

class VideoDetailsScreen extends StatefulWidget {
  final String videoUrl;
  final String description;
  final String views;
  final String uploadedOn;

  const VideoDetailsScreen(
      {Key? key,
      required this.videoUrl,
      required this.description,
      required this.uploadedOn,
      required this.views})
      : super(key: key);

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBarMethod.appBarMethod(context: context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonVideoPlayerScreen(videoUrl: widget.videoUrl),
          Text(
            widget.description,
            style: GoogleFonts.openSans(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 5),
          widget1(view: widget.views, date: widget.uploadedOn),
          SizedBox(height: 15),
          Divider(
            color: Colors.grey,
          ),
          channelWidget(channelName: "Manish Rajput", subscribers: "10.5 M"),
          Divider(
            color: Colors.grey,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  likeCommentWidget(),
                  liveChat(),
                  shareWidget(),
                  download(),
                  saveWidget()
                ],
              )),
          SizedBox(height: 15),
          comments(),
          recommendedVide()
        ],
      ),
    );
  }

  Widget recommendedVide(){
    List<Map> videoDetails = [
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic1.jpg",
        "duration": "30:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"
      },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic2.jpg",
        "duration": "30:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic3.jpg",
        "duration": "2:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic2.jpg",
        "duration": "5:02",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic1.jpg",
        "duration": "10:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic2.jpg",
        "duration": "7:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic1.jpg",
        "duration": "50:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic2.jpg",
        "duration": "11:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic1.jpg",
        "duration": "37:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    },
      {
        "desc":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
        "imgUrl": "assets/pic2.jpg",
        "duration": "20:00",
        "channelName": "T-series",
        "views": "100M",
        "uploadedOn": "3 Months ago",
        "videoUrl":"assets/videos/pexels-mikhail-nilov-6981411.mp4"    }
    ];
    return Expanded(
      child: ListView.builder(
        itemCount: videoDetails.length,
        itemBuilder: (context, index) {
          return videoCard(context,
              videoUrl:  videoDetails[index]["videoUrl"],
              thumbnailImage: videoDetails[index]["imgUrl"],
              title: videoDetails[index]["desc"],
              duration: videoDetails[index]["duration"],
              channelName: videoDetails[index]["channelName"],
              views: videoDetails[index]["views"],
              uploadedOn: videoDetails[index]["uploadedOn"]
          );
        },
      ),
    );
  }

  Widget comments() {
    return Container(
      decoration: BoxDecoration(color: Colors.black12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Comments",
                style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "   100K",
                style: GoogleFonts.openSans(color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                child: ClipOval(
                  child: Image.network(ImageUrls.img),
                ),
                backgroundColor: Colors.blue.withOpacity(0.25),
              ),
              SizedBox(width: 20),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manish is such a awesome developer! 🤭😉",
                    style: GoogleFonts.openSans(color: Colors.white),
                  ),
                  Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,)
                ],
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget widget1({required String view, required String date}) {
    return Row(
      children: [
        Text(
          "${view} View",
          style: GoogleFonts.openSans(color: Colors.grey),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Text(
          date,
          style: GoogleFonts.openSans(color: Colors.grey),
        ),
      ],
    );
  }

  Widget channelWidget(
      {required String channelName, required String subscribers}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              child: ClipOval(
                child: Image.network(ImageUrls.img),
              ),
              backgroundColor: Colors.blue.withOpacity(0.25),
            ),
            SizedBox(width: 15),
            Text(
              channelName,
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(width: 15),
            Text(
              subscribers,
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white70,
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.white70,
            )
          ],
        )
      ],
    );
  }

  Widget likeCommentWidget() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Icon(
            Icons.thumb_up_alt_outlined,
            color: Colors.white,
          ),
          Text(
            "169K",
            style: GoogleFonts.openSans(color: Colors.white),
          ),
          SizedBox(width: 12),
          Icon(
            Icons.thumb_down_alt_outlined,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget liveChat() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline_outlined,
            color: Colors.white,
          ),
          Text(
            "Live chat",
            style: GoogleFonts.openSans(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget shareWidget() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.arrowshape_turn_up_right_fill,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Text(
            "Share",
            style: GoogleFonts.openSans(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget download() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Icon(
            Icons.download_sharp,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Text(
            "Download",
            style: GoogleFonts.openSans(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget saveWidget() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Icon(
            Icons.my_library_add_outlined,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Text(
            "Save",
            style: GoogleFonts.openSans(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
