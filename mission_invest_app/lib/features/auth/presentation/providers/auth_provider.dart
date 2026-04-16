import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../models/user_model.dart';
import '../../../../repositories/user_repository.dart';

/// Streams the current Firebase Auth user (null when signed out).
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Convenience provider that extracts the current [User] from the auth stream.
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull;
});

/// Holds the transient UI state for auth operations (loading / error).
class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});

  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier that exposes all authentication actions.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._userRepository) : super(const AuthState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository;

  /// Ensures a Firestore user document exists for the given Firebase user.
  Future<void> _ensureUserDocument(User user) async {
    final existing = await _userRepository.getUser(user.uid);
    if (existing != null) return;

    final now = DateTime.now();
    final userModel = UserModel(
      uid: user.uid,
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      createdAt: now,
      updatedAt: now,
    );
    await _userRepository.createUser(userModel);
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState(isLoading: true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (credential.user != null) {
        await _ensureUserDocument(credential.user!);
      }
      state = const AuthState();
    } on FirebaseAuthException catch (e) {
      state = AuthState(error: _mapFirebaseError(e.code));
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    state = const AuthState(isLoading: true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(displayName.trim());
      // Reload to pick up the displayName change before creating the doc.
      await credential.user?.reload();
      final freshUser = _auth.currentUser;
      if (freshUser != null) {
        await _ensureUserDocument(freshUser);
      }
      state = const AuthState();
    } on FirebaseAuthException catch (e) {
      state = AuthState(error: _mapFirebaseError(e.code));
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState(isLoading: true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = const AuthState();
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _ensureUserDocument(userCredential.user!);
      }
      state = const AuthState();
    } on FirebaseAuthException catch (e) {
      state = AuthState(error: _mapFirebaseError(e.code));
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AuthState(isLoading: true);
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      state = const AuthState();
    } on FirebaseAuthException catch (e) {
      state = AuthState(error: _mapFirebaseError(e.code));
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthState(isLoading: true);
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  /// Clears the current error so snackbar is not shown repeatedly.
  void clearError() {
    if (state.error != null) {
      state = const AuthState();
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check and try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(userRepositoryProvider));
});
