import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/src/on_boarding/data/datasorces/onboarding_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOnBoardingLocalDatasource extends Mock implements SharedPreferences{}

void main() {

  late SharedPreferences sharedPreferences;
  late OnBoardingLocalDataSource onBoardingLocalDataSource;

  setUp(() {

    sharedPreferences = MockOnBoardingLocalDatasource();
    onBoardingLocalDataSource = OnBoardingLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,);
  });

  group('cache first time', () {

    test('successfully cache for the first time', () async{

      when(()=> sharedPreferences.setBool(any(),any())).
      thenAnswer((_)async=> true);

      await onBoardingLocalDataSource.cacheFirstTime();

      verify(()=> sharedPreferences.setBool(sharedPrefsKey,false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('should throw a cache exception', () async{

      when(()=> sharedPreferences.setBool(any(),any())).
      thenThrow(Exception());

      final call = onBoardingLocalDataSource.cacheFirstTime;

      expect(call, throwsA(isA<CacheException>()),);

      verify(()=> sharedPreferences.setBool(sharedPrefsKey,false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

  });

  group('check If User FirstTime', () {

    test('successfully check If User FirstTime and return a bool value',
            () async{

      when(()=> sharedPreferences.getBool(any())).
      thenReturn(false);

      final result = await onBoardingLocalDataSource.checkIfUserFirstTime();

      expect(result, false);
      verify(()=> sharedPreferences.getBool(sharedPrefsKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('should return true if the dependence returns null',
            () async{

          when(()=> sharedPreferences.getBool(any())).
          thenReturn(null);

          final result = await onBoardingLocalDataSource.checkIfUserFirstTime();

          expect(result, true);
          verify(()=> sharedPreferences.getBool(sharedPrefsKey)).called(1);
          verifyNoMoreInteractions(sharedPreferences);
        });

    test('should throw a cache exception', () async{

      when(()=> sharedPreferences.getBool(any())).
      thenThrow(Exception());

      final call = onBoardingLocalDataSource.checkIfUserFirstTime;

      expect(call, throwsA(isA<CacheException>()),);

      verify(()=> sharedPreferences.getBool(sharedPrefsKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

  });

}
