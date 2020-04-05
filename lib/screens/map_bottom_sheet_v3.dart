import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/modules/horizontal_wiki_scroll.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';

class MapBottomSheetV3 extends StatelessWidget {
  final ScrollController controller;
  MapBottomSheetV3({@required this.controller});

  @override
  Widget build(BuildContext context) {
    var geosearchProvider = Provider.of<GeoSearchProvider>(context);
    return ChangeNotifierProvider.value(
      value: MapBottomSheetProvider(geosearchProvider.results),
      child: Consumer<MapBottomSheetProvider>(
        builder: (context, mapBottomSheetProvider, child) {
          return (mapBottomSheetProvider.currentArticles != null)
              ? HorizontalWikiScroll(provider: mapBottomSheetProvider)
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
