import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/notification/data/datasources/notification_remote_data_source.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {

  late FakeFirebaseFirestore fireStore;
  late MockFirebaseAuth auth;
  late NotificationRemoteDataSource notificationRemoteDataSource;

  Future<DocumentReference> addNotification(
      NotificationModel notification,
      ) async {
    return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notifications')
        .add(notification.toMap());
  }

  setUp(() async{

    fireStore = FakeFirebaseFirestore();

    final user = MockUser(
      email: 'email',
      uid: 'uId',
      displayName: 'displayName',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user,);
    await auth.signInWithCredential(credentials);

    notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
      firestore: fireStore,
      auth: auth,);

  });

  test('add notification successfully', () async{

    // arrange
    final notification = NotificationModel.empty();

    await fireStore.collection('users').doc(auth.currentUser!.uid)
    .set(
      UserModel.empty().copyWith(
        uid: auth.currentUser!.uid,
      ).toMap(),
    );

    // act
    await notificationRemoteDataSource.addNotification(notification);

    // assert
    final notificationsRef = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();

    final notificationModel
    = NotificationModel.fromMap(notificationsRef.docs.first.data());

    expect(notificationModel.title, notification.title);


  });

  test('clear a notification successfully', () async{

    // arrange
    final notification = NotificationModel.empty();

    await fireStore.collection('users').doc(auth.currentUser!.uid)
        .set(
      UserModel.empty().copyWith(
        uid: auth.currentUser!.uid,
      ).toMap(),
    );

    await notificationRemoteDataSource.addNotification(notification);
    final notificationsRef = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();
    expect(notificationsRef.size,1);

    // act
    await notificationRemoteDataSource.clearANotification(
        notificationsRef.docs.first.data()['id'] as String,);

    // assert
    final notificationsRef2 = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();
    expect(notificationsRef2.size,0);

  });

  test('clear all notifications successfully', () async{

    // arrange
    final notification = NotificationModel.empty();
    final notification2 = NotificationModel.empty().copyWith(title: 'title2');

    await fireStore.collection('users').doc(auth.currentUser!.uid)
        .set(
      UserModel.empty().copyWith(
        uid: auth.currentUser!.uid,
      ).toMap(),
    );

    await notificationRemoteDataSource.addNotification(notification);
    await notificationRemoteDataSource.addNotification(notification2);

    final notificationsRef = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();
    expect(notificationsRef.size,2);

    // act
    await notificationRemoteDataSource.clearAll();

    // assert
    final notificationsRef2 = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();
    expect(notificationsRef2.size,0);

  });

  test('mark a notification as read successfully', ()async{

    // arrange
    final notification = NotificationModel.empty();

    await fireStore.collection('users').doc(auth.currentUser!.uid)
        .set(
      UserModel.empty().copyWith(
        uid: auth.currentUser!.uid,
      ).toMap(),
    );
    await notificationRemoteDataSource.addNotification(notification);

    final notificationsRef = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();
    expect(notificationsRef.docs.first.data()['seen'], false);

    // act
    await notificationRemoteDataSource.markAsRead
      (notificationsRef.docs.first.data()['id'] as String);


    // assert

    final notificationsRef2 = await fireStore.collection('users')
        .doc(auth.currentUser!.uid).collection('notifications').get();

    final notificationRef = NotificationModel.fromMap
      (notificationsRef2.docs.first.data());

    expect(notificationRef.seen, true);

  });

  group('get notifications', () {

    test('get notifications stream successfully', ()async{

      // arrange

      await fireStore.collection('users').doc(auth.currentUser!.uid)
          .set(
        UserModel.empty().copyWith(
          uid: auth.currentUser!.uid,
        ).toMap(),
      );

      final expectedNotifications = [
        NotificationModel.empty().copyWith(
            sentAt: DateTime.now()
        ),
        NotificationModel.empty().copyWith(
          id: '1',
          sentAt: DateTime.now().add(
            const Duration(seconds: 50),
          ),
        ),
      ];
      for (final notification in expectedNotifications) {
        await addNotification(notification);
      }


      // act
      final result = notificationRemoteDataSource.getNotifications();

      // assert
      expect(result, emitsInOrder([equals(expectedNotifications.reversed)]));

    });

    test('should return a stream of empty list when an error occurs', () {
      final result = notificationRemoteDataSource.getNotifications();

      expect(result, emits(equals(<NotificationModel>[])));
    });

  });






}
