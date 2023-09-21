import 'package:equatable/equatable.dart';

class UserChoice extends Equatable{

  const UserChoice({
    required this.userChoice,
    required this.correctChoice,
    required this.questionId,
});

  final String questionId;
  final String correctChoice;
  final String userChoice;

  bool get isCorrect => correctChoice == userChoice;



  @override
  List<Object?> get props => [questionId,userChoice];


}