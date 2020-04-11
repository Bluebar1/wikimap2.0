import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

class ImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mapBottomSheetProvider = Provider.of<MapBottomSheetProvider>(context);
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);
    //var provider = Provider.of<ImageViewProvider>(context);
    return Scaffold(
      body: Center(
          child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PhotoView(
              imageProvider: NetworkImage(
                  '${mapBottomSheetProvider.imageUrls[mapBottomSheetProvider.indexOfImageTapped]}'),
              controller: mapBottomSheetProvider.photoViewController,
            ),
          ),
          Positioned(
            top: 50,
            child: Text(
              'Scale applied: ' + '${mapBottomSheetProvider.scale}',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color.fromRGBO(192, 192, 192, 1.0)),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Go back',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color.fromRGBO(192, 192, 192, 1.0)),
                )),
          )
        ],
      )),
    );
  }
}
