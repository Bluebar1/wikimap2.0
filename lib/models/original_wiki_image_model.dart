/*
Created NB 4/2/2020
This class is a data structure used inside of the Article model (article_model.dart)
Stores the "original" section data of the Wikipedia API response
Example link: https://en.wikipedia.org/w/api.php?action=query&titles=Apple_Park&prop=pageimages&piprop=original&format=json
*/
class OriginalWikiImage {
  final String source;
  final int width;
  final int height;

  OriginalWikiImage({this.source, this.width, this.height});

  OriginalWikiImage.fromJson(Map<dynamic, dynamic> parsedJson)
      : source = parsedJson['source'],
        width = parsedJson['width'],
        height = parsedJson['height'];

  OriginalWikiImage.empty()
      : source = 'none',
        width = 0,
        height = 0;
}
