
import 'package:adhkaar/screens/explore_screen.dart';

final String tableLocation = 'cities';
final String columnCityName = 'city_name';
final String columnLatitude = 'latitude';
final String columnLongitude = 'longitude';
final String columnCountryCode = 'country_code';
final String columnAltitude = 'altitude';
final String columnTimezone = 'timezone';
final String columnUtcOffset = 'utc_offset';

class Location {
  int altitude;
  String cityName;
  String countryCode;
  double latitude;
  double longitude;
  String timezone;
  double utcOffset;

  Location();


  Location.current(this.altitude, this.cityName, this.countryCode, this.latitude,
      this.longitude, this.timezone, this.utcOffset);

  Location.fromMap(Map<String, dynamic> map) {

    try {
      altitude = map['altitude'];

      cityName = map['city_name'].toString();
      countryCode = map['country_code'].toString();
      latitude = map['latitude'];
      longitude = map['longitude'];
      timezone = map['timezone'].toString();
      utcOffset = map['utc_offset'];
    }
    catch(e)
    {
      print(map);
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
   columnAltitude : altitude,
   columnCityName : cityName,
   columnCountryCode : countryCode,
   columnLatitude : latitude,
   columnLongitude : longitude,
   columnTimezone : timezone,
   columnUtcOffset : utcOffset,
    };

    return map;
  }





}