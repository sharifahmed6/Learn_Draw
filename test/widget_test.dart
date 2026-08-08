import 'package:flutter_test/flutter_test.dart';
import 'package:text_drawing/app.dart';
import 'package:text_drawing/injection_container.dart' as di;

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Initialize dependencies if needed for test
    await di.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the app builds without crashing.
    expect(find.byType(App), findsOneWidget);
  });
}
