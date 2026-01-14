import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/data/plants.json');
  final content = file.readAsStringSync();
  final data = json.decode(content);
  
  final count = (data['plants'] as List).length;
  final metaCount = data['metadata']['total_plants'];
  
  print('Real Count: $count');
  print('Meta Count: $metaCount');
  
  if (count != metaCount) {
    print('MISMATCH!');
  } else {
    print('MATCH!');
  }
}
