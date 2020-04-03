import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';

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
