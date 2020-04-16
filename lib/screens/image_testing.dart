import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/image_testing_provider.dart';

class ImageTesting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageTestingProvider = Provider.of<ImageTestingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Testing'),
      ),
      body: Center(
          child: (imageTestingProvider.list != null)
              ? Text('${imageTestingProvider.list.length}')
              : Text('NONE')),
    );
  }
}
