import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rubber/rubber.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'dart:convert' as convert;
import 'dart:math';

import 'package:wiki_map/services/marker_service.dart';
/*
Created NB 4/5/2020
ChangeNotifierProvider class to run a wiki geosearch starting
at 'startingPosition', which is passed to this class on creation. 
If the user taps the 'Search From Current Location' button it will
use the location provided by the PermissionsProvider.
If the user long presses a location on the map, it will send that location
to this class which triggers a chain of events to load all the new information 
for that search
The map is able to update to the new markers so quickly because it only takes
one async http.get call to retrieve all the information to rebuild the map
The markers are built as a list by the MarkerService (marker_service.dart)
and that list is tranformed to a Set<Marker>.of<GeoSearchProvider.currentMarkers> in the widget tree 
*/

class GeoSearchProvider with ChangeNotifier {
  final Position startingPosition;
  final SwiperIndexProvider swiperIndexProvider;
  final BuildContext buildContext;
  final markerService = MarkerService();
  //
  List<GeoSearch> _results;
  List<GeoSearch> get results => _results;
  //
  List<Marker> _currentMarkers;
  List<Marker> get currentMarkers => _currentMarkers;
  //
  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get controller => _controller;
  //
  CameraPosition _position;
  CameraPosition get position => _position;
  //
  RubberAnimationController _rubberAnimationController;
  RubberAnimationController get rubberAnimationController =>
      _rubberAnimationController;
  //
  double _deviceHeight;
  GeoSearchProvider(
      this.startingPosition, this.swiperIndexProvider, this.buildContext) {
    //_controller = Completer();
    _deviceHeight = MediaQuery.of(buildContext).size.height;
    print('DEVICE HEIGHT:::::::::::::::');
    print(_deviceHeight);
    _results = null;
    _currentMarkers = null;
    _position = CameraPosition(
        target: LatLng(
            startingPosition.latitude - 0.0015, startingPosition.longitude),
        zoom: 16.0);
    getResults(startingPosition);
    //_controller.complete();
  }

  void setRubberAnimationController(RubberAnimationController controller) {
    //print('SET RUBBER ANIMATION CONTROLLER HAS BEEN CALLED');
    //print('${controller.animationState.value}');
    _rubberAnimationController = controller;
  }

  void createController(GoogleMapController controller) {
    _controller.complete(controller);
    controller
        .showMarkerInfoWindow(MarkerId('${swiperIndexProvider.currentIndex}'));
  }

  void changeCurrentMarker() async {
    //print('CHANGE CURRENT MARKER CALLED');
    printGeodetic();
    final GoogleMapController cont = await _controller.future;
    print('CONT ------------ ${cont.toString()}');
    LatLng latLng = LatLng(
        getDynamicLatitude(), _results[swiperIndexProvider.currentIndex].lon);
    print('LAT LAND ++++++++++++++ ${latLng.toString()}');
    //cont.animateCamera(CameraUpdate.newLatLng(latLng));
    CameraPosition newtPosition =
        CameraPosition(target: latLng, zoom: 16 //_position.zoom,
            );
    cont.showMarkerInfoWindow(MarkerId('${swiperIndexProvider.currentIndex}'));
    //cont.animateCamera(CameraUpdate.newLatLng(latLng))
    cont.animateCamera(CameraUpdate.newCameraPosition(newtPosition));
  }

  void printGeodetic() async {
    print(
        'CURRENT LATITUTE:::: ${_results[swiperIndexProvider.currentIndex].lat}');
    double geocentricLatitude = _results[swiperIndexProvider.currentIndex].lat;
    double geocentricLongitude = _results[swiperIndexProvider.currentIndex].lon;
    double geocentricLatitudeP =
        _results[swiperIndexProvider.currentIndex].lat - 0.0033;
    double geocentricLongitudeP =
        _results[swiperIndexProvider.currentIndex].lon;

    var dist = await Geolocator().distanceBetween(geocentricLatitude,
        geocentricLongitude, getDynamicLatitude(), geocentricLongitudeP);
    print('DIST::: $dist');

    if (geocentricLatitude >= 0) {
    } else {}
  }

