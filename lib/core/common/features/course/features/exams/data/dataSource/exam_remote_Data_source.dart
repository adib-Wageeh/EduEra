import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_question_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/question_choices_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/user_exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ExamRemoteDataSource{

  Future<List<ExamQuestion>> getExamQuestions(Exam exam);

  Future<List<Exam>> getExams(String courseId);

  Future<List<UserExam>> getUserCourseExam(String courseId);

  Future<List<UserExam>> getUserExams();

  Future<void> submitExam(UserExam exam);

  Future<void> updateExam(Exam exam);

  Future<void> uploadExam(Exam exam);

}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource{

  const ExamRemoteDataSourceImpl({
   required FirebaseFirestore firestore,
   required FirebaseAuth firebaseAuth,
}):
  _firestore = firestore,
  _auth = firebaseAuth
  ;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<List<ExamQuestion>> getExamQuestions(Exam exam) async{

    try{

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }

      final questionsQuerySnapshot = await _firestore.collection('courses')
          .doc(exam.courseId).collection('exams')
          .doc(exam.id).collection('questions').get();

      return questionsQuerySnapshot.docs.map((e) {
        return ExamQuestionModel.fromMap(e.data());
      }).toList();


    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }


  }

  @override
  Future<List<Exam>> getExams(String courseId) async{

      try{

        if(_auth.currentUser == null){
          throw  const ServerException(
            error: 'unAuthenticated user',
            code: '404',
          );
        }

        final examsQuerySnapShot = await _firestore.collection('courses')
        .doc(courseId).collection('exams').get();

        return examsQuerySnapShot.docs.map((e) {
          return ExamModel.fromMap(e.data());
        }).toList();

      }on FirebaseException catch(e){
        throw ServerException
          (code: e.code,error: e.message??'unknown error occurred');
      } on ServerException{
        rethrow;
      }catch(e){
        throw ServerException
          (code: '505',error: e.toString());
      }


  }

  @override
  Future<List<UserExam>> getUserCourseExam(String courseId) async{

    try{

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }

      final examsSnapShot = await _firestore.collection('users')
      .doc(_auth.currentUser!.uid).collection('courses')
          .doc(courseId).collection('exams').get();


      return examsSnapShot.docs.map((e) {
        return UserExamModel.fromMap(e.data());
      }).toList();

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }

  @override
  Future<List<UserExam>> getUserExams()async{

    try{

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }

      final coursesCollection = await _firestore.collection('users')
          .doc(_auth.currentUser!.uid).collection('courses').get();

      final exams = <UserExam>[];

      for(final course in coursesCollection.docs){

        final courseExams = await getUserCourseExam
          (course.data()['courseId'] as String);
        exams.addAll(courseExams);
      }
      return exams;

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }


  }

  @override
  Future<void> submitExam(UserExam exam) async{

    try{

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }

      await _firestore.collection('users')
      .doc(_auth.currentUser!.uid).collection('courses')
      .doc(exam.courseId).set({
        'courseId':exam.courseId,
      });

      await _firestore.collection('users')
          .doc(_auth.currentUser!.uid).collection('courses')
          .doc(exam.courseId).collection('exams')
          .add((exam as UserExamModel).toMap());

      final totalPoints = exam.examAnswers.where
        ((element) => element.isCorrect).length;

      final percent = (totalPoints/exam.totalQuestions)*100;

      await _firestore.collection('users')
          .doc(_auth.currentUser!.uid).update({
        'points':FieldValue.increment(percent),
      });

      final userRef = await _firestore.collection('users')
          .doc(_auth.currentUser!.uid).get();

      var count =0;
       count = (userRef.data()!['enrolledCoursesIds'] as List)
          .where((element) => element == exam.courseId).length;

      if(count == 0){
        await _firestore.collection('users').doc(_auth.currentUser!.uid)
        .update(
          {
            'enrolledCoursesIds': FieldValue.arrayUnion([exam.courseId]),
          }
        );
      }

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }


  }

  @override
  Future<void> updateExam(Exam exam) async{

    try{

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }
      await _firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .doc(exam.id)
          .update((exam as ExamModel).toMap());

      // update questions
      final questions = exam.examQuestions;

      if (questions != null && questions.isNotEmpty) {
        final batch = _firestore.batch();
        for (final question in questions) {
          final questionDocRef = _firestore
              .collection('courses')
              .doc(exam.courseId)
              .collection('exams')
              .doc(exam.id)
              .collection('questions')
              .doc(question.id);
          final questionModel = (question as ExamQuestionModel).toMap();
          batch.update(questionDocRef, questionModel);
        }
        await batch.commit();

      }

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }


  }

  @override
  Future<void> uploadExam(Exam exam) async{

    try {

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }
      final examRef = _firestore.collection('courses').doc(exam.courseId)
          .collection('exams').doc();

      final examToUpload = (exam as ExamModel).copyWith(id: examRef.id);
      await examRef.set(examToUpload.toMap());

      final questions = exam.examQuestions;

      if( questions != null && questions.isNotEmpty){

        final batch = _firestore.batch();
        for(final question in questions){

          final questionRefDoc = examRef.collection('questions').doc();
           var questionModel = (question as ExamQuestionModel).copyWith(
            id: questionRefDoc.id,
            examId: examRef.id,
            courseId: exam.courseId,
          );

          final choices = <QuestionChoiceModel>[];

          for(final choice in question.choices){

            (choice as QuestionChoiceModel).copyWith(
              questionId: questionRefDoc.id,
            );
            choices.add(choice);
          }
          questionModel = questionModel.copyWith(
            choices: choices,
          );
          batch.set(questionRefDoc, questionModel.toMap());
        }
        await batch.commit();
      }
      await _firestore.collection('courses')
          .doc(exam.courseId).update({
        'numberOfExams': FieldValue.increment(1),
      });

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }
  
  
}
