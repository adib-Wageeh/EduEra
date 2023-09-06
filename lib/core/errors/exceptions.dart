import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception{

  const ServerException({required this.error,required this.code});
  final String error;
  final String code;

  @override
  List<Object?> get props => [error,code];

}

class CacheException extends Equatable implements Exception{

  const CacheException({required this.error,required this.code});
  final String error;
  final int code;

  @override
  List<Object?> get props => [error,code];

}