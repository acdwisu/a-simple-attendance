import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure({String? message}) : super(message ?? 'Server Failure');
}

class ConnectionFailure extends Failure {
  ConnectionFailure() : super('Connection Failure');
}

class DatabaseFailure extends Failure {
  DatabaseFailure({String? message}) : super(message ?? 'Database Failure');
}

class CommonFailure extends Failure {
  CommonFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure({String? message}) : super(message ?? 'Cache Failure');
}
