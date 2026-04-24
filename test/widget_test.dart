import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pulse_news/main.dart';
import 'package:pulse_news/theme/app_settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches without crashing', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = await AppSettingsController.load();

    await tester.pumpWidget(
      ProviderScope(
        child: PulseNewsApp(
          settings: settings,
          home: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PulseNewsApp), findsOneWidget);
    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(Directionality), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
