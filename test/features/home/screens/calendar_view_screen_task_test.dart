import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/activity.dart';
import 'package:permacalendar/core/models/garden.dart';
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/home/screens/calendar_view_screen.dart';

void main() {
  setUpAll(() async {
    // Temp directory for Hive
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    // Register Adapters
    if (!Hive.isAdapterRegistered(16)) Hive.registerAdapter(ActivityAdapter());
    if (!Hive.isAdapterRegistered(17))
      Hive.registerAdapter(ActivityTypeAdapter());
    // Also needed for GardenBoxes initialization even if empty
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(GardenAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GardenBedAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(PlantingAdapter());
  });

  setUp(() async {
    // Open Boxes via GardenBoxes to ensure static fields are set
    await GardenBoxes.initialize();
  });

  tearDown(() async {
    await GardenBoxes.close();
    // Clean up boxes
    await Hive.deleteBoxFromDisk('activities');
    await Hive.deleteBoxFromDisk('gardens');
    await Hive.deleteBoxFromDisk('garden_beds');
    await Hive.deleteBoxFromDisk('plantings');
    await Hive.deleteBoxFromDisk('harvests');
    await Hive.deleteBoxFromDisk('plants'); // opened in initialize
  });

  testWidgets('CalendarViewScreen displays tasks and allows creation',
      (tester) async {
    // 1. Setup existing task
    final task = Activity.customTask(
      title: 'Existing Task',
      description: 'Test Description',
      taskKind: 'repair',
      nextRunDate: DateTime.now(),
    );
    await GardenBoxes.activities.put(task.id, task);

    // 2. Pump Widget
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CalendarViewScreen(),
        ),
      ),
    );

    // Allow FutureBuilder/AsyncValue to load
    await tester.pumpAndSettle();

    // 3. Verify 'Existing Task' presence implies loading worked
    // UI displays "Tâches planifiées" in details if selected.
    // By default today is selected in logic ???
    // Assuming today includes "Existing Task" (DateTime.now)

    // But initially no date might be selected? logic: `_selectedMonth = DateTime.now()`. `_selectedDate` is null initially.
    // Wait, CalendarViewScreen `initState` does NOT set `_selectedDate`.
    // We need to tap a day.

    // Tap the current day (highlighted or just finding text with today's number)
    final today = DateTime.now().day.toString();

    // Find text 'today' in the grid (might be multiple if previous/next month show days?)
    // Our grid only shows current month. So finding text "$day" should work.
    // Note: The day cell has text.
    await tester.tap(find.text(today).first);
    await tester.pumpAndSettle();

    // Now details should show the task
    expect(find.text('Existing Task'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);

    // 4. Open Add Task Dialog
    await tester.tap(find.byIcon(Icons.add_task));
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle Tâche'), findsOneWidget);

    // 5. Fill Form
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Titre *'), 'New Created Task');

    // Scroll down to find button if needed (SingleChildScrollView)
    await tester.drag(find.text('Nouvelle Tâche'), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Select Type (optional, default is generic)
    // Select Recurrence (optional)

    // Click Create
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle(); // Create Dialog closes, but Ask Export Dialog opens

    // 5b. Handle "Ask to Export" dialog
    expect(find.text('Tâche enregistrée'), findsOneWidget);
    await tester.tap(find.text('Non'));
    await tester.pumpAndSettle(); // Close alert dialog

    // 6. Verify New Task in Hive
    expect(GardenBoxes.activities.values.length, 2);
    final created = GardenBoxes.activities.values.last as Activity;
    expect(created.title, 'New Created Task');
    expect(created.metadata['isCustomTask'], true);

    // Verify it appears in list (reload happened)
    // Tap day again to refresh details? _loadCalendarData called inside implies refresh.
    // Widget `_buildDayDetails` uses `_activities` which is updated.
    await tester.tap(
        find.text(today).first); // Re-select to be sure or just check content
    await tester.pumpAndSettle();

    expect(find.text('New Created Task'), findsOneWidget);
  });
}
