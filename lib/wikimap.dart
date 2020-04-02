import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/screens/bottom_sheet.dart';
import 'package:wiki_map/services/geolocator_service.dart';
import 'package:wiki_map/services/geosearch_service.dart';
import 'models/geosearch_model.dart';

/*
Created NB 4/2/2020
Called from main.dart
Starts the proccesses of getting the users location and loading
wikipedia pages around them
*/
class WikiMap extends StatelessWidget {
  final geoLocatorService = GeoLocatorService();
  final geoSearchService = GeoSearchService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => geoLocatorService.getCoords()),
        ProxyProvider<Position, Future<List<GeoSearch>>>(
            update: (context, position, results) {
          if (position != null) {
            return geoSearchService.getPlaces(
                position.latitude, position.longitude);
          } else {
            return null;
          }
        }),
      ],
      child: MaterialApp(home: CustomBottomSheet()),
    );
  }
}