  int getLevel() {
    print('GET LEVEL CALLED');
    double tempAbsVal = (_results[swiperIndexProvider.currentIndex].lat).abs();
    if (tempAbsVal <= 10) {
      return 1;
    } else if (tempAbsVal <= 20) {
      return 2;
    } else if (tempAbsVal <= 30) {
      return 3;
    } else if (tempAbsVal <= 40) {
      return 4;
    } else if (tempAbsVal <= 50) {
      return 5;
    } else if (tempAbsVal <= 60) {
      return 6;
    } else if (tempAbsVal <= 70) {
      return 7;
    } else if (tempAbsVal <= 80) {
      return 8;
    } else {
      return 9;
    }
  }

  double getDynamicLatitude() {
    double latitude = _results[swiperIndexProvider.currentIndex].lat;
    switch (_rubberAnimationController.animationState.value) {
      case AnimationState.collapsed:
        {
          return latitude - 0.0015;
        }
        break;

      case AnimationState.half_expanded:
        {
          return latitude - 0.0033;
        }
        break;

      case AnimationState.expanded:
        {
          switch (getLevel()) {
            case 1:
              {
                return (_deviceHeight < 850)
                    ? latitude - 0.0062
                    : latitude - 0.0063;
              }
              break;

            case 2: //10-20
              {
                return (_deviceHeight < 850)
                    ? latitude - 0.0058
                    : latitude - 0.006;
              }
              break;
            case 3:
              {
                return latitude - 0.0056;
              }
              break;
            case 4: //30-40
              {
                //return latitude - 0.005;
                return (_deviceHeight < 850)
                    ? latitude - 0.005
                    : latitude - 0.006;
              }
              break;
            case 5: //40-50
              {
                //return latitude - 0.0044;
                return (_deviceHeight < 850)
                    ? latitude - 0.0044
                    : latitude - 0.0046;
              }
              break;
            case 6:
              {
                // return latitude - 0.0032;
                return (_deviceHeight < 850)
                    ? latitude - 0.0032
                    : latitude - 0.0034;
              }
              break;
            case 7:
              {
                // return latitude - 0.0023;
                return (_deviceHeight < 850)
                    ? latitude - 0.0023
                    : latitude - 0.0025;
              }
              break;
            case 8:
              {
                // return latitude - 0.0018;
                return (_deviceHeight < 850)
                    ? latitude - 0.0018
                    : latitude - 0.002;
              }
              break;
            case 9:
              {
                print('how was this called');
              }
              break;
          }
          //return _results[swiperIndexProvider.currentIndex].lat - 0.005;
        }
        break;

      case AnimationState.animating:
        {
          return latitude;
        }
        break;

      default:
        {
          return latitude;
        }
    }
  }

  void changeCurrentCameraPosition(CameraPosition position) {
    //print('CHANGE CURRENT POSITION CALLED');
    _position = position;
  }

  /*
  Param: Position object that contains latitude and longitude
  Returns: void
  Use: Build a Url with the information provided by the position
    and make an async http call to recieve a list of geosearch objects.
    send the results to setResults
  */
  void getResults(Position startingPosition) async {
    String _wikiLocationUrlDynamic = Uri.encodeFull(
        "https://en.wikipedia.org/w/api.php?" +
            "action=query&list=geosearch&gscoord=" +
            startingPosition.latitude.toString() +
            "|" +
            startingPosition.longitude.toString() +
            "&gsradius=10000&gslimit=10&format=json");
    var response = await http.get(_wikiLocationUrlDynamic);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['geosearch'] as List;
    setResults(jsonResults);
  }

  /*
  Param: List of objects of any type
  Returns: void
  Use: Changes the _results member variable to a List<GeoSearch>
    created by mapping the results, then using that map to create 
    GeoSearch objects (geosearch_model.dart) with the fromJson function.
  
  TODO: (nb) check if notifyListeners() is needed 
  */
  void setResults(List<dynamic> jsonResults) {
    //print(jsonResults.runtimeType);

    _results =
        jsonResults.map((geosearch) => GeoSearch.fromJson(geosearch)).toList();
    setMarkers(_results);
    notifyListeners();
  }

  /*
  Param: List of geosearch objects
  Returns: void
  Use: If the list provided is null, an empty List<Marker> object will 
    be created. If != null the MarkerService (marker_service.dart) will
    be used to convert the geosearch results to Marker objects.
    Notifies Listeners in widget tree relying on this data
  */
  void setMarkers(List<GeoSearch> geosearch) {
    _currentMarkers = (geosearch != null)
        ? markerService.getMarkers(results, swiperIndexProvider)
        : List<Marker>();
    notifyListeners();
  }
}
