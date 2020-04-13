import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/screens/image_view.dart';

/*
Created NB 4/10/2020

Widget to display all images found in a specific wikipedia page.
Whenever SwiperIndexProvider.currentIndex changes, it will automatically 
reload with the images for whatever article is currently displayed in
the Swiper Widget.

TODO: (nb) FutureBuilder currently not working, all images are rendered instead of just the ones
currently on screen
*/

class WikiPageInfo extends StatelessWidget {
  final MapBottomSheetProvider provider;
  final ScrollController controller;
  WikiPageInfo({@required this.provider, @required this.controller});
  @override
  Widget build(BuildContext context) {
    //
    void _viewImage(MapBottomSheetProvider provider, int index) {
      provider.createPhotoViewController();
      provider.setIndexOfImageTapped(index);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ImageView(provider)));
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => ChangeNotifierProvider.value(
      //         value: provider, child: ImageView())));
    }

    var mapBottomSheetProvider = Provider.of<MapBottomSheetProvider>(context);
    var size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, .0)),
        child: (provider.isPagePicsDoneLoading == true)
            ? GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                //controller: controller,
                itemCount: provider.imageUrls.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: (size.width) / (size.height / 2),
                ),
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      return GestureDetector(
                          onTap: () =>
                              _viewImage(mapBottomSheetProvider, index),
                          child: GridTile(
                              child: (provider.imageUrls[index].contains('svg'))
                                  ? SvgPicture.network(
                                      provider.imageUrls[index],
                                      fit: BoxFit.scaleDown,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: mapBottomSheetProvider
                                              .imageUrls[index],
                                          fadeInDuration:
                                              const Duration(milliseconds: 700),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )));
                    },
                  );
                },
              )
            : Center(
                child: Text('waiting...'),
              ));
  }
}
