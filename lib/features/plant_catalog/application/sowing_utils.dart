// lib/features/plant_catalog/application/sowing_utils.dart

import 'package:flutter/material.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/climate/domain/models/zone.dart';
import 'package:permacalendar/features/plant_catalog/domain/services/phase_resolver.dart';

// --- NEW HELPER FOR SEASON DERIVATION ---
String deriveSeasonLabelFromMonths(List<String> months) {
  if (months.isEmpty) return '';
  
  // 1. Normalize to integers 1..12
  final ints = <int>{};
  for (final m in months) {
    if (m.length >= 3) {
      final idx = _monthTokenToIndex(m);
      if (idx != null) ints.add(idx);
    } else {
      // numeric fallback ?
      final n = int.tryParse(m);
      if (n != null && n >= 1 && n <= 12) ints.add(n);
    }
  }
  
  if (ints.isEmpty) return '';
  final sorted = ints.toList()..sort();
  
  // 2. Build blocks
  // Handle simple contiguous blocks first
  List<List<int>> blocks = [];
  if (sorted.isNotEmpty) {
    List<int> currentBlock = [sorted.first];
    for (int i = 1; i < sorted.length; i++) {
        if (sorted[i] == sorted[i-1] + 1) {
            currentBlock.add(sorted[i]);
        } else {
            blocks.add(currentBlock);
            currentBlock = [sorted[i]];
        }
    }
    blocks.add(currentBlock);
  }

  // 3. Handle Winter wrapping (e.g. Dec + Jan)
  // Check if first block is Jan (1) and last block is Dec (12)
  if (blocks.length > 1 && blocks.first.first == 1 && blocks.last.last == 12) {
     // Merge last block into first (prepend)
     // Technically for visualization "Dec-Feb" is better than "Jan-Feb, Dec", but let's see.
     // For typical season names it's better to detect the set.
  }
  
  // 4. Try to match full seasons
  final allInts = ints.toSet();
  final isSpring = _isSubset({3,4,5}, allInts) && allInts.length <= 4; // allow +/- 1 month maybe? No, let's be strict for "Printemps" label or exact range
  
  if (_areSetsEqual(allInts, {3,4,5})) return 'Printemps';
  if (_areSetsEqual(allInts, {6,7,8})) return 'Été';
  if (_areSetsEqual(allInts, {9,10,11})) return 'Automne';
  if (_areSetsEqual(allInts, {12,1,2})) return 'Hiver';
  
  // Combos
  if (_areSetsEqual(allInts, {3,4,5, 9,10,11})) return 'Printemps, Automne';
  if (_areSetsEqual(allInts, {3,4,5, 6,7,8})) return 'Printemps, Été';
  
  // 5. Fallback to Ranges
  // Helper to name months
  String name(int m) => ['Jan','Fév','Mar','Avr','Mai','Juin','Juil','Aoû','Sep','Oct','Nov','Déc'][m-1];
  
  // Check specifically for wrapped winter block for display 'Nov-Fév'
  if (blocks.last.last == 12 && blocks.first.first == 1) {
      // Re-sort for winter check? 
      // Simplified: Just print blocks
  }

  return blocks.map((b) {
    if (b.length == 1) return name(b.first);
    return '${name(b.first)}–${name(b.last)}';
  }).join(', ');
}

int? _monthTokenToIndex(String t) {
  // expects strict 3-letters from new MonthPicker or full
  // But also handle legacy 'jan', 'Jan' etc.
  final list = ['jan','fev','fév','mar','avr','mai','jui','aou','aoû','sep','oct','nov','dec','déc'];
  final lower = t.toLowerCase().substring(0,3);
  // manual map
  if (lower == 'jan') return 1;
  if (lower == 'fev' || lower == 'fév') return 2;
  if (lower == 'mar') return 3;
  if (lower == 'avr') return 4;
  if (lower == 'mai') return 5;
  if (lower == 'jui') return t.toLowerCase().contains('juil') ? 7 : (t.toLowerCase().contains('juin') ? 6 : null); // Ambiguous 'jui' if strict 3 chars? 'juin', 'juil' are 4 chars usually in French abbr but 'jun'/'jul' in en.
  // Wait, MonthPicker sends 'Juin' (4 chars) or 'Juil' (4 chars) or 'Jui'??
  // MonthPicker code: 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
  if (t == 'Juin') return 6;
  if (t == 'Juil') return 7;
  
  if (lower == 'jun') return 6;
  if (lower == 'jul') return 7;
  if (lower == 'aou' || lower == 'aoû') return 8;
  if (lower == 'sep') return 9;
  if (lower == 'oct') return 10;
  if (lower == 'nov') return 11;
  if (lower == 'dec' || lower == 'déc') return 12;
  return null;
}

