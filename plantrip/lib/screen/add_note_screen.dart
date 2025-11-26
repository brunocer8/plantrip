import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_do_list/const/colors.dart';
import 'package:flutter_to_do_list/data/firestore_provider.dart';

class Add_creen extends ConsumerStatefulWidget {
  const Add_creen({super.key});
  @override
  ConsumerState<Add_creen> createState() => _Add_creenState();
}

class _Add_creenState extends ConsumerState<Add_creen> {
  final title = TextEditingController();
  final subtitle = TextEditingController();
  final imagensController = TextEditingController();

  final List<String> tasks = [];
  final taskController = TextEditingController();
  final List<bool> tasksChecked = [];
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int indexx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title_widgets(),
                SizedBox(height: 18),
                subtite_wedgite(),
                SizedBox(height: 18),
                imagens_widget(),
                SizedBox(height: 18),
                imagess(),
                SizedBox(height: 18),
                todoInput(),
                SizedBox(height: 10),
                todoList(),
                SizedBox(height: 22),
                button()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2F80ED),
            minimumSize: Size(170, 48),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          onPressed: () async {
            final firestore = ref.read(firestoreRepositoryProvider);
            await firestore.AddNote(
              subtitle.text,
              title.text,
              indexx,
              tasks,
              tasksChecked,
            );
            Navigator.pop(context);
          },
          child: Text('adicionar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(170, 48),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('cancelar',
              style: TextStyle(color: Color(0xFF7C6BD7))),
        ),
      ],
    );
  }

  Container imagess() {
    return Container(
      height: 130,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indexx = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 4 : 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    width: 3,
                    color: indexx == index ? Color(0xFF2F80ED) : Colors.grey.shade300,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 7)
                  ],
                ),
                width: 110,
                margin: EdgeInsets.all(7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('images/${index}.png', fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'destino',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
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

  Padding subtite_wedgite() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'descrição',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
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

  Widget imagens_widget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          controller: imagensController,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'imagens',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
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

  Widget todoInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
              ),
              child: TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: 'nova tarefa',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
          ),
          SizedBox(width: 7),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2F80ED),
              borderRadius: BorderRadius.circular(11),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(taskController.text);
                    tasksChecked.add(false);
                    taskController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget todoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(tasks[index]),
                    activeColor: Color(0xFF2F80ED),
                    checkColor: Colors.white,
                    value: tasksChecked[index],
                    onChanged: (value) {
                      setState(() {
                        tasksChecked[index] = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                      tasksChecked.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
