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

/*
Created NB 4/3/2020
HorizontalWikiScroll
Widget called from  MapBottomSheet (map_bottom_sheet.dart)
Surrounded by a vertical scrollcontroller, contains horizontal scrollcontroller

This widget Contains all of widgets for displaying information in the bottom sheet 
when viewing geosearch results and the information for each article
*/

class HorizontalWikiScroll extends StatelessWidget {
  final MapBottomSheetProvider provider;
  final ScrollController controller;
  HorizontalWikiScroll({@required this.provider, @required this.controller});
  @override
  Widget build(BuildContext context) {
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);
    var geosearchProvider = Provider.of<GeoSearchProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, .9),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: ListView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
                height: 200,
                child: (provider.isArticlesDoneLoading == true)
                    ? Swiper(
                        index: swiperIndexProvider.currentIndex,
                        controller: swiperIndexProvider.controller,
                        onIndexChanged: (value) {
                          swiperIndexProvider.changeCurrentIndex(value);
                          provider.getAndSetPagePics();
                          geosearchProvider.changeCurrentMarker();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder(builder: (context, snapshot) {
                            return GestureDetector(
                                onTap: () {
                                  print(
                                      '${provider.currentArticles[index].title} : ${provider.currentArticles[index].original.source}');
                                  print(
                                      '${provider.currentArticles[swiperIndexProvider.currentIndex].title} : ${provider.currentArticles[swiperIndexProvider.currentIndex].original.source}');
                                },
                                child: (provider
                                            .currentArticles[index].original !=
                                        null)
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
            SizedBox(
              height: 40,
            ),
            (provider.summaries.length == geosearchProvider.results.length)
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Summary:',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            '${provider.summaries[swiperIndexProvider.currentIndex]}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: Text('waiting')),
            (provider.isArticlesDoneLoading == true)
                ? SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                          '${provider.currentArticles[swiperIndexProvider.currentIndex].title}'),
                    ),
                  )
                : SizedBox(
                    height: 30,
                    child: Center(child: Text('loading')),
                  ),
            (provider.isPagePicsDoneLoading == true)
                ? WikiPageInfo(provider: provider, controller: controller)
                : Center(
                    child: Text('waiting for pics to load'),
                  ),
          ]),
    );
  }
}
