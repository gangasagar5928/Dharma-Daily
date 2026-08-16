import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

// This test makes a real HTTP request to Google Drive and is intentionally
// skipped in CI. Run locally with:
//   flutter test test/drive_download_test.dart
void main() {
  test(
    'Test Google Drive direct download URL with HttpClient',
    () async {
      final client = HttpClient();
      final urlStr =
          'https://drive.usercontent.google.com/download?id=1gecOppWsqtKgfrJu63a6lrg945PmO-rT&export=download&confirm=t';
      final request = await client.getUrl(Uri.parse(urlStr));
      request.headers.set('User-Agent', 'Mozilla/5.0');
      final response = await request.close();

      print('Status Code: ${response.statusCode}');
      print('Content Length: ${response.contentLength}');
      print('Content Type: ${response.headers.contentType}');

      expect(response.statusCode, 200);
      expect(response.contentLength > 1000000, true);

      client.close();
    },
    skip: Platform.environment.containsKey('CI')
        ? 'Skipped in CI — requires live Google Drive access'
        : false,
  );
}
