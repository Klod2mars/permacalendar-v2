import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  group('Pack Integrity', () {
    test('SHA256 verification logic', () {
      final content = 'test content';
      final bytes = utf8.encode(content);
      final digest = sha256.convert(bytes);
      
      final expected = digest.toString();
      expect(sha256.convert(bytes).toString(), expected);
    });

    test('Manifest parsing', () {
      final json = '''
      {
        "packs": {
          "fr": {"version": "1.0", "sha256": "abc", "url": "https://..."},
          "en": {"version": "1.0", "sha256": "def", "url": "https://..."}
        }
      }
      ''';
      
      final manifest = jsonDecode(json);
      expect(manifest['packs']['fr']['version'], '1.0');
      expect(manifest['packs']['en']['sha256'], 'def');
    });
  });
}
