# **Xapptor Logic**
[![pub package](https://img.shields.io/pub/v/xapptor_logic?color=blue)](https://pub.dartlang.org/packages/xapptor_logic)
### Logic Module for util functions like cross-platform downloaders and functions to retrieve remote info.

## **Let's get started**

### **1 - Depend on it**
##### Add it to your package's pubspec.yaml file
```yml
dependencies:
    xapptor_logic: ^0.0.2
```

### **2 - Install it**
##### Install packages from the command line
```sh
flutter pub get
```

### **3 - Learn it like a charm**

### **File Downloader (Call Share in Mobile)**
```dart
FileDownloader.save(
    base64_string: pdf_base64,
    file_name: file_name,
);
```

### **Check if payments are enabled (Firestore)**
#### **Collection:** metadata
#### **Document:** payments
#### **Field:** enabled
#### **Check:** for each platform inside "enabled" (android/ios/web)
```dart
bool payments_are_enabled = await check_if_payments_are_enabled();
```

### **Check if user is admin (Firestore)**
#### **Collection:** users
#### **Document:** user_id
#### **Field:** admin
```dart
bool user_is_admin = await check_if_user_is_admin(user_id);
```

### **Firebase Tasks**

### **CREATE**

### **Coupons**
#### **Collection:** coupons
```dart
create_coupons(times, base_id);
```

### **UPDATE**

### **Field Value in Collection**
```dart
update_field_value_in_collection(field, value, collection);
```

### **Field Name in Collection**
```dart
update_field_name_in_collection(collection, old_field, new_field);
```

### **Field Name in Document**
```dart
update_field_name_in_document(collection, document, document_id, old_field, new_field);
```

### **Item Value in Array**
```dart
update_item_value_in_array(document_id, collection_id, field_key, field_value, index);
```

### **DUPLICATE**

### **Document**
```dart
duplicate_document(document_id, collection_id, times, base_id, apply_random_number);
```

### **Item in Array**
```dart
duplicate_item_in_array(document_id, collection_id, field_key, index, times, callback);
```

### **DELETE**

### **Field in Collection**
```dart
delete_field_in_collection(field, collection);
```

### **Corrupted Accounts**
#### Delete accounts that don't have gender, birthday, and country field
```dart
delete_corrupted_accounts();
```

### **Corrupted Certificates**
#### Delete certificates that don't have a user_id registered
```dart
delete_corrupted_certificates();
```

### **CHECK**

#### **If coupon is valid**
```dart
check_if_coupon_is_valid(
    coupon_id,
    context,
    valid_message,
    invalid_message,
);
```

### **Certificates**

#### **Get html certificate**
```dart
get_html_certificate(
    course_name,
    user_name,
    date,
    id,
);
```

#### **Check if exist certificate**
```dart
check_if_exist_certificate(
    course_id,
    context,
    show_has_certificate,
);
```

#### **Save certificate**
```dart
save_certificate(
    user,
    user_info,
    course_id,
    has_certificate,
    show_has_certificate,
    context,
);
```

#### **Check if course was completed**
```dart
check_if_course_was_completed(
    course_id,
    user_info,
    context,
);
```

#### **Get main color from image**
```dart
get_main_color_from_image(image);
```

#### **Get main color from remote image**
```dart
get_main_color_from_remote_image(url);
```

#### **Get main color from remote SVG**
```dart
get_main_color_from_remote_svg(url);
```

#### **Get remote image**
```dart
get_remote_image(url);
```

#### **Get remote SVG**
```dart
get_remote_svg(url);
```

#### **Check if is portrait mode**
```dart
is_portrait(context);
```

#### **Random number between a range**
```dart
random_number_with_range(min, max);
```

#### **Request position**
```dart
request_position();
```

#### **Get address from position**
```dart
get_address_from_position();
```

#### **Send Email**
```dart
send_email(
    to,
    subject,
    text,
    html,
);
```

#### **Convert timestamp to date**
```dart
timestamp_to_date(time_stamp);
```

### **4 - Check Abeinstitute Repo for more examples**
[Abeinstitute Repo](https://github.com/Xapptor/abeinstitute)

[Abeinstitute](https://www.abeinstitute.com)