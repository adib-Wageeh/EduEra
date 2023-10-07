import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CourseRemoteDataSource{

  const CourseRemoteDataSource();

  Future<void> addCourse(Course course);

  Future<List<CourseModel>> getCourses();

}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource{

  const CourseRemoteDataSourceImpl({required FirebaseStorage storage,
    required FirebaseFirestore firestore,required FirebaseAuth auth,}):
  _firebaseAuth = auth,_firebaseStorage = storage,_firebaseFirestore = firestore
  ;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;


  @override
  Future<void> addCourse(Course course) async{

    try{
      final user = _firebaseAuth.currentUser;

      if(user == null){
        throw const ServerException
          (code: '401',error: 'user is not authenticated');
      }

      final courseRef = _firebaseFirestore.collection('courses').doc();
      final groupRef = _firebaseFirestore.collection('groups').doc();

      var courseModel = (course as CourseModel).copyWith(id: courseRef.id,
        groupId: groupRef.id,
      );

      if(courseModel.imageAsFile){
        final imageRef = _firebaseStorage.
        ref('courses/${courseModel.id}/profileImage/${courseModel.title}-pfp');
        await imageRef.putFile(File(courseModel.image!)).then((value) async{
          final url = await value.ref.getDownloadURL();
          courseModel = courseModel.copyWith(image: url);
        });
      }

      await courseRef.set(courseModel.toMap());

      final group = GroupModel(courseId: courseRef.id, id: groupRef.id,
        name: courseModel.title,members: const [],
        groupImage: courseModel.image,);

      return groupRef.set(group.toMap());

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
  Future<List<CourseModel>> getCourses() async{

    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const ServerException
          (code: '401', error: 'user is not authenticated');
      }

      final coursesSnapShot = await _firebaseFirestore.collection('courses')
          .get();

      final courses = coursesSnapShot.docs.map((e) {
        return CourseModel.fromMap(e.data());
      }).toList();

      return courses;
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
