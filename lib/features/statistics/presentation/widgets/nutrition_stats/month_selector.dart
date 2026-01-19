import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

class MonthSelector extends StatelessWidget {
  final int selectedMonth;
  final Function(int) onMonthSelected;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    // 2024 is a leap year. Using it to generate months
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final monthIndex = index + 1;
          final isSelected = monthIndex == selectedMonth;
          
          String monthName;
          try {
            // Using MMM for short name (Jan, Feb, etc.)
            monthName = DateFormat.MMM(l10n.localeName).format(DateTime(2024, monthIndex)).replaceAll('.', '');
          } catch (_) {
             final months = ['Jan','Fév','Mar','Avr','Mai','Juin','Juil','Août','Sep','Oct','Nov','Déc'];
             monthName = months[index];
          }

          return GestureDetector(
            onTap: () => onMonthSelected(monthIndex),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00E676)
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white12,
                ),
              ),
              child: Text(
                monthName,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
