import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_do_list/const/colors.dart';
import 'package:flutter_to_do_list/data/auth_data.dart';

class LogIN_Screen extends ConsumerStatefulWidget {
  final VoidCallback show;
  LogIN_Screen(this.show, {super.key});

  @override
  ConsumerState<LogIN_Screen> createState() => _LogIN_ScreenState();
}

class _LogIN_ScreenState extends ConsumerState<LogIN_Screen> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() { setState(() {}); });
    _focusNode2.addListener(() { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 32),
              image(),
              SizedBox(height: 36),
              textfield(email, _focusNode1, 'e-mail', Icons.email),
              SizedBox(height: 12),
              textfield(password, _focusNode2, 'senha', Icons.lock, obscure: true),
              SizedBox(height: 16),
              account(),
              SizedBox(height: 32),
              isLoading ? CircularProgressIndicator(color: custom_green)
                        : Login_bottom(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget account() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("primeira vez aqui?",
              style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: Text('criar uma conta',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }

  Widget Login_bottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () async {
          setState(() => isLoading = true);
          final authRepo = ref.read(authRepositoryProvider);
          try {
            await authRepo.login(email.text, password.text);
            // Se login for bem-sucedido, pode navegar para outra tela aqui
          } catch (e) {
            String errorMessage = 'e-mail e/ou senha incorretos.';
            if (e is FirebaseAuthException) {
              if (e.code == 'user-not-found') {
                errorMessage = 'Usuário não encontrado.';
              } else if (e.code == 'wrong-password') {
                errorMessage = 'Senha incorreta.';
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(errorMessage)
                ],
              )),
            );
          } finally {
            setState(() => isLoading = false);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text('login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              shadows: [Shadow(color: Colors.black12, blurRadius: 2)],
            ),
          ),
        ),
      ),
    );
  }

  Widget textfield(
      TextEditingController controller,
      FocusNode focusNode,
      String hint, IconData icon,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? custom_green : Color(0xffc5c5c5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: custom_green,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget image() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: backgroundColors,
          image: DecorationImage(
            image: AssetImage('images/7.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
