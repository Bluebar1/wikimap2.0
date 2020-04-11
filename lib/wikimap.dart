import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/permissions_provider.dart';
import 'package:wiki_map/providers/saved_pages_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:wiki_map/providers/theme_provider.dart';
import 'package:wiki_map/screens/home_screen.dart';
import 'package:wiki_map/services/geosearch_service.dart';
import 'package:wiki_map/style.dart';

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
    //var themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PermissionsProvider>(
            create: (_) => PermissionsProvider()),
        ChangeNotifierProvider<SwiperIndexProvider>(
            create: (_) => SwiperIndexProvider()),
        ChangeNotifierProvider<SavedPagesProvider>(
            create: (_) => SavedPagesProvider())
      ],
      child: MaterialApp(
          theme: ThemeData(textTheme: TextTheme(bodyText1: ModuleTextStyle)),
          home: HomeScreen()),
    );
  }
}
