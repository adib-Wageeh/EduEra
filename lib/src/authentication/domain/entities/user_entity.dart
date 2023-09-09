import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{

  const UserEntity({required this.email,
     required this.fullName, required this.points, required this.uiD,
    this.enrolledCoursesIds=const[],
   this.followed=const [], this.following= const [],
     this.joinedGroupsIds = const[],
    this.profilePic,this.bio,
  });

  factory UserEntity.empty(){
    return const UserEntity(email: '', fullName: '',
      points: 0, uiD: '',);
  }

  final String uiD;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> joinedGroupsIds;
  final List<String> enrolledCoursesIds;
  final List<String> following;
  final List<String> followed;

  @override
  String toString() {
    return 'UserEntity{uiD: $uiD, email: $email, bio: $bio, points: $points,'
        ' fullName: $fullName}';
  }

  @override
  List<Object?> get props => [uiD,email,
  profilePic,bio,points,fullName,joinedGroupsIds,
    enrolledCoursesIds,following,followed];

}
