import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'constraints.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Description")),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: DarkGreen,
        color: DarkGreen,
        items: [
          CurvedNavigationBarItem(
              child: Icon(Icons.explore, color: Colors.white, size: 30,),
              label: 'Explore',labelStyle: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold)
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined, color: Colors.white,size: 30,),
              label: 'Home',labelStyle: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold)
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.person, color: Colors.white,size: 30,),
              label: 'Account',labelStyle: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold)
          ),
        ],
        onTap: (index){},
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text("Hello"),
      )

    );

  }
}
