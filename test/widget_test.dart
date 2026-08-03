import 'package:flutter_test/flutter_test.dart';
import 'package:movement_break/main.dart';

void main() {
  testWidgets('Movement Break app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MovementBreakApp());

    expect(find.text('Movement Break'), findsWidgets);
  });
}
