import 'package:flutter/material.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/screens/abeinstitute/home.dart' as Abeinstitute;
import 'package:xapptor_ui/screens/lum/home.dart' as Lum;
import 'package:xapptor_auth/xapptor_user.dart';
import 'package:xapptor_ui/values/version.dart';

open_home(XapptorUser user) {
  Widget current_home = Container();
  if (current_app == CurrentApp.Abeinstitute) {
    current_home = Abeinstitute.Home(
      user: user,
    );
  } else {
    current_home = Lum.Home(
      user: user,
    );
  }

  add_new_app_screen(
    AppScreen(
      name: "home",
      child: current_home,
    ),
  );
  open_screen("home");
}

open_login() => open_screen("login");
open_register() => open_screen("register");
open_forgot_password() => open_screen("forgot_password");
