import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/modules/no_image_found_module.dart';
import 'package:wiki_map/modules/wiki_action_buttons.dart';
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

    //   void _viewWikiPage() {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => ImageView()
    //       ));
    // }

    return Stack(
      //overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            height: 5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 1.0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, .9)),
              child: ListView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Container(
                        height: 200,
                        padding: EdgeInsets.only(top: 30),
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
                                  return FutureBuilder(
                                      builder: (context, snapshot) {
                                    return GestureDetector(
                                        onTap: () {
                                          print(
                                              '${provider.currentArticles[index].title} : ${provider.currentArticles[index].original.source}');
                                          print(
                                              '${provider.currentArticles[swiperIndexProvider.currentIndex].title} : ${provider.currentArticles[swiperIndexProvider.currentIndex].original.source}');
                                        },
                                        child: (provider.currentArticles[index]
                                                    .original !=
                                                null)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: (provider
                                                        .currentArticles[index]
                                                        .original
                                                        .source
                                                        .contains('.svg'))
                                                    ? SvgPicture.network(
                                                        provider
                                                            .currentArticles[
                                                                index]
                                                            .original
                                                            .source,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : FadeInImage.memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image: provider
                                                            .currentArticles[
                                                                index]
                                                            .original
                                                            .source,
                                                        fadeInDuration:
                                                            const Duration(
                                                                seconds: 1),
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
                    (provider.isArticlesDoneLoading == true)
                        ? SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                '${provider.currentArticles[swiperIndexProvider.currentIndex].title}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          )
                        : Container(),
                    (provider.isArticlesDoneLoading == true)
                        ? WikiActionButtons()
                        : Container(),
                    SizedBox(height: 30),
                    (provider.summaries.length ==
                            geosearchProvider.results.length)
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Summary:',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    '${provider.summaries[swiperIndexProvider.currentIndex]}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(child: Text('waiting')),
                    SizedBox(height: 40),
                    (provider.isPagePicsDoneLoading == true)
                        ? Center(
                            child: Text(
                              '${provider.imageUrls.length} Images Found for ${provider.currentArticles[swiperIndexProvider.currentIndex].title}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        : Container(),
                    (provider.isPagePicsDoneLoading == true)
                        ? WikiPageInfo(
                            provider: provider, controller: controller)
                        : Center(
                            child: Text('waiting for pics to load'),
                          ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
