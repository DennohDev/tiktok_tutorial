import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_tutorial/constants.dart';

// local imports
import 'package:tiktok_tutorial/models/user.dart' as model;
import 'package:tiktok_tutorial/views/screens/auth/login_screen.dart';
import 'package:tiktok_tutorial/views/screens/home_screen.dart';

class AuthController extends GetxController {
  // make the auth controller publicly available
  static AuthController instance = Get.find();
  // the observable Rx lets us check whether the image has been selected or not

  // firebase auth user
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  // Pick image from gallery
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      Get.snackbar(
        'Profile Picture',
        'You have successfully Selected your profile picture',
      );
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // Upload to firebase storaged
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // register the user method

  void registerUser(
    String username,
    String email,
    String password,
    File? image,
  ) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save our user for authentication and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          profilePhoto: downloadUrl,
          email: email,
          uid: cred.user!.uid,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Error Creating Account', 'Please Fill in All Fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating An Account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.snackbar('Log in Successfull', 'You have logged in successfully.');
      } else {
        Get.snackbar('Error Logging in Account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Logging In', e.toString());
    }
  }
}
