// Classe responsável por gerenciar os dados e serviçoes relacionados à usuário:
// signup, login, logout, saveInDatabase, editUser

import 'package:controle_estoque_app/core/models/user_data.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  /*------- Stream de usuário logado e de todos os usuários cadastrados -------*/

  static UserData? _currentUser;

  static List<UserData> _users = [];

  static final _userStream = Stream<UserData?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toUserData(user);

      controller.add(_currentUser);
    }
  });

  static final _usersStream = Stream<List<UserData>>.multi((controller) async {
    if (_users.isNotEmpty) {
      controller.add(_users);
    }

    final store = FirebaseFirestore.instance;

    final snapshot = store
        .collection('users')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('email', descending: false)
        .snapshots();

    final subscription = snapshot.listen((snap) {
      _users = snap.docs.map((doc) => doc.data()).toList();

      controller.add(_users);
    });

    controller.onCancel = () => subscription.cancel();
  });

  UserData? get currentUser => _currentUser;

  Stream<UserData?> get userChanges => _userStream;

  Stream<List<UserData>> get usersStream => _usersStream;

  /*------- Conversão de dados entre Firestore e UserData -------*/

  static UserData _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data();

    return UserData(
      id: doc.id,
      email: data?['email'],
      tipoUsuario: TipoUsuario.values.firstWhere(
        (e) => e.name == data?['tipoUsuario'],
      ),
    );
  }

  static Map<String, dynamic> _toFirestore(UserData user, SetOptions? options) {
    return {
      'email': user.email,
      'tipoUsuario': user.tipoUsuario.name,
    };
  }

  // Método privado que converte um objeto User em UserData
  static UserData _toUserData(User user) {
    return UserData(
      id: user.uid,
      email: user.email!,
    );
  }

  /*------- Criação de usuário, login e logout -------*/

  Future<void> signup(String email, String password) async {
    final auth = FirebaseAuth.instance;

    // Criando credenciais de usuário
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      // Salvando usuário no banco de dados
      await _saveUserInDatabase(_toUserData(userCredential.user!));
    }
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /*-------------- CRUD de usuário --------------*/

  Future<void> _saveUserInDatabase(UserData user) async {
    final store = FirebaseFirestore.instance;

    final docRef = store.collection('users').doc(user.id);

    await docRef.set(
      {
        'email': user.email,
        'tipoUsuario': user.tipoUsuario.name,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> editUserType(UserData user, TipoUsuario newUserType) async {
    user.changeUserType(newUserType);

    await _saveUserInDatabase(user);
  }

  Future<UserData?> getUserById(String userId) async {
    final store = FirebaseFirestore.instance;

    final docRef = store.collection('users').doc(userId);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return _fromFirestore(docSnapshot, null);
    }

    return null;
  }
}
