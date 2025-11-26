import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/auth/auth_page.dart';
import 'package:flutter_to_do_list/screen/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart'; // Importe o provider do passo 1

class Main_Page extends ConsumerWidget {
  const Main_Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: authState.when(
        data: (user) {
          if (user != null) {
            return Home_Screen();
          } else {
            return Auth_Page();
          }
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
