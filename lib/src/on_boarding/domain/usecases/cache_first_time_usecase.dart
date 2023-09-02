import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';

class CacheFirstTimeUseCase extends UseCaseWithoutParams<void>{

  CacheFirstTimeUseCase({required this.onBoardingRepository});
  OnBoardingRepository onBoardingRepository;

  @override
  ResultFuture<void> call() => onBoardingRepository.cacheFirstTime();

}