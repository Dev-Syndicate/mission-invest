import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Uncomment after Firebase setup
// final authStateProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

// Temporary placeholder until Firebase is connected
final authStateProvider = StateProvider<bool>((ref) => false);

final authRepositoryProvider = Provider((ref) {
  return AuthNotifier();
});

class AuthNotifier {
  Future<void> signInWithEmail(String email, String password) async {
    // TODO: Implement Firebase email sign-in
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    // TODO: Implement Firebase email sign-up
  }

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google sign-in
  }

  Future<void> signOut() async {
    // TODO: Implement Firebase sign-out
  }

  Future<void> resetPassword(String email) async {
    // TODO: Implement Firebase password reset
  }
}
