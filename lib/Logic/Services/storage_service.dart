import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService{
  final storage = const FlutterSecureStorage();
  
  void deleteDataAfterLogout() {
    storage.delete(key: 'token');
    storage.delete(key: 'name');
    storage.delete(key: 'email');
    storage.delete(key: 'userId');
  }

  void saveToken(String token) {
    storage.write(key: 'token', value: token);
  }

  void saveCredentials(String name, email, userId) {
    storage.write(key: 'name', value: name);
    storage.write(key: 'email', value: email);
    storage.write(key: 'userId', value: userId);
  }

  Future<String?> readToken() async {
    return storage.read(key: 'token');
  }

  Future<String?> readUserName() {
    return storage.read(key: 'name');
  }

  Future<String?> readUserEmail() {
    return storage.read(key: 'email');
  }

  Future<String?> readUserId() {
    return storage.read(key: 'userId');
  }

}