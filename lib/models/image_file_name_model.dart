class ImageFileName {
  final int ns;
  final String title;

  ImageFileName({this.ns, this.title});

  ImageFileName.fromJson(Map<dynamic, dynamic> parsedJson)
  : ns = parsedJson['ns'],
  title = parsedJson['title'];
}