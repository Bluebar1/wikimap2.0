import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/providers/saved_page_image_view_provider.dart';
import 'package:wiki_map/providers/view_saved_page_provider.dart';
import 'package:wiki_map/providers/theme_provider.dart';
import 'package:wiki_map/screens/saved_page_image_view.dart';

class ViewSavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var viewSavedPageProvider = Provider.of<ViewSavedPageProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Wiki Page'),
        ),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (_) => SavedPageImageViewProvider(),
                          child: Consumer<SavedPageImageViewProvider>(
                            builder: (context, provider, _) {
                              return SavedPageImageView(
                                  viewSavedPageProvider: viewSavedPageProvider);
                            },
                          ),
                        )));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: viewSavedPageProvider.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(seconds: 1),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(themeProvider.hexOfCurrentPrimary)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    viewSavedPageProvider.title,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(themeProvider.hexOfCurrentPrimary)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  '${viewSavedPageProvider.pageId}',
                  maxLines: 20,
                  overflow: TextOverflow.fade,
                ),
              ),
            )
          ],
        ));
  }
}
