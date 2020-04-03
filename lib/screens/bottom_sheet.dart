import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:wiki_map/screens/map_bottom_sheet.dart';
import 'package:wiki_map/screens/map_bottom_sheet_v2.dart';
import 'package:wiki_map/screens/search.dart';

/*
Created NB 4/2/2020
This class creates a custom bottom sheet using the 'rubber' library.
This animated sheet needs to be wrapped in a stateful widget so that
it can animated at 60fps vsync.
This is my only StatefulWidget class so far because I usually use Provider
to track my states but some packages (like rubber) require a stateful widget
*/

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
        duration: Duration(milliseconds: 200),
        springDescription: SpringDescription.withDampingRatio(
          mass: 2.0,
          stiffness: 200.0,
          ratio: .4,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RubberBottomSheet(
        scrollController: _scrollController,
        lowerLayer: Search(),
        upperLayer: MapBottomSheetV2(controller: _scrollController),
        animationController: _animationController,
        headerHeight: 20,
      ),
    );
  }
}
