// Classe responsável por gerenciar os dados e serviçoes relacionados à usuário:
// signup, login, logout, saveInDatabase, editUser

import 'dart:io';

import 'package:controle_estoque_app/core/models/user_data.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  /*------- Stream de alteração no usuário logado -------*/

  static UserData? _currentUser;

  static final _userStream = Stream<UserData?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    await for (final user in authChanges) {
      if (user == null) {
        _currentUser = null;
      } else {
        _currentUser = await UserService().getUserById(user.uid);
      }

      controller.add(_currentUser);
    }
  });

  UserData? get currentUser => _currentUser;

  Stream<UserData?> get userChanges => _userStream;

  /*------- Conversão de dados entre Firestore e UserData -------*/

  static UserData _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data();

    return UserData(
      id: doc.id,
      code: data?['codigo'],
      name: data?['nome'],
      email: data?['email'],
      tipoUsuario: TipoUsuario.values.firstWhere(
        (e) => e.name == data?['tipoUsuario'],
      ),
      imageUrl: data?['imagemUrl'],
      createdAt: DateTime.parse(data?['dataCadastro']),
    );
  }

  static Map<String, dynamic> _toFirestore(UserData user, SetOptions? options) {
    return {
      'codigo': user.id!.substring(0, 6).toUpperCase(),
      'nome': user.name,
      'email': user.email,
      'tipoUsuario': user.tipoUsuario.name,
      'imagemUrl': user.imageUrl,
      'dataCadastro': user.createdAt.toIso8601String(),
    };
  }

  /*------- Conversão de um objeto User em UserData -------*/
  static UserData _toUserData(User user, [String? name]) {
    return UserData(
      id: user.uid,
      code: user.uid.substring(0, 6).toUpperCase(),
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: user.photoURL ?? '',
      createdAt: DateTime.now(),
    );
  }

  /*------- Criação de usuário, login e logout -------*/

  Future<void> signup(String name, String email, String password) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    // Criando credenciais de usuário
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      // Atualizando nome do usuário
      await userCredential.user?.updateDisplayName(name);

      // Salvando usuário no banco de dados
      await _saveUserInDatabase(_toUserData(userCredential.user!, name));

      await signup.delete();
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

  /*-------------- Funções auxiliares do usuário --------------*/

  Future<void> _saveUserInDatabase(UserData user) async {
    final store = FirebaseFirestore.instance;

    final docRef = store.collection('users').doc(user.id).withConverter(
        fromFirestore: _fromFirestore, toFirestore: _toFirestore);

    await docRef.set(user);
  }

  Future<String> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return '';
    final storage = FirebaseStorage.instance;

    final imageRef = storage.ref().child('images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});

    return await imageRef.getDownloadURL();
  }

  Future<void> updateUserImage(File image) async {
    final imageName = '${_currentUser!.id}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    if (imageUrl.isNotEmpty) {
      _currentUser!.imageUrl = imageUrl;
      await _saveUserInDatabase(_currentUser!);
    }
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

  /*-------------- Guardando uma 'cache' de emails --------------*/
  final Map<String, String> _usersEmails = {};

  Map<String, String> get usersEmails => _usersEmails;

  Future<void> getUsersByProductsUsersIds(List<String> userIds) async {
    final store = FirebaseFirestore.instance;

    final newUsersIds =
        userIds.where((id) => !_usersEmails.containsKey(id)).toList();

    if (newUsersIds.isEmpty) return;

    for (var userId in newUsersIds) {
      final docRef = store.collection('users').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        _usersEmails[userId] =
            docSnapshot.data()!['email'] ?? 'Usuário desconhecido';
      } else {
        _usersEmails[userId] = '';
      }
    }
    notifyListeners();
  }
}
