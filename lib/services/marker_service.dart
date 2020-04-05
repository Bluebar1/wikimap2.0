import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

class MarkerService {
  List<Marker> getMarkers(
      List<GeoSearch> results, SwiperIndexProvider swiperIndexProvider) {
    print('GET MARKERS CALLED');
    var markers = List<Marker>();
    results.forEach((result) {
      Marker marker = Marker(
        markerId: MarkerId('${results.indexOf(result)}'),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(100),
        infoWindow: InfoWindow(title: result.title),
        position: LatLng(result.lat, result.lon),
        onTap: () =>
            updateBottomSheet(results.indexOf(result), swiperIndexProvider),
      );

      markers.add(marker);
    });
    //print('MARKERS PRINTED OUT' + markers.toString());
    return markers;
  }

  void updateBottomSheet(int index, SwiperIndexProvider swiperIndexProvider) {
    swiperIndexProvider.changeCurrentIndex(index);
    swiperIndexProvider.controller.move(index);
  }
}
