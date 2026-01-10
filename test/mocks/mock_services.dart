import 'package:mockito/annotations.dart';
import 'package:ate_app/services/firebase_auth_service.dart';
import 'package:ate_app/services/firestore_service.dart';
import 'package:ate_app/services/backend_service.dart';
import 'package:ate_app/services/notification_service.dart';
import 'package:ate_app/repositories/auth_repository.dart';
import 'package:ate_app/repositories/post_repository.dart';
import 'package:ate_app/repositories/user_repository.dart';
import 'package:ate_app/repositories/restaurant_repository.dart';
import 'package:ate_app/repositories/review_repository.dart';
import 'package:ate_app/repositories/follow_repository.dart';

/// Generate mocks for services and repositories
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  FirebaseAuthService,
  FirestoreService,
  BackendService,
  NotificationService,
  AuthRepository,
  PostRepository,
  UserRepository,
  RestaurantRepository,
  ReviewRepository,
  FollowRepository,
])
void main() {}
