# XapptorLogic

## Let's get started

### 1 - Depend on it

##### Add it to your package's pubspec.yaml file

```yml
dependencies:
    xapptor_logic: 
        git: 
        url: git://github.com/Xapptor/xapptor_logic.git 
        ref: main
```

### 2 - Install it

##### Install packages from the command line
```sh
flutter packages get
```

### 3 - Learn it like a charm

```dart
UserInfoView(
    text_list: login_values_english,
    tc_and_pp_text: RichText(text: TextSpan()),
    gender_values: [],
    country_values: [],
    text_color: color_abeinstitute_text,
    first_button_color: color_abeinstitute_main_button,
    second_button_color: color_abeinstitute_text,
    third_button_color: color_abeinstitute_text,
    logo_image_path: logo_image_path_abeinstitute,
    has_language_picker: has_language_picker_abeinstitute,
    topbar_color: color_abeinstitute_topbar,
    custom_background: null,
    user_info_form_type: UserInfoFormType.login,
    outline_border: true,
    first_button_action: null,
    second_button_action: open_forgot_password,
    third_button_action: open_register,
    has_back_button: true,
    text_field_background_color: null,
);
```

### 4 - Live Examples

#### Login

[Abeinstitute Login](https://www.abeinstitute.com/#/login)

[Lum Login](https://app.franquiciaslum.com/#/login)

#### Register

[Abeinstitute Register](https://www.abeinstitute.com/#/register)

[Lum Register](https://app.franquiciaslum.com/#/register)

#### Restore Password

[Abeinstitute Restore Password](https://www.abeinstitute.com/#/forgot_password)

[Lum Restore Password](https://app.franquiciaslum.com/#/forgot_password)