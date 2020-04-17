import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/image_testing_provider.dart';
import 'package:wiki_map/screens/image_testing.dart';

class ImageTestingV2 extends StatefulWidget {
  @override
  _ImageTestingState createState() => _ImageTestingState();
}

class _ImageTestingState extends State<ImageTestingV2> {
  ImageTestingProvider get provider =>
      Provider.of<ImageTestingProvider>(context);
  @override
  Widget build(BuildContext context) {
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
  }
}
