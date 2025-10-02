import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  const Failure([this.message, this.code]);

  final String? message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// General failures
class ServerFailure extends Failure {
  const ServerFailure([super.message, super.code]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message, super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message, super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message, super.code]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message, super.code]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message, super.code]);
}

