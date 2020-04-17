import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/image_testing_provider.dart';

class ImageTesting extends StatelessWidget {
  final ImageTestingProvider provider;

  ImageTesting(this.provider);
  @override
  Widget build(BuildContext context) {
    //final imageTestingProvider = Provider.of<ImageTestingProvider>(context);
    return ChangeNotifierProvider<ImageTestingProvider>.value(
      value: ImageTestingProvider(),
      child: Consumer<ImageTestingProvider>(
        builder: (context, prov, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Image Testing'),
              ),
              body: Center(
                  child: (provider.latlngList.isNotEmpty)
                      ? ListView.builder(
                          itemCount: provider.latlngList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 100,
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                            '${provider.latlngList[index].latitude}'),
                                      ),
                                      Center(
                                        child: Text(
                                            '${provider.latlngList[index].longitude}'),
                                      ),
                                    ],
                                  ),
                                  Image.memory(provider.thumbDataList[index])
                                ],
                              ),
                            );
                          },
                        )
                      : Text('NONE')));
        },
      ),
    );
  }
}
