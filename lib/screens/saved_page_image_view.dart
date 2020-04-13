import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/providers/saved_page_image_view_provider.dart';
import 'package:wiki_map/providers/view_saved_page_provider.dart';
import 'package:photo_view/photo_view.dart';

class SavedPageImageView extends StatelessWidget {
  final ViewSavedPageProvider viewSavedPageProvider;

  SavedPageImageView({@required this.viewSavedPageProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavedPageImageViewProvider(),
      child: Consumer<SavedPageImageViewProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: PhotoView(
                  imageProvider:
                      NetworkImage('${viewSavedPageProvider.imageUrl}'),
                  controller: provider.photoViewController,
                ),
              ),
              Positioned(
                top: 50,
                child: Text(
                  'Scale applied: ' + '${provider.scaleCopy}',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color.fromRGBO(192, 192, 192, 1.0)),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 20,
                child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Go back',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color.fromRGBO(192, 192, 192, 1.0)),
                    )),
              )
            ],
          );
        },
        child: Container(
            child: PhotoView.customChild(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: viewSavedPageProvider.imageUrl,
            fadeInDuration: const Duration(seconds: 1),
          ),
        )),
      ),
    );
  }
}
