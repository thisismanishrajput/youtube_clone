import 'package:flutter/material.dart';
import 'package:youtube_clone/Common/Widget/appBar.dart';
import 'package:youtube_clone/Screens/videoCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBarMethod.appBarMethod(context: context),
      body: ListView.builder(
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
}
