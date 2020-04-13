import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/*
Created NB 3/29/2020

This Provider class stores the status of the controller
for zooming and changing photos when clicked on the saved
wiki page.
 */
class SavedPageImageViewProvider with ChangeNotifier {
  PhotoViewController _photoViewController;
  double _scaleCopy;

  PhotoViewController get photoViewController => _photoViewController;
  double get scaleCopy => _scaleCopy;

  SavedPageImageViewProvider() {
    print('SAVED PAGE IMAGE VIEW PROVIDER HAS BEEN CALLED');
    _photoViewController = PhotoViewController()
      ..outputStateStream.listen(listener);
  }

  void listener(PhotoViewControllerValue value) {
    _scaleCopy = value.scale;
    notifyListeners();
  }
}
