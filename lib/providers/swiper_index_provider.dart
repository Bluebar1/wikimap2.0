import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
    print('CHANGE CURRENT INDEX HAS BEEN CALLED');
    _currentIndex = currentIndex;
    //notifyListeners();
  }
}
