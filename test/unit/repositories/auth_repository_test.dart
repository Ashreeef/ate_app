import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ate_app/repositories/auth_repository.dart';
import 'package:ate_app/services/firebase_auth_service.dart';
import 'package:ate_app/services/firestore_service.dart';
import 'package:ate_app/models/user.dart';
import '../../mocks/mock_data.dart';

@GenerateMocks([
  FirebaseAuthService,
  FirestoreService,
  firebase_auth.User,
  firebase_auth.UserCredential,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
import 'auth_repository_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuthService mockAuthService;
  late MockFirestoreService mockFirestoreService;
  late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
  late MockDocumentReference<Map<String, dynamic>> mockUserDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;

  setUp(() {
    mockAuthService = MockFirebaseAuthService();
    mockFirestoreService = MockFirestoreService();
    mockUsersCollection = MockCollectionReference();
    mockUserDoc = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();

    // Setup firestore service
    when(mockFirestoreService.users).thenReturn(mockUsersCollection);

    authRepository = AuthRepository(
      firebaseAuthService: mockAuthService,
      firestoreService: mockFirestoreService,
    );
  });

  group('AuthRepository', () {
    group('Authentication Status', () {
      test('should return currentUserId from auth service', () {
        when(mockAuthService.currentUserId).thenReturn('test-uid');

        expect(authRepository.currentUserId, 'test-uid');
      });

      test('should return null currentUserId when not authenticated', () {
        when(mockAuthService.currentUserId).thenReturn(null);

        expect(authRepository.currentUserId, isNull);
      });

      test('should return isAuthenticated true when user exists', () {
        final mockFirebaseUser = MockUser();
        when(mockAuthService.currentUser).thenReturn(mockFirebaseUser);

        expect(authRepository.isAuthenticated, true);
      });

      test('should return isAuthenticated false when no user', () {
        when(mockAuthService.currentUser).thenReturn(null);

        expect(authRepository.isAuthenticated, false);
      });
    });

    group('signUp', () {
      test('should create user and save to Firestore', () async {
        // Arrange
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(mockFirebaseUser.uid).thenReturn('new-user-uid');
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(
          mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUsersCollection.doc('new-user-uid')).thenReturn(mockUserDoc);
        when(mockUserDoc.set(any, any)).thenAnswer((_) async {});

        // Act
        final user = await authRepository.signUp(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
          displayName: 'Test User',
        );

        // Assert
        expect(user.uid, 'new-user-uid');
        expect(user.username, 'testuser');
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'Test User');

        verify(
          mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
        verify(mockUserDoc.set(any, any)).called(1);
      });

      test('should throw when Firebase user is null', () async {
        final mockUserCredential = MockUserCredential();
        when(mockUserCredential.user).thenReturn(null);
        when(
          mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);

        expect(
          () => authRepository.signUp(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should use username as displayName when not provided', () async {
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(mockFirebaseUser.uid).thenReturn('new-user-uid');
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(
          mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUsersCollection.doc('new-user-uid')).thenReturn(mockUserDoc);
        when(mockUserDoc.set(any, any)).thenAnswer((_) async {});

        final user = await authRepository.signUp(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(user.displayName, 'testuser');
      });
    });

    group('signIn', () {
      test('should sign in and fetch user data', () async {
        // Arrange
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(mockFirebaseUser.uid).thenReturn('test-user-uid-123');
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(
          mockAuthService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(
          mockUsersCollection.doc('test-user-uid-123'),
        ).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(MockData.testUserFirestore);

        // Act
        final user = await authRepository.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(user.uid, 'test-user-uid-123');
        expect(user.username, 'testuser');
      });

      test('should throw when user data not found', () async {
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(mockFirebaseUser.uid).thenReturn('test-uid');
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(
          mockAuthService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUsersCollection.doc('test-uid')).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        expect(
          () => authRepository.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signOut', () {
      test('should call auth service signOut', () async {
        when(mockAuthService.signOut()).thenAnswer((_) async {});

        await authRepository.signOut();

        verify(mockAuthService.signOut()).called(1);
      });
    });

    group('getCurrentUser', () {
      test('should return user when authenticated', () async {
        when(mockAuthService.currentUserId).thenReturn('test-user-uid-123');
        when(
          mockUsersCollection.doc('test-user-uid-123'),
        ).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(MockData.testUserFirestore);

        final user = await authRepository.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.uid, 'test-user-uid-123');
      });

      test('should return null when not authenticated', () async {
        when(mockAuthService.currentUserId).thenReturn(null);

        final user = await authRepository.getCurrentUser();

        expect(user, isNull);
      });

      test('should return null when user doc does not exist', () async {
        when(mockAuthService.currentUserId).thenReturn('test-uid');
        when(mockUsersCollection.doc('test-uid')).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        final user = await authRepository.getCurrentUser();

        expect(user, isNull);
      });

      test('should return null on error', () async {
        when(mockAuthService.currentUserId).thenReturn('test-uid');
        when(mockUsersCollection.doc('test-uid')).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenThrow(Exception('Network error'));

        final user = await authRepository.getCurrentUser();

        expect(user, isNull);
      });
    });

    group('getUserByUid', () {
      test('should return user for valid uid', () async {
        when(mockUsersCollection.doc('user-123')).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(MockData.testUserFirestore);

        final user = await authRepository.getUserByUid('user-123');

        expect(user, isNotNull);
      });

      test('should return null for invalid uid', () async {
        when(mockUsersCollection.doc('invalid-uid')).thenReturn(mockUserDoc);
        when(mockUserDoc.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        final user = await authRepository.getUserByUid('invalid-uid');

        expect(user, isNull);
      });
    });
  });
}
