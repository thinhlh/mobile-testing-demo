import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tfc/app/home/views/home_page.dart';
import 'package:tfc/app_runner.dart';
import 'package:tfc/generated/locale_keys.g.dart';

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  group('Home functions', () {
    testWidgets('should show Hello text when tap on login success',
        (tester) async {
      await AppRunner.instance.runApplication();
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);

      expect(find.byKey(const ValueKey(LocaleKeys.general)), findsOneWidget);

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          LocaleKeys.home_call_api_success.tr(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("Hello"), findsOneWidget);
    });
  });
}
