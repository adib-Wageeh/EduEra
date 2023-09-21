import 'package:equatable/equatable.dart';

class QuestionChoice extends Equatable{

  const QuestionChoice({
    required this.choiceAnswer,
    required this.identifier,
    required this.questionId,
});

  factory QuestionChoice.empty(){
    return const QuestionChoice(
      questionId: 'Test String',
      identifier: 'Test String',
      choiceAnswer: 'Test String',);
  }

  final String questionId;
  final String identifier;
  final String choiceAnswer;


  @override
  List<Object?> get props => [questionId];


}