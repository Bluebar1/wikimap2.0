import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:wiki_map/screens/page.dart';
import 'package:wiki_map/screens/search.dart';

class CustomBottomSheet extends StatefulWidget {
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  RubberAnimationController _animationController;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _animationController = RubberAnimationController(
        vsync: this,
        dismissable: false,
        lowerBoundValue: AnimationControllerValue(pixel: 100),
        halfBoundValue: AnimationControllerValue(pixel: 300),
        upperBoundValue: AnimationControllerValue(percentage: .9),
        duration: Duration(microseconds: 200),
        springDescription: SpringDescription.withDampingRatio(
          mass: 2.0,
          stiffness: 200.0,
          ratio: .4,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _getUpperLayer() {
      return Container(
        decoration: BoxDecoration(color: Colors.cyan),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
          itemCount: 10,
        ),
      );
    }

    return Scaffold(
      body: RubberBottomSheet(
        scrollController: _scrollController,
        lowerLayer: Search(),
        upperLayer: _getUpperLayer(),
        animationController: _animationController,
        headerHeight: 20,
      ),
    );
  }
}
