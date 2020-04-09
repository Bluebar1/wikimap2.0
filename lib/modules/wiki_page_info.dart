import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:wiki_map/providers/wiki_page_pics_provider.dart';

class WikiPageInfo extends StatelessWidget { 
  final MapBottomSheetProvider provider;
  final ScrollController controller;
  WikiPageInfo({@required this.provider, @required this.controller});
  @override
  Widget build(BuildContext context) {
    // var swiperProvider = Provider.of<SwiperIndexProvider>(context);
    // ScrollController _scrollController = ScrollController();
    
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
                return FutureBuilder(builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () => print('${mapBottomSheetProvider.imageUrls[index]}'),
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
                                  image: mapBottomSheetProvider.imageUrls[index],
                                  fadeInDuration:
                                      const Duration(milliseconds: 700),
                                  fit: BoxFit.cover,
                                ),
                            ),
                          )
                    )
                  );
                },
                    
                );
              },
            )
            : Center(child: Text('waiting...'),)
            );
        
  }
}

/*
GridTile(
                      child: (provider.imageUrls[index].contains('svg'))
                          ? Center(child: Text('SVG'),)
                          // SvgPicture.network(
                          //     provider.imageUrls[_index],
                          //     fit: BoxFit.cover,
                          //   )
                          : FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: mapBottomSheetProvider.imageUrls[index],
                              fadeInDuration:
                                  const Duration(milliseconds: 700),
                              fit: BoxFit.cover,
                            ),
                    );
*/

/*
ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: provider.imageUrls.length,
        itemBuilder: (context, index) {
          return ListTile(title: Container( 
            child: Text('${provider.imageUrls[index]}'),
          ));
      }),
      */
