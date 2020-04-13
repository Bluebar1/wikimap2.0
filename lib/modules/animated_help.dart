import 'package:flutter/material.dart';

/*
Created NB 4/13/2020

Stateful widget with animation, is triggered when the help (?) button 
is pressed on the map view
*/

class Help extends StatefulWidget {
  _Help createState() => _Help();
}

class _Help extends State<Help> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0))),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                    ),
                    Text('HELP PAGE'),
                    Text('HELP PAGE'),
                    Text('HELP PAGE'),
                    Text('HELP PAGE'),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
