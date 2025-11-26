import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_to_do_list/screen/SingUP.dart';
import 'package:flutter_to_do_list/screen/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authPageProvider = StateProvider<bool>((ref) => true);

class Auth_Page extends ConsumerWidget {
  Auth_Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(authPageProvider);

    void to() => ref.read(authPageProvider.notifier).state = !a;

    if (a) {
      return LogIN_Screen(to);
    } else {
      return SignUp_Screen(to);
    }
  }
}
