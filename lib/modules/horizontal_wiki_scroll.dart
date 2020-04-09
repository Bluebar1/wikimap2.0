/*
Created NB 4/3/2020
HorizontalWikiScroll
Widget called from  MapBottomSheet (map_bottom_sheet.dart)
Surrounded by a vertical scrollcontroller, contains horizontal scrollcontroller
*/

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/modules/no_image_found_module.dart';
import 'package:wiki_map/modules/wiki_page_info.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiki_map/providers/wiki_page_pics_provider.dart';

class HorizontalWikiScroll extends StatelessWidget {
  final MapBottomSheetProvider provider;
  final ScrollController controller;
  HorizontalWikiScroll({@required this.provider, @required this.controller});
  @override
  Widget build(BuildContext context) {
    //ScrollController _scrollController = ScrollController();
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);
    var geosearchProvider = Provider.of<GeoSearchProvider>(context);
    //SwiperController _controller = SwiperController();
    return ListView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(), 
      children: <Widget>[
          Container(
            height: 200,
            child: (provider.isArticlesDoneLoading == true)
            ? Swiper(
                //pagination: SwiperPagination(),
                controller: swiperIndexProvider.controller,
                //index: swiperIndexProvider.currentIndex,
                onIndexChanged: (value) {
                  swiperIndexProvider.changeCurrentIndex(value);
                  provider.getAndSetPagePics();
                  },
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(builder: (context, snapshot) {
                    return GestureDetector(
                        onTap: () =>
                            print('${provider.currentArticles[index].title}'),
                        child:
                            (provider.currentArticles[index].original != null)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: (provider.currentArticles[index]
                                            .original.source
                                            .contains('.svg'))
                                        ? SvgPicture.network(
                                            provider.currentArticles[index]
                                                .original.source,
                                            fit: BoxFit.cover,
                                          )
                                        : FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: provider
                                                .currentArticles[index]
                                                .original
                                                .source,
                                            fadeInDuration:
                                                const Duration(seconds: 1),
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : NoImageFound(
                                    index: index,
                                  ));
                  });
                },
                itemCount: provider.currentArticles.length,
                viewportFraction: 0.8,
                scale: 0.9,
              )
            : Center(
                child: Text('waiting2...'),
              )),
        
        SizedBox(height: 30,),

        (provider.isPagePicsDoneLoading == true)
        ? WikiPageInfo(provider: provider, controller: controller)
        : Center(child: Text('waiting for pics to load'),)
      ]);
      
      
                
    
  }
}
// ? Container(
//   decoration: BoxDecoration(color: Colors.cyan),
//   child: ListView.builder(
//     physics: NeverScrollableScrollPhysics(),
//     controller: _scrollController,
//     itemCount: provider.currentArticles.length,
//     itemBuilder: (context, index) {
//       return ListTile(title: Text('Item ${provider.currentArticles[index].title}'));
//     },
//     ),
// )
//   : Center(child: Text('loading'));
