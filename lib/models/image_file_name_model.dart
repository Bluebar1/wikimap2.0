/*
In order to access the URLs to all the images on a wikipedia page
you must first send a request to get the name of each file, and
once you have all the names of the file you can send another request 
to get the URLs.

The names of the Files are stores in this object
*/
class ImageFileName {
  final int ns;
  final String title;

  ImageFileName({this.ns, this.title});

  ImageFileName.fromJson(Map<dynamic, dynamic> parsedJson)
      : ns = parsedJson['ns'],
        title = parsedJson['title'];
}
