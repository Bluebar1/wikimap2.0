import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

/*
Created NB 4/5/2020
ChangeNotifier class to store permission data.
Used to display current Status of permissions and location
on the HomeScreen (home_screen.dart).
Is notified when the user interacts with the permissions status,
and can be changed from HomeScreen.
*/

class PermissionsProvider with ChangeNotifier {
  bool _hasPhotoAccess;
  bool get hasPhotoAccess => _hasPhotoAccess;

  GeolocationStatus _geolocationStatus;
  GeolocationStatus get geolocationStatus => _geolocationStatus;

  Position _position;
  Position get position => _position;

  PermissionsProvider() {
    _geolocationStatus = null;
    checkLocationPermissions();
    askForLocation();
  }

  void checkLocationPermissions() async {
    print(' CHECK LOCATION PERMISSIONS CALLED');
    _geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    notifyListeners();
  }

  void askForLocation() async {
    Position tempPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setPosition(tempPosition);
    checkLocationPermissions();
  }

  void setPosition(Position position) {
    print('SET POSITION CALLED');
    print(position.toString());
    _position = position;
    notifyListeners();
  }

  void setGeolocationStatus(GeolocationStatus geolocationStatus) {
    _geolocationStatus = geolocationStatus;
    notifyListeners();
  }
}
