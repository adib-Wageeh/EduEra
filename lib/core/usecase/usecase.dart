import 'package:education_app/core/utils/typedefs.dart';

abstract class UseCaseWithoutParams<T>{

  const UseCaseWithoutParams();

  ResultFuture<T> call();

}

abstract class UseCaseWithParams<T,params>{

  const UseCaseWithParams();

  ResultFuture<T> call(params p);

}

