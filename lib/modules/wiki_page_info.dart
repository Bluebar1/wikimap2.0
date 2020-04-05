import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

class WikiPageInfo extends StatelessWidget {
  final MapBottomSheetProvider provider;
  WikiPageInfo({@required this.provider});
  @override
  Widget build(BuildContext context) {
    var swiperProvider = Provider.of<SwiperIndexProvider>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.cyan),
      height: 600,
      child: Column(
        children: <Widget>[
          Text(
              '${provider.currentArticles[swiperProvider.currentIndex].title}'),
          Text('${provider.currentArticles[swiperProvider.currentIndex].ns}'),
          Text(
              '${provider.currentArticles[swiperProvider.currentIndex].pageid}'),
        ],
      ),
    );
  }
}
