import 'package:flutter_test/flutter_test.dart';
import 'package:movement_break/app/app.dart';
import 'package:movement_break/app/providers/app_state.dart';
import 'package:movement_break/app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Movement Break home screen loads', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final storageService = await StorageService.create();
    final appState = AppState(storageService);

    await appState.initialize();

    await tester.pumpWidget(MovementBreakApp(appState: appState));

    expect(find.text('Movement Break'), findsOneWidget);
    expect(find.text("LET'S MOVE!"), findsOneWidget);
    expect(find.text('0 / 4'), findsOneWidget);
  });
}
