import 'package:education_app/core/common/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/dataSource/exam_remote_Data_source.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_question_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/user_choice_model.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/user_exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';



void main() {

  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late ExamRemoteDataSource examRemoteDataSource;

  setUp(() async{

    firestore = FakeFirebaseFirestore();

    final user =MockUser(
      displayName: 'display_name',
      uid: 'uid',
      email: 'email',
    );

    final googleSignIn = MockGoogleSignIn();
    final signIn = await googleSignIn.signIn();
    final authentication = await signIn!.authentication;
    final googleCredentials = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user,);
    await auth.signInWithCredential(googleCredentials);

    examRemoteDataSource = ExamRemoteDataSourceImpl(
      firestore: firestore,
      firebaseAuth: auth,
    );

  });


  group('upload exam', () {

    test('should upload exam successfully', () async{

      // arrange
      final exam = ExamModel.empty().copyWith(
        questions: [ExamQuestionModel.empty()],
      );

      await firestore.collection('courses').doc(exam.courseId)
        .set(
        CourseModel.empty().copyWith(
          id: exam.courseId,
        ).toMap(),
      );

      // act
      await examRemoteDataSource.uploadExam(exam);

      // assert
      final examRef = await firestore.collection('courses')
        .doc(exam.courseId).collection('exams').get();

      expect(examRef.docs, isNotEmpty);

      final examModel = ExamModel.fromMap(examRef.docs.first.data());

      expect(examModel.courseId,exam.courseId);

      final questionRef = await firestore.collection('courses')
          .doc(exam.courseId)
      .collection('exams').doc(examModel.id).collection('questions').get();

      expect(questionRef.docs, isNotEmpty);
      final question = ExamQuestionModel.fromMap(questionRef.docs.first.data());

      expect(question.courseId,examModel.courseId);
      expect(question.examId,examModel.id);

      final courseRef = await firestore.collection('courses')
          .doc(exam.courseId).get();

      expect(courseRef.data()!['numberOfExams'], 1);

    });


  });

  group('get exam questions', () {

    test('get exam questions successfully', () async{

      // arrange
      final exam = ExamModel.empty().copyWith(
        questions: [ExamQuestionModel.empty()],
      );

      await firestore.collection('courses').doc(exam.courseId)
          .set(
        CourseModel.empty().copyWith(
          id: exam.courseId,
        ).toMap(),
      );

      await examRemoteDataSource.uploadExam(exam);

      final examRef = await firestore.collection('courses')
      .doc(exam.courseId).collection('exams').get();

      // act

      final result = await examRemoteDataSource.getExamQuestions(
        ExamModel.fromMap(examRef.docs.first.data()),);

      // assert

      expect(result[0].courseId, exam.courseId);

    });

  });

  group('get exams', () {

    test('get exams successfully', () async{

      // arrange
      final exam = ExamModel.empty().copyWith(
        questions: [ExamQuestionModel.empty()],
      );
      await firestore.collection('courses').doc(exam.courseId)
          .set(
        CourseModel.empty().copyWith(
          id: exam.courseId,
        ).toMap(),
      );
      // act
      await examRemoteDataSource.uploadExam(exam);
      final result = await examRemoteDataSource.getExams(exam.courseId);

      // assert
      expect(result.length, 1);
      expect(result[0].courseId, exam.courseId);

    });

  });

  group('update exam', () {

    test('should update exam successfully', () async{

      // arrange
      final exam = ExamModel.empty().copyWith(
        questions: [ExamQuestionModel.empty()],
      );

      await firestore.collection('courses').doc(exam.courseId)
          .set(
        CourseModel.empty().copyWith(
          id: exam.courseId,
        ).toMap(),
      );
      await examRemoteDataSource.uploadExam(exam);

      final examRef = await firestore.collection('courses').doc(exam.courseId)
          .collection('exams').get();


      final examModel = ExamModel.fromMap(examRef.docs.first.data());

      // act
      await examRemoteDataSource.updateExam(examModel.copyWith(
        title: 'exam iii',
      ),);

      // assert
      final examsCollection = await firestore.collection('courses')
          .doc(exam.courseId).collection('exams').get();
      final examModelRes = ExamModel.fromMap(examsCollection.docs.first.data());

      expect(examModelRes.title, 'exam iii');

    });

  });

  group('submit exam', () {

    test('should submit the given exam', () async{

      // arrange
      final userExam = UserExamModel.empty().copyWith(
        totalQuestions: 2,
        answers: [const UserChoiceModel.empty()],
      );
      await firestore.collection('users').doc(auth.currentUser!.uid)
        .set(
        UserModel.empty().copyWith(
          uid: auth.currentUser!.uid,
          points: 1,
        ).toMap(),
      );

      // act
      await examRemoteDataSource.submitExam(userExam);

      // assert
      final submittedExam = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('courses')
          .doc(userExam.courseId)
          .collection('exams')
          .get();

      expect(submittedExam.docs.first.data(), isNotEmpty);
      final submittedExamModel = UserExamModel.fromMap
        (submittedExam.docs.first.data());
      expect(submittedExamModel.courseId, userExam.courseId);

      final userDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      expect(userDoc.data(), isNotEmpty);
      final userModel = UserModel.fromMap(userDoc.data()!);
      expect(userModel.points, 51);

      expect(userModel.enrolledCoursesIds,
          contains(userExam.courseId),);

    });


  });

  group('get user course exam', () { 
    
    test('should return exams in a specific course given a courseId', ()async{

      // arrange
      final userExam = UserExamModel.empty().copyWith(
        totalQuestions: 2,
        answers: [const UserChoiceModel.empty()],
      );
      await firestore.collection('users').doc(auth.currentUser!.uid)
          .set(
        UserModel.empty().copyWith(
          uid: auth.currentUser!.uid,
          points: 1,
        ).toMap(),
      );
      await examRemoteDataSource.submitExam(userExam);

      // act

      final result = await examRemoteDataSource.
      getUserCourseExam(userExam.courseId);


      // assert

      expect(result.length, 1);
      expect(result.first.courseId, userExam.courseId);



    });
    
  });

  group('get user exams', () { 
    
    test('should return exams from all courses the user is enrolledIn', ()async{
      
      // arrange
      await firestore.collection('users').doc(auth.currentUser!.uid)
          .set(
        UserModel.empty().copyWith(
          uid: auth.currentUser!.uid,
        ).toMap(),
      );
      final userExam1 = UserExamModel.empty().copyWith(
        courseId: 'course 1',
      );
      final userExam2 = UserExamModel.empty().copyWith(
        courseId: 'course 2',
      );

      await examRemoteDataSource.submitExam(userExam1);
      await examRemoteDataSource.submitExam(userExam2);

      // act
      final result = await examRemoteDataSource.getUserExams();
      
      // assert
      expect(result, isA<List<UserExam>>());
      expect(result.length, 2);


    });
    
  });

}
