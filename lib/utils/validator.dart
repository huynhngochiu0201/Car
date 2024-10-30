import 'form_validator.dart';

class Validator {
  static final required = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
  ]).call;

  static final password = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]).call;

  static final email = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]).call;

  static String? Function(String?)? confirmPassword(String? password) {
    return MultiValidator([
      RequiredValidator(errorText: 'This field is required'),
      MatchValidator(password, errorText: 'Confirm password is not match'),
    ]).call;
  }

  static final phoneNumber = MultiValidator([
    RequiredValidator(errorText: 'This field is required'),
    MinLengthValidator(10,
        errorText: 'Phone number must be at least 10 digits long'),
    PatternValidator(r'^\d+$', errorText: 'Enter a valid phone number'),
  ]).call;
}
