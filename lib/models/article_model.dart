import 'package:wiki_map/models/original_wiki_image_model.dart';

/*
Created NB 4/2/2020
Model class to store data from Wiki API image link
The link can be found in the OriginalWikiImage class,
where it is stored with its width and height
*/
class Article {
  final int pageid;
  final int ns;
  final String title;
  final OriginalWikiImage original;

  Article({this.pageid, this.ns, this.title, this.original});

  Article.fromJson(Map<dynamic, dynamic> parsedJson)
      : pageid = parsedJson['pageid'],
        ns = parsedJson['ns'],
        title = parsedJson['title'],
        original = (parsedJson['original'] != null)
            ? OriginalWikiImage.fromJson(parsedJson['original'])
            : null;
}
