import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        return UserModel(
          fullName: account.displayName ?? 'No Name',
          email: account.email,
          signupType: 'Google',
          profilePhotoUrl: account.photoUrl,
        );
      }
      return null;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
