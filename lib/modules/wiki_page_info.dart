import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    var size = MediaQuery.of(context).size;
    return (provider.isPagePicsDoneLoading != false)
        ? Container(
            decoration: BoxDecoration(color: Colors.grey),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              //controller: controller,
              itemCount: provider.imageUrls.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (size.width) / (size.height / 2),
              ),
              itemBuilder: (context, _index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () => print('${provider.imageUrls[_index]}'),
                    child: FutureBuilder(builder: (context, snapshot) {
                      return GridTile(
                        child: Container(
                          //width
                          //height
                          child: (provider.imageUrls[_index].contains('svg'))
                              ? SvgPicture.network(
                                  provider.imageUrls[_index],
                                  fit: BoxFit.fill,
                                )
                              : FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: provider.imageUrls[_index],
                                  fadeInDuration:
                                      const Duration(milliseconds: 700),
                                  fit: BoxFit.fill,
                                ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ))
        : Center(
            child: Text('waiting'),
          );
  }
}

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
