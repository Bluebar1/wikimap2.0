import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/image_testing_provider.dart';
import 'package:wiki_map/screens/image_testing.dart';

class AlbumSelectionPage extends StatelessWidget {
  
  @override 
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageTestingProvider>(context);

    // void _goToImageTesting() {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (_) => ChangeNotifierProvider<ImageTestingProvider>(
    //             create: (context) => ImageTestingProvider(),
    //             child: ImageTesting(),
    //           )));
    // }

    void _goToImageTesting(int index) {
      provider.runPathsNew(index);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImageTesting(provider)));
    }

    return Scaffold(appBar: AppBar(
      title: Text('Test')),
      body: (provider.list.isNotEmpty)
       ? ListView.builder(
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () => _goToImageTesting(index),
                child: SizedBox(
                height: 40,
                child: Text('${provider.list[index].name}'),
                ),
            );
          })
      : Container(),
      );


    // return (provider.latlngList.isNotEmpty)
    //    ? ListView.builder(
    //       itemCount: provider.list.length,
    //       itemBuilder: (context, index) {
    //         return GestureDetector(
    //             onTap: () => _goToImageTesting(index),
    //             child: SizedBox(
    //             height: 40,
    //             child: Text('${provider.list[index].name}'),
    //             ),
    //         );
    //       })
    //   : Container()
  }
}