import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  final geo = Geolocator();

  Future<Position> getCoords() async {
    print('GEO LOCATOR SERVICE CALLED');
    return await geo.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }
}
