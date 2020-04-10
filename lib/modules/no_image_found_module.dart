import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';

/*
Created NB 4/10/2020

Widget to display when an image is not found to display
in the top horizontal image scroll section

Is passed index so it knows where to put this widget in
the list of images contained in the Swiper widget (horizontal_wiki_scroll.dart)

TODO: (nb) Instead of passing the index from the swiper, just pull the index
from SwiperIndexProvider.currentIndex
*/

class NoImageFound extends StatelessWidget {
  final int index;
  NoImageFound({@required this.index});
  @override
  Widget build(BuildContext context) {
    var mapBottomSheetProvider = Provider.of<MapBottomSheetProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, .5),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
          child:
              Text('${mapBottomSheetProvider.currentArticles[index].title}')),
    );
  }
}