bool _areSetsEqual(Set<int> a, Set<int> b) => a.length == b.length && a.containsAll(b);
bool _isSubset(Set<int> sub, Set<int> superSet) => superSet.containsAll(sub);

// --- END NEW HELPER ---

enum ActionType { sow, plant }
enum SeasonStatus { green, orange, red, unknown }

class SeasonInfo {
  final SeasonStatus status;
  final int distance; // minimal month distance (0 if exact)
  final Set<int> eligibleMonths;
  SeasonInfo({
    required this.status,
    required this.distance,
    required this.eligibleMonths,
  });
}

const int DEFAULT_NEAR_THRESHOLD = 1;
const int DEFAULT_LONG_SEASON_THRESHOLD = 3;

int? _monthFromToken(String token) {
  final t = token.trim().toLowerCase();
  if (t.isEmpty) return null;
  final n = int.tryParse(t);
  if (n != null && n >= 1 && n <= 12) return n;
  final short = t.length >= 3 ? t.substring(0,3) : t;
  switch (short) {
    case 'jan': case 'janv': return 1;
    case 'feb': case 'fev': case 'fév': return 2;
    case 'mar': case 'mars': return 3;
    case 'apr': case 'avr': return 4;
    case 'may': case 'mai': return 5;
    case 'jun': case 'jun': case 'juin': return 6;
    case 'jul': case 'jul': case 'juil': return 7;
    case 'aug': case 'aou': case 'ago': return 8;
    case 'sep': case 'sept': return 9;
    case 'oct': return 10;
    case 'nov': return 11;
    case 'dec': case 'déc': return 12;
    default: return null;
  }
}

Set<int> normalizeMonthTokens(List<dynamic>? tokens) {
  if (tokens == null) return {};
  final out = <int>{};
  for (final t in tokens) {
    final s = t.toString();
    if (s.trim().isEmpty) continue;
    if (s.contains('-') || s.contains('–')) {
      final parts = s.replaceAll('–','-').split('-');
      if (parts.length == 2) {
        final a = _monthFromToken(parts[0]);
        final b = _monthFromToken(parts[1]);
        if (a != null && b != null) {
          int cur = a;
          while (true) {
            out.add(cur);
            if (cur == b) break;
            cur = cur % 12 + 1;
          }
          continue;
        }
      }
    }
    final m = _monthFromToken(s);
    if (m != null) out.add(m);
  }
  return out;
}

Set<int> parseSeasonStringToMonths(String? season) {
  if (season == null || season.trim().isEmpty) return {};
  final s = season;
  // support "Printemps"/"SPRING" convert to typical mapping:
  final lower = s.toLowerCase();
  if (lower.contains('spring') || lower.contains('print')) {
    return {3,4,5}; // Mar-Apr-May
  } else if (lower.contains('summer') || lower.contains('été') || lower.contains('automne')==false && lower.contains('été')) {
    return {6,7,8};
  } else if (lower.contains('autumn') || lower.contains('fall') || lower.contains('automn')) {
    return {9,10,11};
  } else if (lower.contains('winter') || lower.contains('hiver')) {
    return {12,1,2};
  }
  return {};
}

