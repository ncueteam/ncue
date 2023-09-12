import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ncue_app/src/features/user/user_model.dart';

class UserService {
  FirebaseFirestore database = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Future<UserModel> loadUserData() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: user?.uid).get();
    if (querySnapshot.size == 1) {
      QueryDocumentSnapshot lst = querySnapshot.docs.first;
      return UserModel(lst['name'], lst['uuid'], type: lst['type']);
    } else {
      return createUserData(user);
    }
  }

  void updateUserData(UserModel model, User user) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await reference.where('uuid', isEqualTo: user.uid).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      DocumentReference documentReference = reference.doc(documentSnapshot.id);

      Map<String, dynamic> updatedData = {
        'name': model.name,
        "type": model.type,
        "uuid": model.uuid,
      };
      await documentReference.update(updatedData);
    } else {
      createUserData(user);
    }
  }

  UserModel createUserData(User? user) {
    if (user != null) {
      UserModel model =
          UserModel(user.displayName ?? user.email ?? user.uid, user.uid);
      database.collection('users').add({
        'name': model.name,
        "type": model.type,
        "uuid": model.uuid,
      });
      return model;
    } else {
      return UserModel("error", "error");
    }
  }
}
