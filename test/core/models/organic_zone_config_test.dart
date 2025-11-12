import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/organic_zone_config.dart';

void main() {
  test('OrganicZoneConfig copyWith updates fields correctly', () {
    const config = OrganicZoneConfig(
      id: 'ZONE_A',
      name: 'Zone A',
      position: Offset(0.5, 0.5),
      size: 0.2,
      enabled: true,
    );

    final updated = config.copyWith(
      name: 'Zone A2',
      position: const Offset(0.6, 0.4),
      size: 0.3,
      enabled: false,
    );

    expect(updated.id, 'ZONE_A');
    expect(updated.name, 'Zone A2');
    expect(updated.position, const Offset(0.6, 0.4));
    expect(updated.size, 0.3);
    expect(updated.enabled, false);
  });
}

