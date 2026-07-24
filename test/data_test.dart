import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/data/data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('DataService loads all scriptures, vedas, puranas, traditions',
      () async {
    final ds = DataService();
    try {
      await ds.loadAllData();
    } catch (e, stack) {
      print('EXPLICIT EXCEPTION: $e');
      print('STACK TRACE:\n$stack');
    }

    print('Loaded Scriptures: ${ds.scriptures.length}');
    print('Loaded Vedas: ${ds.vedas.length}');
    print('Loaded Purans: ${ds.puranas.length}');
    print('Loaded Traditions: ${ds.traditions.length}');

    expect(ds.scriptures.isNotEmpty, true);
    expect(ds.vedas.isNotEmpty, true);
    expect(ds.puranas.isNotEmpty, true);
    expect(ds.traditions.isNotEmpty, true);
  });
}
