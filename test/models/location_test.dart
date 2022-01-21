import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/models/models.dart' show Location;

void main() {
  group('Location', () {

    const woeid = 1;
    const title = 'Minneapolis';
    const location = Location(
      woeid: woeid,
      title: title,
    );
    const json = <String, dynamic>{
      'woeid': woeid,
      'title': title,
    };

    test('toJson', () {
      expect(location.toJson(), json);
    });

    test('fromJson', () {
      expect(Location.fromJson(json), location);
    });

  });
}
