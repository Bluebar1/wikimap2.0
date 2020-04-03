/*
Created NB 4/3/2020
HorizontalWikiScroll
Widget called from  MapBottomSheet (map_bottom_sheet.dart)
Surrounded by a vertical scrollcontroller, contains horizontal scrollcontroller
*/

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/modules/no_image_found_module.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';

class HorizontalWikiScroll extends StatelessWidget {
  final MapBottomSheetProvider provider;
  HorizontalWikiScroll({@required this.provider});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: (provider.isDoneLoading == true)
            ? Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(builder: (context, snapshot) {
                    return GestureDetector(
                        onTap: () =>
                            print('${provider.currentArticles[index].title}'),
                        child: (provider.currentArticles[index].original !=
                                null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: (provider.currentArticles[index]
                                              .original !=
                                          null)
                                      ? provider.currentArticles[index].original
                                          .source
                                      : 'https://www.solidbackgrounds.com/images/2560x1440/2560x1440-davys-grey-solid-color-background.jpg',
                                  fadeInDuration: const Duration(seconds: 1),
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
              ));
  }
}
