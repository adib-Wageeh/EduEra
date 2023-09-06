import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

abstract class AuthRemoteDataSource{

  Future<void> forgetPassword(String email);
  Future<UserModel> signIn(String email,String password);
  Future<void> signUp(String email,String password,String fullName);
  Future<void> updateUser(UpdateUserAction action,
      dynamic userData,);


}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{

  AuthRemoteDataSourceImpl({required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
    required FirebaseAuth firebaseAuth,}):
  _firebaseAuth = firebaseAuth,_firebaseFirestore = firebaseFirestore,
  _firebaseStorage = firebaseStorage
  ;

  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<void> forgetPassword(String email) async{
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }on FirebaseAuthException catch(e){
      throw ServerException(error: e.message??'error unknown',
      code: e.code,);
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      throw ServerException(error: e.toString(),
        code: '505',);
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async{

    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,);
      final user = result.user;

      if (user == null) {
        throw const ServerException(error: 'please try again later',
          code: 'unknown error',);
      }
      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return UserModel.fromMap(userData.data()!);
      }
      await _setUserData(user, email);
      userData = await _getUserData(user.uid);

      return UserModel.fromMap(userData.data()!);
    }on FirebaseAuthException catch(e){
      throw ServerException(error: e.message??'error unknown',
        code: e.code,);
    }on ServerException{
      rethrow;
    }catch (e,s){
      debugPrintStack(stackTrace: s);
      throw ServerException(error: e.toString(),
        code: '505',);
    }


  }

  @override
  Future<void> signUp(String email, String password, String fullName) async{

    try{
    final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password,);

    await userCred.user?.updateDisplayName(fullName);
    await userCred.user?.updatePhotoURL(kDefaultAvatar);
    await _setUserData(userCred.user!, email);

    }on FirebaseAuthException catch(e){
  throw ServerException(error: e.message??'error unknown',
  code: e.code,);
  }on ServerException{
  rethrow;
  }catch (e,s){
  debugPrintStack(stackTrace: s);
  throw ServerException(error: e.toString(),
  code: '505',);
  }
  }

  @override
  Future<void> updateUser(UpdateUserAction action,dynamic userData) async{

    try {
      switch (action) {
        case UpdateUserAction.displayName:
          await _firebaseAuth.currentUser!.updateDisplayName(
              userData as String,);
          await _updateUserData({'fullName': userData});
        case UpdateUserAction.email:
          await _firebaseAuth.currentUser!.updateEmail(userData as String);
          await _updateUserData({'email': userData});

        case UpdateUserAction.password:
          final newPass = jsonDecode(userData as String) as DataMap;
          if (_firebaseAuth.currentUser?.email == null) {
            throw const ServerException(error: "user doesn't exist",
              code: 'insufficient permission',);
          }
          await _firebaseAuth.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _firebaseAuth.currentUser!.email!
              , password: newPass['oldPassword'] as String,),
          );
          await _firebaseAuth.currentUser!.
          updatePassword(newPass['newPassword'] as String);

        case UpdateUserAction.profilePic:
          final ref = _firebaseStorage.ref()
              .child('profile_pics/${_firebaseAuth.currentUser!.uid}');
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _firebaseAuth.currentUser!.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});

        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData});
      }
    } on FirebaseException catch(e){
      throw ServerException(error: e.message??'error unknown',
        code: e.code,);
    }on ServerException{
      rethrow;
    }catch (e,s){
      debugPrintStack(stackTrace: s);
      throw ServerException(error: e.toString(),
        code: '505',);
    }

  }
  
  Future<DocumentSnapshot<DataMap>> _getUserData(String uId)async{
    return _firebaseFirestore.collection('users').doc(uId).get();
  }

  Future<void> _setUserData(User user,String fallbackEmail)async{
    await _firebaseFirestore.collection('users').doc(user.uid).set(
      UserModel(email: user.email??fallbackEmail,
          fullName: user.displayName??'',
          points: 0, uiD: user.uid,
      profilePic: user.photoURL??'',).toMap()
    ,);

  }

  Future<void> _updateUserData(DataMap map)async{
    await _firebaseFirestore.collection('users')
        .doc(_firebaseAuth.currentUser!.uid).update(map);
  }

}
