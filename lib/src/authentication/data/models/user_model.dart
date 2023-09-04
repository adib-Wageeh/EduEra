import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity{

  const UserModel({required super.email,
    required super.fullName, required super.points,
    required super.uiD, super.enrolledCoursesIds,
    super.followed, super.following,
    super.joinedGroupsIds,
    super.profilePic,super.bio,
  });

  factory UserModel.empty()=> const UserModel(email: '', fullName: '', points: 0
      , uiD: '',);

  factory UserModel.fromMap(DataMap map){
    return UserModel(email: map['email']as String,
        fullName: map['fullName'] as String,
        points: (map['points'] as num).toInt(),
        uiD: map['uId'] as String,
    bio: map['bio'] as String?,
      enrolledCoursesIds: (map['enrolledCoursesIds'] as List<dynamic>)
          .cast<String>(),
      followed: (map['followed'] as List<dynamic>)
          .cast<String>(),
      following: (map['following'] as List<dynamic>)
          .cast<String>(),
      joinedGroupsIds: (map['joinedGroupsIds'] as List<dynamic>)
          .cast<String>(),
      profilePic: map['profilePic'] as String?,
    );
  }

  DataMap toMap(){
    return {
      'email':email,
      'fullName':fullName,
      'points':points,
      'uId':uiD,
      'bio':bio,
      'enrolledCoursesIds':enrolledCoursesIds,
      'followed':followed,
      'following':following,
      'joinedGroupsIds':joinedGroupsIds,
      'profilePic':profilePic,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserModel(
      uiD: uid ?? uiD,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      joinedGroupsIds: groupIds ?? joinedGroupsIds,
      enrolledCoursesIds: enrolledCourseIds ?? enrolledCoursesIds,
      following: following ?? this.following,
      followed: followers ?? followed,
    );
  }

}
