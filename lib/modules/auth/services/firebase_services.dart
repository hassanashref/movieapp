import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<UserModel> getUsersCollection() {
    return _firestore.collection('users').withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromFirestore(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toFirestore(),
        );
  }

  static Future<void> saveUser(UserModel user) async {
    await getUsersCollection().doc(user.uid).set(user);
  }

  static Future<UserModel?> getUser(String uid) async {
    final doc = await getUsersCollection().doc(uid).get();
    return doc.data();
  }

  static Future<UserCredential?> createAccount({
    required String password,
    required String name,
    required String email,
    required String avatar,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        try {
          await credential.user!.updateDisplayName(name.trim());
        } catch (_) {}

        try {
          await credential.user!.updatePhotoURL(avatar);
        } catch (_) {}

        final userModel = UserModel(
          uid: credential.user!.uid,
          name: name.trim(),
          email: email.trim(),
          avatar: avatar,
          createdAt: DateTime.now(),
        );

        try {
          await saveUser(userModel).timeout(const Duration(seconds: 4));
        } catch (e) {
          // Allow registration to proceed even if Firestore write is queued/offline
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is invalid.';
      } else {
        throw e.message ?? 'An error occurred during registration.';
      }
    } catch (e) {
      rethrow;
    }
  }

  // Alias for backward compatibility
  static Future<UserCredential?> creatAccount({
    required String password,
    required String name,
    required String email,
    required String avatar,
  }) =>
      createAccount(
        password: password,
        name: name,
        email: email,
        avatar: avatar,
      );

  static Future<UserCredential?> login({
    required String password,
    required String email,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is invalid.';
      } else if (e.code == 'user-disabled') {
        throw 'This account has been disabled.';
      } else {
        throw e.message ?? 'Login failed. Please try again.';
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is invalid.';
      } else {
        throw e.message ?? 'Failed to send reset email.';
      }
    } catch (e) {
      rethrow;
    }
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            '132729081953-qjgpohgag452fj9gknk7bn14b8pn5lb3.apps.googleusercontent.com',
      );
      final result = await _googleSignIn.authenticate();
      final googleAuth = result.authentication;
      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credentials);

      if (userCredential.user != null) {
        final existingUser = await getUser(userCredential.user!.uid);
        if (existingUser == null) {
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? 'User',
            email: userCredential.user!.email ?? '',
            avatar: userCredential.user!.photoURL ??
                'assets/images/gamer (2).png',
            createdAt: DateTime.now(),
          );
          await saveUser(userModel);
        }
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

   static User? get currentUser => _auth.currentUser;

   static bool get isUserLoggedIn => _auth.currentUser != null;

   static Future<void> signOut() async {
     await _auth.signOut();
     try {
       await _googleSignIn.signOut();
     } catch (_) {}
   }

   static Future<UserCredential?> sinInWhithGoogle() => signInWithGoogle();
}
