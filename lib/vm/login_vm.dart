import 'package:flutter_framework/repository/user_repository.dart';
import 'package:flutter_framework/vm/viewmodel_helper.dart';
import 'package:stacked/stacked.dart';

class LoginVM extends BaseViewModel with ViewModelHelper {
  String? _userName;
  set userName(String text) {
    _userName = text;
    notifyListeners();
  }

  String? _password;
  set password(String text) {
    _password = text;
    notifyListeners();
  }

  login() {
    execute(userRepository.login(_userName!, _password!), onSuccess: (result) {

    });
  }
}