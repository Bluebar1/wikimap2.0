import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/image_testing_provider.dart';
import 'package:wiki_map/screens/image_testing.dart';
import 'package:wiki_map/screens/image_testing_v2.dart';

class AlbumSelectionPageV2 extends StatefulWidget {
  @override
  _AspState createState() => _AspState();
}

class _AspState extends State<AlbumSelectionPageV2> {
  ImageTestingProvider get provider =>
      Provider.of<ImageTestingProvider>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    void _goToImageTesting(int index) {
      provider.runPathsNew(index);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ChangeNotifierProvider<ImageTestingProvider>.value(
            value: provider, child: ImageTestingV2());
      }));
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (_) => ImageTestingV2()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: (provider.albumThumbViewList.isNotEmpty)
          ? ListView.builder(
              itemCount: provider.list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _goToImageTesting(index),
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Text('${provider.list[index].name}'),
                        ListView.builder(
                            itemCount:
                                provider.albumThumbViewList[index].length,
                            itemBuilder: (_content, _index) {
                              return SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.memory(
                                  provider.albumThumbViewList[index][_index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                );
              })
          : Container(),
    );
  }
}
