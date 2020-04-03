import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:wiki_map/modules/horizontal_wiki_scroll.dart';
import 'package:wiki_map/modules/list_view_module.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/services/marker_service.dart';

class MapBottomSheetV2 extends StatelessWidget {
  final ScrollController controller;
  MapBottomSheetV2({@required this.controller});
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final geoSearchProvider = Provider.of<Future<List<GeoSearch>>>(context);
    final markerService = MarkerService();
    return FutureProvider(
        create: (context) => geoSearchProvider,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(0, 0, 0, .3),
            body: (currentPosition != null)
                ? Consumer<List<GeoSearch>>(
                    builder: (_, results, __) {
                      var markers = (results != null)
                          ? markerService.getMarkers(results)
                          : List<Marker>();
                      return (results != null)
                          ? ChangeNotifierProvider.value(
                              value: MapBottomSheetProvider(results),
                              child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: Consumer<MapBottomSheetProvider>(
                                  builder: (_, provider, __) {
                                    return (provider.currentArticles != null)
                                        ? HorizontalWikiScroll(
                                            provider: provider)
                                        // ListViewModule(
                                        //     provider: provider,
                                        //     controller: controller)
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          );
                                  },
                                ),
                              ),
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