Set<int> buildEligibleMonthsForAction(PlantFreezed plant, ActionType action, {Zone? zone, DateTime? lastFrostDate}) {
  // Nouvelle logique prioritaires si Zone fournie
  if (zone != null) {
    // Mapping ActionType -> string key pour PhaseResolver
    final typeKey = action == ActionType.sow ? 'sowing' : 'planting';
    
    // Pour l'instant harvest n'est pas utilisé dans sowing_utils (qui sert au calendrier de semis/plantation)
    
    final resolvedCodes = PhaseResolver.resolvePhases(plant, zone, typeKey, lastFrostDate: lastFrostDate);
    if (resolvedCodes.isNotEmpty) {
      // Conversion codes (jan, feb...) -> int (1..12)
      final ints = <int>{};
      for (final c in resolvedCodes) {
        final m = _monthFromToken(c);
        if (m != null) ints.add(m);
      }
      if (ints.isNotEmpty) return ints;
    }
  }

  // Fallback Legacy (Si pas de zone ou pas de résultat)
  if (action == ActionType.sow) {
    // ... Legacy logic remains as fallback
    final s3 = normalizeMonthTokens(plant.metadata['sowingMonths3'] ?? plant.toJson()['sowingMonths3']);
    if (s3.isNotEmpty) return s3;
    final s = normalizeMonthTokens(plant.toJson()['sowingMonths'] ?? plant.metadata['sowingMonths']);
    if (s.isNotEmpty) return s;
    return {};
  } else {
    // planting
    final pm = normalizeMonthTokens(plant.metadata['plantingMonths'] ?? plant.toJson()['plantingMonths']);
    if (pm.isNotEmpty) return pm;
    final season = plant.plantingSeason;
    if (season != null && season.toString().trim().isNotEmpty) {
      final parsed = parseSeasonStringToMonths(season.toString());
      if (parsed.isNotEmpty) return parsed;
    }
    return {};
  }
}


int distanceForward(int from, int to) => (to - from + 12) % 12;
int distanceBackward(int from, int to) => (from - to + 12) % 12;

SeasonInfo computeSeasonInfoForPlant({
  required PlantFreezed plant,
  required DateTime date,
  required ActionType action,
  int nearThreshold = DEFAULT_NEAR_THRESHOLD,
  int longSeasonThreshold = DEFAULT_LONG_SEASON_THRESHOLD,
  Zone? zone,
  DateTime? lastFrostDate,
}) {
  final month = date.month;
  final months = buildEligibleMonthsForAction(plant, action, zone: zone, lastFrostDate: lastFrostDate);
  if (months.isEmpty) {
    return SeasonInfo(status: SeasonStatus.unknown, distance: 999, eligibleMonths: {});
  }
  if (months.contains(month)) {
    return SeasonInfo(status: SeasonStatus.green, distance: 0, eligibleMonths: months);
  }
  int minForward = 12, minBackward = 12;
  for (final m in months) {
    final f = distanceForward(month, m);
    final b = distanceBackward(month, m);
    if (f < minForward) minForward = f;
    if (b < minBackward) minBackward = b;
  }
  final minDistance = minForward < minBackward ? minForward : minBackward;

  // longest contiguous block length:
  int longestBlock = 0;
  final visited = <int>{};
  for (final start in months) {
    if (visited.contains(start)) continue;
    int length = 0;
    int cur = start;
    while (months.contains(cur)) {
      visited.add(cur);
      length++;
      cur = cur % 12 + 1;
      if (length > 12) break;
    }
    if (length > longestBlock) longestBlock = length;
  }

  final effectiveNear = (longestBlock >= longSeasonThreshold) ? (nearThreshold + 1) : nearThreshold;

  if (minDistance <= effectiveNear) {
    return SeasonInfo(status: SeasonStatus.orange, distance: minDistance, eligibleMonths: months);
  } else {
    return SeasonInfo(status: SeasonStatus.red, distance: minDistance, eligibleMonths: months);
  }
}

Color statusToColor(SeasonStatus s) {
  switch (s) {
    case SeasonStatus.green: return Colors.green.shade700;
    case SeasonStatus.orange: return Colors.orange.shade700;
    case SeasonStatus.red: return Colors.red.shade700;
    case SeasonStatus.unknown: return Colors.grey.shade500;
  }
}
