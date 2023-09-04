import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';


void main() {

  final tUserModel = UserModel.empty();
  late DataMap map;
  setUp((){
    map = (jsonDecode(fixture('user.json')))as DataMap;

  });
  
  test('should be a subclass of userEntity', () {

    expect(tUserModel, isA<UserEntity>());
  });

  group('from map', () {

    test('should return valid userModel', () {

    // act
      final result = UserModel.fromMap(map);

    // assert
      expect(result, tUserModel);

    });

    test('should throw an error when map is not right', () {

      // assert
      final tMap = map..remove('email');

      // act
      const result = UserModel.fromMap;

      // assert
      expect(()=>result(tMap), throwsA(isA<Error>()) );

    });

  });

  group('to map', () {

    test('should return valid map from userModel', () {

      // act
      final result = tUserModel.toMap();

      // assert
      expect(result, map);

    });


  });

  group('copy with', () {

    test('should return valid userModel with new values', () {
      // act
      final result = tUserModel.copyWith(uid: '2');

      // assert
      expect(result.uiD, '2');

    });


  });

}
