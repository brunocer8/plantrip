import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_do_list/const/colors.dart';
import 'package:flutter_to_do_list/screen/add_note_screen.dart';
import 'package:flutter_to_do_list/widgets/stream_note.dart';

class Home_Screen extends ConsumerStatefulWidget {
  const Home_Screen({super.key});

  @override
  ConsumerState<Home_Screen> createState() => _Home_ScreenState();
}

bool show = true;

class _Home_ScreenState extends ConsumerState<Home_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      floatingActionButton: Visibility(
        visible: show,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Add_creen(),
              ));
            },
            backgroundColor: Color(0xFF2F80ED), 
            elevation: 6,
            child: Icon(Icons.add, size: 30, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white24, width: 2),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                children: [
                  Stream_note(false),
                  SizedBox(height: 8),
                  Text(
                    'finalizadas',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      shadows: [Shadow(color: Colors.black12, blurRadius: 2)],
                    ),
                  ),
                  SizedBox(height: 4),
                  Stream_note(true),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
