import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/services/marker_service.dart';

class MapBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final geoSearchProvider = Provider.of<Future<List<GeoSearch>>>(context);
    final markerService = MarkerService();
    ScrollController _scrollController = ScrollController();

    return FutureProvider(
        create: (context) => geoSearchProvider,
        child: Scaffold(
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
                                decoration: BoxDecoration(color: Colors.cyan),
                                child: Consumer<MapBottomSheetProvider>(
                                  builder: (_, provider, __) {
                                    return (provider.currentArticles != null)
                                        ? ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            controller: _scrollController,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ListTile(
                                                title: Text(
                                                    'Item ${provider.currentArticles[index].title}'),
                                              );
                                            },
                                            itemCount:
                                                provider.currentArticles.length,
                                          )
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
