import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/*
Created NB 4/9/2020

Swiper class for storing the current index to display in the UI

The Markers, Wiki Article Information, and Pictures are loaded for each page
found in the geosearch. All of these Objects are Stored in lists and can
be iterated by the user in multiple ways.

Index is stored as a private int and is accessed by other classes through
its getter 'get' method

With ChangeNotifier, changes in the current index will notitify all the 
widgets in the tree that require its index.

This class is started high in the widget tree so that it can be accessed by all
of its children. The children can access the state of this class in multiple ways,
but I find using : Provider.of<SwiperIndexProvider>(context) in the build method for
each widget that relies on its state.
*/

class SwiperIndexProvider with ChangeNotifier {
  int _currentIndex;
  int get currentIndex => _currentIndex;

  SwiperController _controller;
  SwiperController get controller => _controller;

  SwiperIndexProvider() {
    _currentIndex = 0;
    _controller = SwiperController();
  }

  void changeCurrentIndex(int currentIndex) {
    print('CHANGE CURRENT INDEX HAS BEEN CALLED: $currentIndex');
    _currentIndex = currentIndex;
    //notifyListeners();
  }
}
