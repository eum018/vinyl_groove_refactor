class LoginValidator {
  LoginValidator._();

  static final _email = RegExp(r'^[^.]*@.*\..*$');
  static final _password = RegExp(r'(?=.*[A-Z])(?=.*[a-z])');

  static String? emailVerify(String str) {
    if (str.isEmpty) {
      return '이메일은 필수 입니다.';
    }

    if (!_email.hasMatch(str)) {
      return '이메일은 “@“ 포함 ”.“포함 ”@“ 앞에 ”.“사용 불가의 형식을 따릅니다.';
    }

    return null;
  }

  static String? passwordVerify(String str) {
    if (str.isEmpty) {
      return '비밀번호는 필수 입니다.';
    }

    if (str.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다.';
    }

    if (!_password.hasMatch(str)) {
      return '비밀번호는 - 대문자 1자 이상 소문자 1자 이상의 형식을 따릅니다.';
    }

    return null;
  }
}


