import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:wiki_map/providers/permissions_provider.dart';
import 'package:wiki_map/screens/bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var permissionsProvider = Provider.of<PermissionsProvider>(context);

    _startGeoSearch(Position position) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
              value: GeoSearchProvider(position),
              child: Consumer<GeoSearchProvider>(
                builder: (context, provider, child) {
                  return (provider.currentMarkers != null &&
                          provider.results != null)
                      ? CustomBottomSheet()
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ))));
    }

    return (permissionsProvider.geolocationStatus != null)
        ? Scaffold(
            body: Center(
                child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${permissionsProvider.geolocationStatus.toString()}'),
              Text(
                  'Current Status of Location: ${permissionsProvider.position.toString()}'),
              IconButton(
                icon: Icon(
                  Icons.airline_seat_individual_suite,
                  size: 30,
                ),
                onPressed: () {
                  permissionsProvider.askForLocation();
                },
              ),
              RaisedButton(
                color: Colors.red,
                child: Text('Start GeoSearch From Current Location'),
                onPressed: () => _startGeoSearch(permissionsProvider.position),
              )
            ],
          )))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
