import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_clone/Screens/home_screen.dart';

import 'Common/Utils/connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>(
            initialData: ConnectivityResult.none,
            create: (_) {
              return ConnectivityService().connectionStatusController.stream;
            }),

      ],
      child: MaterialApp(
        title: 'YouTube Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),

        home: HomeScreen(),
      )
    );
  }
}

