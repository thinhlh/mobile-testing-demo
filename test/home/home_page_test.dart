import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tfc/app/app.dart';
import 'package:tfc/app/common/presentation/widgets/dialog/dialog_type.dart';
import 'package:tfc/app/common/presentation/widgets/dialog/w_error_dialog.dart';
import 'package:tfc/app/home/domain/services/home_service.dart';
import 'package:tfc/app/home/views/home_page.dart';
import 'package:tfc/app/home/views/home_provider.dart';
import 'package:tfc/app_runner.dart';
import 'package:tfc/config/app_sizes.dart';
import 'package:tfc/config/global_providers.dart';
import 'package:tfc/generated/locale_keys.g.dart';
import 'package:tfc/services/dialogs/app_loading.dart';
import 'package:tfc/services/rest_api/models/base_response.dart';

import 'home_page_provider_test.mocks.dart';
import 'home_page_test.mocks.dart';

@GenerateMocks([HomeProvider])
void main() {
  late HomeProvider homeProvider;
  late HomeService homeService;
  late Widget testableWidget;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    homeService = MockHomeService();
    homeProvider = HomeProvider(homeService);
    testableWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: homeProvider),
          ...GlobalProviders.providers,
        ],
        builder: (context, child) {
          ScreenUtil.init(context, designSize: AppSizes.designSize);
          return const MaterialApp(
            home: Scaffold(
              body: const HomePage(),
            ),
          );
        },
      ),
    );
  });

  group('Show correct initialize UI', () {
    testWidgets('Should show correct title when initialize', (tester) async {
      await tester.pumpWidget(testableWidget);

      final titleFinder = find.text(LocaleKeys.general);

      expect(titleFinder, findsNWidgets(2));
    });

    testWidgets('Should show login success button', (tester) async {
      await tester.pumpWidget(testableWidget);

      final loginSuccessFinder = find.widgetWithText(
        ElevatedButton,
        LocaleKeys.home_call_api_success,
      );

      expect(loginSuccessFinder, findsOneWidget);
    });

    testWidgets('Should show login error button', (tester) async {
      await tester.pumpWidget(testableWidget);

      final loginErrorFinder = find.widgetWithText(
        ElevatedButton,
        LocaleKeys.home_call_api_error,
      );

      expect(loginErrorFinder, findsOneWidget);
    });

    testWidgets('Should show change locale button', (tester) async {
      await tester.pumpWidget(testableWidget);

      final changeLocaleFinder = find.widgetWithText(
        ElevatedButton,
        LocaleKeys.home_change_locale,
      );

      expect(changeLocaleFinder, findsOneWidget);
    });

    testWidgets('Should show crash app button', (tester) async {
      await tester.pumpWidget(testableWidget);

      final crashAppFinder = find.widgetWithText(
        ElevatedButton,
        LocaleKeys.home_crash_app,
      );

      expect(crashAppFinder, findsOneWidget);
    });
  });

  testWidgets('Should show correct response when tap on login success',
      (tester) async {
    // Arrange
    when(homeService.checkConnection()).thenAnswer(
      (realInvocation) async => BaseResponse.success("Success"),
    );

    await tester.pumpWidget(testableWidget);

    expect(find.text(LocaleKeys.general), findsOneWidget);

    // Act

    await tester.tap(
      find.widgetWithText(
        ElevatedButton,
        LocaleKeys.home_call_api_success,
      ),
    );

    await tester.pump();

    // Assert

    verify(homeService.checkConnection()).called(1);
    verifyNoMoreInteractions(homeService);
    expect(find.text("Success"), findsOneWidget);
  });

  testWidgets('Should show error when tap on login error', (tester) async {
    // Arrange
    when(homeService.checkConnectionFailed()).thenAnswer(
      (realInvocation) async => BaseResponse.error('Error'),
    );

    await tester.pumpWidget(testableWidget);

    expect(find.text(LocaleKeys.general), findsOneWidget);

    await tester.tap(
      find.widgetWithText(
        ElevatedButton,
        LocaleKeys.home_call_api_error,
      ),
    );

    await tester.pump();

    verifyNever(homeService.checkConnection());
    verify(homeService.checkConnectionFailed()).called(1);
    verifyNoMoreInteractions(homeService);
    expect(find.text("Error"), findsNWidgets(2)); // On Screen and error text
  });
}
