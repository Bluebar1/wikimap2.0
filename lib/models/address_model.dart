/*
Created NB 4/13/2020
*/

class Address {
  final String subThroughouhfare;
  final String thoroughfare;
  final String locality;
  final String country;
  final String postalCode;

  Address(
      {this.subThroughouhfare,
      this.thoroughfare,
      this.locality,
      this.country,
      this.postalCode});

  Address.fromJson(Map<dynamic, dynamic> parsedJson)
      : subThroughouhfare = parsedJson['subThroughouhfare'],
        thoroughfare = parsedJson['thoroughfare'],
        locality = parsedJson['locality'],
        country = parsedJson['country'],
        postalCode = parsedJson['postalCode'];
}
