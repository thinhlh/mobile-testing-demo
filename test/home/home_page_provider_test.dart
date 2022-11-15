import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tfc/app/home/domain/services/home_service.dart';
import 'package:tfc/app/home/views/home_provider.dart';
import 'package:tfc/services/rest_api/models/base_response.dart';

import 'home_page_provider_test.mocks.dart';

// class MockHomeService extends Mock implements HomeService {}

@GenerateMocks([HomeService])
void main() {
  late HomeProvider homeProvider;
  late MockHomeService mockHomeService;

  setUp(() {
    mockHomeService = MockHomeService();
    homeProvider = HomeProvider(mockHomeService);
  });

  test('Should forward the call to home service once', () async {
    when(mockHomeService.checkConnection()).thenAnswer(
      (_) async => BaseResponse.success(
        "Success",
      ),
    );

    final result = await homeProvider.checkConnection();

    verify(mockHomeService.checkConnection()).called(1);
    verifyNever(mockHomeService.checkConnectionFailed());
    verifyNoMoreInteractions(mockHomeService);
  });

  test('Should return success when service calling is success', () async {
    when(mockHomeService.checkConnection()).thenAnswer(
      (_) async => BaseResponse.success(
        "Success",
      ),
    );

    final result = await homeProvider.checkConnection();

    expect(result.success, true);
  });

  test('Should return success when service calling is error', () async {
    when(mockHomeService.checkConnectionFailed()).thenAnswer(
      (_) async => BaseResponse.error(
        "Error",
      ),
    );

    final result = await homeProvider.checkConnectionFailed();

    expect(result.success, false);
  });
}
