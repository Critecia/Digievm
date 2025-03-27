// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sst/pages/votecount.dart';
import 'package:sst/datapro.dart';
import 'package:provider/provider.dart';
import 'pages/turnout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Count(),
        routes: {
          '/countpage': (context) => Count(),
          '/turnoutpage': (context) => Turnout(),
        },
      ),
    );
  }
}
