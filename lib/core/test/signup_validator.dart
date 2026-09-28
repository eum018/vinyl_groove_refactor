class SignupValidator {
  static final _email = RegExp(r'^[^.]*@.*\..*$');
  static final _password = RegExp(r'(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])');
  static final _name = RegExp(r'[^A-Za-zㄱ-ㅎㅏ-ㅣ가-힣]+');
  static final _phone = RegExp(r'\D+');

  static String? emailVerify(String str) {
    if (!_email.hasMatch(str)) {
      return '이메일은 필수 값으로써 "@" 기호 포함 "." 기호 포함(도메인 영역에만)의 형식을 가집니다.';
    }

    return null;
  }

  static String? passwordVerify(String str) {
    if (str.length < 8) {
      return '비밀번호는 필수 값으로써 8자 이상이어야 합니다.';
    }

    if (!_password.hasMatch(str)) {
      return '비밀번호는 대/소문자, 숫자, 특수문자 각 1자 이상 포함해야 합니다.';
    }

    return null;
  }

  static String? passwordConfirmVerify(String str1, String str2) {
    if (str1 != str2) {
      return '비밀번호와 비밀번호 확인이 일치하지 않습니다.';
    }

    return null;
  }

  static String? nameVerify(String str1) {
    if (str1.isEmpty) {
      return '이름은 필수 값입니다.';
    }

    if (!_name.hasMatch(str1)) {
      return '이름은 필수 값으로써 한글 또는 영문만 입력 가능합니다.';
    }

    return null;
  }

  static String? phoneVerify(String n1, String n2, String n3) {
    if (_phone.hasMatch(n1) || _phone.hasMatch(n2) || _phone.hasMatch(n3)) {
      return '휴대폰 번호는 숫자만 입력 가능합니다.';
    }

    return null;
  }
}
