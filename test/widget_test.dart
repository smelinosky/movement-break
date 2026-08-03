import 'package:flutter_test/flutter_test.dart';
import 'package:movement_break/app/app.dart';

void main() {
  testWidgets('Movement Break home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MovementBreakApp());

    expect(find.text('Movement Break'), findsOneWidget);
    expect(find.text("LET'S MOVE!"), findsOneWidget);
    expect(find.text('Next Reminder'), findsOneWidget);
    expect(find.text('3 / 8'), findsOneWidget);
  });
}
