import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:new_library_project/models/libraryinfo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<StatefulWidget> {
  late Future<Iterable<LibraryInfo>> futureRequirements;
  final List<Widget> requirementWidgetList = [];

  @override
  void initState() {
    super.initState();
    futureRequirements = LibraryInfo.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
                "Kütüphane Uygulamasına Hoşgeldiniz",
            style: TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    ));
  }
}
