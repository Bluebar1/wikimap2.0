import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';
import 'package:wiki_map/providers/saved_pages_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

class WikiActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var savedPagesProvider = Provider.of<SavedPagesProvider>(context);
    var mapBottomSheetProvider = Provider.of<MapBottomSheetProvider>(context);
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);

    String currentTitle = mapBottomSheetProvider
        .currentArticles[swiperIndexProvider.currentIndex].title;
    String currentPageId = mapBottomSheetProvider
        .currentArticles[swiperIndexProvider.currentIndex].pageid
        .toString();

    _showPageSavedFlushbar() {
      return Flushbar(
        message: '$currentTitle has been added to Saved Pages!',
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

    void _addSavedPage() {
      savedPagesProvider.addSavedPage(currentTitle);
      savedPagesProvider.addSavedWikiPageId(currentPageId);
      _showPageSavedFlushbar();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () => _addSavedPage(),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 30,
                ),
                Text(
                  'Save Page',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => print('tapped'),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 30,
                ),
                Text(
                  'Something Else',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
