
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/climate/domain/models/zone.dart';
import 'package:permacalendar/features/plant_catalog/domain/services/phase_resolver.dart';

void main() {
  group('PhaseResolver', () {
    final plant = PlantFreezed.create(
      commonName: 'Test Plant',
      scientificName: 'Testus',
      family: 'Testaceae',
      plantingSeason: 'Printemps',
      harvestSeason: 'Été',
      daysToMaturity: 60,
      spacing: 30,
      depth: 1,
      sunExposure: 'Soleil',
      waterNeeds: 'Moyen',
      description: 'Desc',
      sowingMonths: ['Mar', 'Apr'], // Legacy / Europe
      harvestMonths: ['Jul', 'Aug'],
      referenceProfile: {
        'phases': {
          'sowing': {'type': 'months', 'months': ['Mar', 'Apr']},
          'planting': {'type': 'months', 'months': ['May']},
        }
      },
      zoneProfiles: {
        'NH_temperate_na': {
          'phases': {
            'sowing': {'type': 'relative', 'relativeTo': 'lastFrost', 'offsetDays': -14, 'windowDays': 21}
          }
        }
      }
    );

    test('should return reference months for Europe zone', () {
      final zone = Zone(id: 'NH_temperate_europe', name: 'Europe', monthShift: 0);
      
      final phases = PhaseResolver.resolvePhases(plant, zone, 'sowing');
      expect(phases, ['Mar', 'Apr']);
    });

    test('should apply month shift for SH zone', () {
      final zone = Zone(id: 'SH_temperate', name: 'Sud', monthShift: 6);
      
      final phases = PhaseResolver.resolvePhases(plant, zone, 'sowing');
      // Mar(3) + 6 = Sep(9)
      // Apr(4) + 6 = Oct(10)
      expect(phases, ['Sep', 'Oct']);
    });
    
    test('should resolve relative rule for NA zone', () {
      final zone = Zone(id: 'NH_temperate_na', name: 'NA', monthShift: 0);
      final lastFrost = DateTime(2024, 5, 15); // 15 Mai
      
      // Rule: sowing = lastFrost - 14 days (May 1) window 21 days (May 1 to May 22)
      // So months should be ['May']
      
      final phases = PhaseResolver.resolvePhases(plant, zone, 'sowing', lastFrostDate: lastFrost);
      
      expect(phases, contains('May'));
      expect(phases.length, 1);
    });

    test('should resolve relative rule spanning months', () {
       final zone = Zone(id: 'NH_temperate_na', name: 'NA', monthShift: 0);
       final lastFrost = DateTime(2024, 6, 1); // 1 Juin
       
       // Rule: sowing = lastFrost - 14 days (May 18) window 21 days (May 18 to June 8)
       // Months: May, Jun
       
       final phases = PhaseResolver.resolvePhases(plant, zone, 'sowing', lastFrostDate: lastFrost);
       expect(phases, ['May', 'Jun']);
    });
  });
}
