import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSource{

  const OnBoardingLocalDataSource();

  Future<void> cacheFirstTime();
  Future<bool> checkIfUserFirstTime();

}
class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource{

  OnBoardingLocalDataSourceImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheFirstTime() async{
    try {
      await sharedPreferences.setBool(sharedPrefsKey, false);
    }on Exception catch(e){
      throw CacheException(error: e.toString(),code: 400);
    }

  }

  @override
  Future<bool> checkIfUserFirstTime()async{
    try{
      final result = sharedPreferences.getBool(sharedPrefsKey);
      if(result != null){
        return result;
      }else{
        return true;
      }
    }on Exception catch(e){
      throw CacheException(error: e.toString(),code: 400);
    }
  }


}
