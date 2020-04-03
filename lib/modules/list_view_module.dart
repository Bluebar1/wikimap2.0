import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wiki_map/providers/map_bottom_sheet_provider.dart';

class ListViewModule extends StatelessWidget {
  //
  final MapBottomSheetProvider provider;
  final ScrollController controller;
  //
  ListViewModule({@required this.provider, @required this.controller});

  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: provider.currentArticles.length,
      controller: controller,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () =>
              print('${provider.currentArticles[index].title} has been tapped'),
          child: FutureBuilder(builder: (context, snapshot) {
            return GridTile(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 408,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: (provider.currentArticles[index].original != null)
                          ? provider.currentArticles[index].original.source
                          : 'https://www.solidbackgrounds.com/images/2560x1440/2560x1440-davys-grey-solid-color-background.jpg',
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 1),
                    ),
                  ),
                  Container(
                    height: 408,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(0, 0, 0, .4)),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          provider.currentArticles[index].title,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            provider.currentArticles[index].pageid.toString(),
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
/*
return GridTile(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 408,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: (provider.currentArticles[index].original != null)
                          ? provider.currentArticles[index].original.source
                          : 'https://www.solidbackgrounds.com/images/2560x1440/2560x1440-davys-grey-solid-color-background.jpg',
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 1),
                    ),
                  ),
                  Container(
                    height: 408,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(0, 0, 0, .4)),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          provider.currentArticles[index].title,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            provider.currentArticles[index].pageid.toString(),
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            );
            */
