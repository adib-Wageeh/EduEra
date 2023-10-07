import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/data/dataSource/chat_remote_data_source.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';



void main() {

  late FakeFirebaseFirestore fireStore;
  late MockFirebaseAuth auth;
  late ChatRemoteDataSource chatRemoteDataSource;
  final tGroup = GroupModel.empty();

  setUp(()async {
    fireStore = FakeFirebaseFirestore();

    final user = MockUser(
      email: 'email',
      uid: 'uId',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;

    final credentials = GoogleAuthProvider.
    credential(idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,);
    auth = MockFirebaseAuth(mockUser: user,);
    await auth.signInWithCredential(credentials);
    chatRemoteDataSource = ChatRemoteDataSourceImpl
      (firebaseAuth: auth, firestore: fireStore);


  });
  
  Future<DocumentReference> addMessage(MessageModel message,) async {
    return fireStore
        .collection('groups')
        .doc(message.groupId)
        .collection('messages')
        .add(message.toMap());
  }

  group('get groups', () {
    test('should return stream of Groups', () async{

      // Arrange
      final expectedGroups = [
        GroupModel.empty().copyWith(
          id: '1',
          courseId: '1',
          name: 'Group 1',
        ),
        GroupModel.empty().copyWith(
          id: '2',
          courseId: '2',
          name: 'Group 2',
        ),
      ];

      for(final group in expectedGroups){
        await fireStore.collection('groups').add(group.toMap());
      }

      final result = chatRemoteDataSource.getGroups();

      expect(result, emitsInOrder([expectedGroups]));

    });

  });

  group('get messages', () {
    test('should return stream of messages', () async{

      // Arrange
      final expectedGroups = [
        GroupModel.empty().copyWith(
          id: '1',
          courseId: '1',
          name: 'Group 1',
        ),
        GroupModel.empty().copyWith(
          id: '2',
          courseId: '2',
          name: 'Group 2',
        ),
      ];

      for(final group in expectedGroups){
        await fireStore.collection('groups').add(group.toMap());
      }

      final messages = [
        MessageModel.empty().copyWith(
          id: '1',
          groupId: '1',
          message: 'hello',
          timeStamp: DateTime.now(),
        ),
        MessageModel.empty().copyWith(
          id: '2',
          groupId: '1',
          message: 'world',
          timeStamp: DateTime.now().subtract(const Duration(seconds: 1000),),
        ),
      ];

      for(final message in messages){
        await addMessage(message);
      }


      final result = chatRemoteDataSource.getMessages(messages[0].groupId);

      expect(result, emitsInOrder([messages]));

    });

  });

  group('get user from id', () {
    test('should return userModel from userId', () async{

      // Arrange
      final users = [
        UserModel.empty().copyWith(
          uid: '1',
          fullName: 'name 1',
          email: 'email',
        ),
        UserModel.empty().copyWith(
          uid: '2',
          fullName: 'name 2',
          email: 'email 2',
        ),
      ];

      for(final user in users){
        await fireStore.collection('users').doc(user.uiD).set(user.toMap());
      }

      final result = await chatRemoteDataSource.getUserById(users[0].uiD);

      expect(result.fullName, 'name 1');

    });
  });

  group('join group', () {
    test('should return void when adding user to group successfully',
            () async{

              // Arrange
              final expectedGroups = [
                GroupModel.empty().copyWith(
                  id: '1',
                  courseId: '1',
                  name: 'Group 1',
                  members: [],
                ),
                GroupModel.empty().copyWith(
                  id: '2',
                  courseId: '2',
                  name: 'Group 2',
                  members: [],
                ),
              ];
              final user = UserModel.empty().copyWith(
                uid: auth.currentUser!.uid,
              );
              await fireStore.collection('users').doc(
                  auth.currentUser!.uid,
              ).set(user.toMap());

              for(final group in expectedGroups){
                await fireStore.collection('groups')
                    .doc(group.id).set(group.toMap());
              }

              await chatRemoteDataSource.
              joinGroup(expectedGroups[0].id);


              final groupDoc = await fireStore.collection('groups')
                .doc(expectedGroups[0].id).get();
              final userDoc = await fireStore.collection('users')
                  .doc(user.uiD).get();

          expect(
            (groupDoc.data()!['members'] as List).contains(user.uiD)
            ,true ,);
          expect(
            (userDoc.data()!['joinedGroupsIds'] as List).contains
              (expectedGroups[0].id)
            ,true ,);
        });
  });

  group('leave group', () {
    test('should return void when adding user to group successfully',
            () async{

          // Arrange
          final expectedGroups = [
            GroupModel.empty().copyWith(
              id: '1',
              courseId: '1',
              name: 'Group 1',
              members: [],
            ),
            GroupModel.empty().copyWith(
              id: '2',
              courseId: '2',
              name: 'Group 2',
              members: [],
            ),
          ];
          final user = UserModel.empty().copyWith(
            uid: auth.currentUser!.uid,
          );
          await fireStore.collection('users').doc(
            auth.currentUser!.uid,
          ).set(user.toMap());

          for(final group in expectedGroups){
            await fireStore.collection('groups')
                .doc(group.id).set(group.toMap());
          }

          await chatRemoteDataSource.
          joinGroup(expectedGroups[0].id);

          final groupDocBefore = await fireStore.collection('groups')
              .doc(expectedGroups[0].id).get();
          final userDocBefore = await fireStore.collection('users')
              .doc(user.uiD).get();
          expect(
            (groupDocBefore.data()!['members'] as List).contains(user.uiD)
            ,true ,);
          expect(
            (userDocBefore.data()!['joinedGroupsIds'] as List).contains
              (expectedGroups[0].id)
            ,true ,);
          // act

          await chatRemoteDataSource.
          leaveGroup(expectedGroups[0].id);


          final groupDoc = await fireStore.collection('groups')
              .doc(expectedGroups[0].id).get();
          final userDoc = await fireStore.collection('users')
              .doc(user.uiD).get();

          expect(
            (groupDoc.data()!['members'] as List).contains(user.uiD)
            ,false ,);
          expect(
            (userDoc.data()!['joinedGroupsIds'] as List).contains
              (expectedGroups[0].id)
            ,false ,);
        });
  });

  group('send message', () {
    test('should return void when adding user to group successfully',
            () async{

          // Arrange
          final expectedGroups = [
            GroupModel.empty().copyWith(
              id: '1',
              courseId: '1',
              name: 'Group 1',
              members: [],
            ),
            GroupModel.empty().copyWith(
              id: '2',
              courseId: '2',
              name: 'Group 2',
              members: [],
            ),
          ];

          for(final group in expectedGroups){
            await fireStore.collection('groups')
                .doc(group.id).set(group.toMap());
          }
          final message = MessageModel.empty()
            .copyWith(
            senderId: auth.currentUser!.uid,
            groupId: expectedGroups[0].id,
          );

          final userModel = UserModel.empty().copyWith(
            uid: auth.currentUser!.uid,
          );
          await fireStore.collection('users').doc(
            auth.currentUser!.uid,
          ).set(userModel.toMap());

          // act

          await chatRemoteDataSource.sendMessage(message);


          final groupDoc = await fireStore.collection('groups')
              .doc(expectedGroups[0].id).collection('messages')
              .get();

          final user = await chatRemoteDataSource
              .getUserById(auth.currentUser!.uid);


          expect(groupDoc.docs[0].data()['lastMessage']
            ,message.message ,);
          expect((groupDoc.docs[0].data()['lastMessageTimeStamp'] as Timestamp)
              .toDate()
            ,message.timeStamp ,);
          expect(groupDoc.docs[0].data()['lastMessageSenderName']
            ,user.fullName ,);

        });

  });


}
