import 'package:education_app/core/utils/typedefs.dart';

abstract class OnBoardingRepository{

  const OnBoardingRepository();
  ResultFuture<void> cacheFirstTime();
  ResultFuture<bool> checkIfUserFirstTime();


}