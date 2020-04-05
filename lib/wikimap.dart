import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/permissions_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:wiki_map/screens/home_screen.dart';
import 'package:wiki_map/services/geosearch_service.dart';

/*
Created NB 4/2/2020
Called from main.dart
Starts the proccesses of getting the users location and loading
wikipedia pages around them
*/
class WikiMap extends StatelessWidget {
  final geoSearchService = GeoSearchService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PermissionsProvider>(
            create: (_) => PermissionsProvider()),
        ChangeNotifierProvider<SwiperIndexProvider>(
            create: (_) => SwiperIndexProvider())
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
