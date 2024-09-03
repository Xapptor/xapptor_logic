// Types of Form Field Validators.

enum FormFieldValidatorsType {
  email,
  website,
  phone,
  password,
  sms_code,
  name,
  multiline_short,
  multiline_medium,
  multiline_long,
  custom;

  int? get_Length() {
    switch (this) {
      case FormFieldValidatorsType.email:
        return 320;
      case FormFieldValidatorsType.website:
        return 1000;
      case FormFieldValidatorsType.phone:
        return 13;
      case FormFieldValidatorsType.password:
        return 50;
      case FormFieldValidatorsType.sms_code:
        return 6;
      case FormFieldValidatorsType.name:
        return 50;
      case FormFieldValidatorsType.multiline_short:
        return 100;
      case FormFieldValidatorsType.multiline_medium:
        return 500;
      case FormFieldValidatorsType.multiline_long:
        return 1000;
      case FormFieldValidatorsType.custom:
        return null;
    }
  }
}

// Check if the Field Value has a good structure for each type.

class FormFieldValidators {
  const FormFieldValidators({
    required this.value,
    required this.type,
    this.custom_message,
    this.custom_pattern,
  });

  final String value;
  final FormFieldValidatorsType type;
  final String? custom_message;
  final Pattern? custom_pattern;

  String? validate() {
    Pattern? pattern;
    String? message;

    // Email must have a valid structure.

    switch (type) {
      case FormFieldValidatorsType.email:
        {
          pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          message = 'Email format is invalid';
        }
        break;

      // Website must have a valid structure.

      case FormFieldValidatorsType.website:
        {
          pattern = r'^((http|https)://)?(www.)?[a-z0-9]+\.[a-z]+(/.[a-z]+)?$';
          message = 'Website format is invalid';
        }
        break;

      case FormFieldValidatorsType.phone:
        {}
        break;

      case FormFieldValidatorsType.password:
        {}
        break;

      case FormFieldValidatorsType.sms_code:
        {}
        break;

      // Name length must be longer than 0 and shorter or equal to 50.

      case FormFieldValidatorsType.name:
        {
          if (value.isNotEmpty && value.length <= FormFieldValidatorsType.name.get_Length()!) {
            return null;
          } else {
            return "Enter a valid name, 1-50 chars";
          }
        }

      // Multiline short length must be longer than 0 and shorter or equal to 100.

      case FormFieldValidatorsType.multiline_short:
        {
          if (value.isNotEmpty && value.length <= FormFieldValidatorsType.multiline_short.get_Length()!) {
            return null;
          } else {
            return custom_message ?? "Enter a valid description, 1-100 chars";
          }
        }

      // Multiline medium length must be longer than 0 and shorter or equal to 500.

      case FormFieldValidatorsType.multiline_medium:
        {
          if (value.isNotEmpty && value.length <= FormFieldValidatorsType.multiline_medium.get_Length()!) {
            return null;
          } else {
            return custom_message ?? "Enter a valid description, 1-500 chars";
          }
        }

      // Multiline long length must be longer than 0 and shorter or equal to 1000.

      case FormFieldValidatorsType.multiline_long:
        {
          if (value.isNotEmpty && value.length <= FormFieldValidatorsType.multiline_long.get_Length()!) {
            return null;
          } else {
            return custom_message ?? "Enter a valid description, 1-1000 chars";
          }
        }

      case FormFieldValidatorsType.custom:
        {
          if (custom_message != null && custom_pattern != null) {
            message = custom_message;
            pattern = custom_pattern;
          } else {
            assert(
              custom_message != null && custom_pattern != null,
              "Custom validator require a custom message and a custom pattern",
            );
          }
        }
        break;
    }

    bool has_number = false;
    bool has_letter = false;
    bool has_uppercase = false;
    bool has_lowercase = false;

    for (int i = 0; i < value.length; i++) {
      String subvalue = value.substring(i, i + 1);
      if (int.tryParse(subvalue) != null) {
        has_number = true;
      } else {
        has_letter = true;
        if (subvalue.toUpperCase() == subvalue) has_uppercase = true;
        if (subvalue.toLowerCase() == subvalue) has_lowercase = true;
      }
    }

    if (type == FormFieldValidatorsType.phone) {
      if (has_number) {
        if (!has_letter) {
          return null;
        } else {
          return "Cannot contain characters";
        }
      } else {
        return "Must contain numbers";
      }
    }
    // Password length must be longer than 7, has a number, has a letter, contain upper and lowercase characters.
    else if (type == FormFieldValidatorsType.password) {
      if (value.length > 7) {
        if (has_number) {
          if (has_letter) {
            if (has_uppercase) {
              if (has_lowercase) {
                return null;
              } else {
                return "Must contain lowercase";
              }
            } else {
              return "Must contain uppercase";
            }
          } else {
            return "Must contain a letter";
          }
        } else {
          return "Must contain a number";
        }
      } else {
        return "At least 8 characters";
      }
    } else if (type == FormFieldValidatorsType.sms_code) {
      if (value.length == 6) {
        if (has_number) {
          if (!has_letter) {
            return null;
          } else {
            return "Cannot contain characters";
          }
        } else {
          return "Must contain numbers";
        }
      } else {
        return "Must contain 6 digits";
      }
    } else {
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value)) {
        return message;
      } else {
        return null;
      }
    }
  }
}
