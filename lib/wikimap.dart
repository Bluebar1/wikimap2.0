import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/screens/bottom_sheet.dart';
import 'package:wiki_map/services/geolocator_service.dart';
import 'package:wiki_map/services/geosearch_service.dart';

import 'models/geosearch_model.dart';

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
          return (position != null)
              ? geoSearchService.getPlaces(
                  position.latitude, position.longitude)
              : null;
        })
      ],
      child: MaterialApp(home: CustomBottomSheet()),
    );
  }
}
