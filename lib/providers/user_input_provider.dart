import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class UserInputProvider with ChangeNotifier {
  //
  TextEditingController _addressController;
  TextEditingController get addressController => _addressController;
  //
  String _inputAddress;
  String get inputAddress => _inputAddress;
  //
  double _lat;
  double get lat => _lat;
  //
  double _lon;
  double get lon => _lon;
  //
  bool _error;
  bool get error => _error;
  //
  Position _position;
  Position get position => _position;
  //
  Geolocator geolocator = Geolocator();

  UserInputProvider() {
    _addressController = TextEditingController();
  }

  changeAddress(String address) {
    print('CHANGE ADDRESS STRING HAS BEEN CALLED');
    _inputAddress = address;
    notifyListeners();
  }

  Future<Position> convertToLocation() async {
    _error = false;
    try {
      var result = await geolocator.placemarkFromAddress(_inputAddress);
      return Position(
          latitude: result[0].position.latitude,
          longitude: result[0].position.longitude);
    } catch (err) {
      return null;
    }
  }
}
