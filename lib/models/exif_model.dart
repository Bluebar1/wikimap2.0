import 'package:exif/exif.dart';

class Exif {
  final String imageMake;
  final String imageModel;
  // final Ratio imageXResolution;
  // final Ratio imageYResolution;
  final String software;
  final double gpsLatitude;
  final double gpsLongitude;

  Exif(
    this.imageMake,
    this.imageModel,
    // this.imageXResolution,
    // this.imageYResolution,
    this.software,
    this.gpsLatitude,
    this.gpsLongitude
  );

  static double convertLatitude(List<dynamic> ratioList) {
    print('CONVERT LATITUDE CALLED');
    print(ratioList[0].runtimeType);
    print(ratioList[0].toString());
    var hour = ratioList[0].numerator;
    print('Hour : $hour');
    var minute = ratioList[1].numerator;
    print('Minute : $minute');
    var second = ratioList[2].numerator / ratioList[2].denominator;
    print('Second : $second');
    print('${(hour) + (minute/60) + (second/3600)}');
    return (hour) + (minute/60) + (second/3600);
    //var hour = double.parse(ratioList[0].toString());
    //var minute = double.parse(ratioList[0].toString()
   // print(dub);
    // print(parsedJson)
    // print('${
    //   (parsedJson['GPS GPSLatitude'].values[0]) + 
    //   (parsedJson['GPS GPSLatitude'].values[1]/60) +
    //   (parsedJson['GPS GPSLatitude'].values[2]/3600)
    // }');
    // return 
    //   (parsedJson['GPS GPSLatitude'].values[0]) + 
    //   (parsedJson['GPS GPSLatitude'].values[1]/60) +
    //   (parsedJson['GPS GPSLatitude'].values[2]/3600);
  }

  static double convertLongitude(List<dynamic> ratioList) {
    print('CONVERT Longitude CALLED');
    print(ratioList.toString());
    var hour = ratioList[0].numerator;
    var minute = ratioList[1].numerator;
    var second = ratioList[2].numerator / ratioList[2].denominator;
    print('${-((hour) + (minute/60) + (second/3600))}');
    return -((hour) + (minute/60) + (second/3600));
  }

  Exif.fromJson(Map<String, IfdTag> parsedJson)
      : imageMake = (parsedJson['Image Make'] != null) 
                        ? parsedJson['Image Make'].toString()
                        : '',
        imageModel = (parsedJson['Image Model'] != null) 
                        ? parsedJson['Image Model'].toString()
                        : '',
        
        // imageXResolution = (parsedJson['Image XResolution'].values[0] != null) 
        //                 ? parsedJson['Image XResolution'].values[0]
        //                 : 0,
        
        // imageYResolution = (parsedJson['Image YResolution'].values[0] != null) 
        //                 ? parsedJson['Image YResolution'].values[0]
        //                 : 0,
        
        software = (parsedJson['Image Software'] != null) 
                        ? parsedJson['Image Software'].toString()
                        : '',
        
        gpsLatitude = (parsedJson['GPS GPSLatitude'].values != null)
                          ? convertLatitude(parsedJson['GPS GPSLatitude'].values)
                          : 0,

        gpsLongitude = (parsedJson['GPS GPSLongitude'].values != null)
                          ? convertLongitude(parsedJson['GPS GPSLongitude'].values)
                          : 0;
  
}