import 'package:education_app/core/utils/typedefs.dart';

abstract class FutureUseCaseWithoutParams<T>{

  const FutureUseCaseWithoutParams();

  ResultFuture<T> call();

}

abstract class FutureUseCaseWithParams<T,params>{

  const FutureUseCaseWithParams();

  ResultFuture<T> call(params p);

}

abstract class StreamUseCaseWithoutParams<T>{

  const StreamUseCaseWithoutParams();

  ResultStream<T> call();

}


abstract class StreamUseCaseWithParams<T,params>{

  const StreamUseCaseWithParams();

  ResultStream<T> call(params p);

}
