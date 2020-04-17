import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:wiki_map/providers/image_testing_provider.dart';
import 'package:wiki_map/providers/permissions_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:wiki_map/providers/user_input_provider.dart';
import 'package:wiki_map/screens/album_selection_page.dart';
import 'package:wiki_map/screens/bottom_sheet.dart';
import 'package:wiki_map/screens/image_selection.dart';
import 'package:wiki_map/screens/image_testing.dart';
import 'package:wiki_map/screens/saved_pages.dart';
import 'package:wiki_map/screens/settings.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var permissionsProvider = Provider.of<PermissionsProvider>(context);
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);
    var userInputProvider = Provider.of<UserInputProvider>(context);

    _startGeoSearch(Position position) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
              value: GeoSearchProvider(position, swiperIndexProvider, context),
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

    // void _goToImageTesting() {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (_) => ChangeNotifierProvider<ImageTestingProvider>(
    //             create: (context) => ImageTestingProvider(),
    //             child: ImageTesting(),
    //           )));
    // }

    void _goToAlbumSelection() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<ImageTestingProvider>(
                create: (context) => ImageTestingProvider(),
                child: AlbumSelectionPage(),
              )));
    }

    _showAddressErrorFlushBar() {
      return Flushbar(
        message: 'That address could not be found',
        duration: Duration(seconds: 2),
        isDismissible: true,
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.black,
        borderRadius: 8,
        margin: EdgeInsets.all(5),
        borderColor: Colors.white,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        icon: Icon(Icons.error, color: Colors.amber),
      ).show(context);
    }

    _checkIfAddressValid() async {
      var position = await userInputProvider.convertToLocation();
      (position != null)
          ? _startGeoSearch(position)
          : _showAddressErrorFlushBar();
    }

    void _goToSavedPages() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SavedPages(),
      ));
    }

    void _goToSettings() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Settings()));
    }

    void _goToImageSelection() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ImageSelection()));
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
              ),
              RaisedButton(
                color: Colors.amberAccent,
                child: Text('Go to Saved Pages'),
                onPressed: () => _goToSavedPages(),
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Go to Settings'),
                onPressed: () => _goToSettings(),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 20,
                width: 200,
                child: TextField(
                  controller: userInputProvider.addressController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Address',
                    fillColor: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    userInputProvider.changeAddress(value);
                  },
                ),
              ),
              RaisedButton(
                color: Colors.green,
                child: Text('Search Address'),
                onPressed: () {
                  (userInputProvider.inputAddress != null)
                      ? _checkIfAddressValid()
                      : _showAddressErrorFlushBar();
                },
              ),
              RaisedButton(
                color: Colors.purpleAccent,
                child: Text('Photo Library'),
                onPressed: () {
                  _goToImageSelection();
                },
              ),
              RaisedButton(
                color: Colors.purpleAccent,
                child: Text('Image Testing'),
                onPressed: () {
                  _goToAlbumSelection();
                },
              ),
            ],
          )))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
