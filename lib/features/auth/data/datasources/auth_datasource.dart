import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user.dart';

abstract class AuthDataSource {
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<User?> getCurrentUser();
}

class AuthDataSourceImpl implements AuthDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  User? _currentUser;

  User _mapGoogleUserToUser(GoogleSignInAccount googleUser) {
    return User(
      id: googleUser.id,
      email: googleUser.email,
      displayName: googleUser.displayName,
      photoUrl: googleUser.photoUrl,
    );
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    _currentUser = _mapGoogleUserToUser(googleUser);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

    if (googleUser != null) {
      _currentUser = _mapGoogleUserToUser(googleUser);
      return _currentUser;
    }

    // Try to sign in silently (if user was previously signed in)
    final GoogleSignInAccount? silentUser = await _googleSignIn.signInSilently();

    if (silentUser != null) {
      _currentUser = _mapGoogleUserToUser(silentUser);
      return _currentUser;
    }

    return null;
  }
}
