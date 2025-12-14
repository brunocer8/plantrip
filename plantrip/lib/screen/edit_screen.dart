import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../const/colors.dart';
import '../data/firestore_provider.dart';
import '../model/notes_model.dart';


class EditScreen extends ConsumerStatefulWidget {
  final Note note;
  const EditScreen(this.note, {super.key});


  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}


class _EditScreenState extends ConsumerState<EditScreen> {
  late TextEditingController title;
  late TextEditingController subtitle;


  final List<String> tasks = [];
  final List<bool> tasksChecked = [];
  final taskController = TextEditingController();


  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();


  final ImagePicker _picker = ImagePicker();


  String? _imagePath;


  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.note.title);
    subtitle = TextEditingController(text: widget.note.subtitle);


    tasks.addAll(widget.note.tasks);
    tasksChecked.addAll(widget.note.tasksStatus);


    _imagePath = widget.note.imagePath;
  }


  @override
  void dispose() {
    title.dispose();
    subtitle.dispose();
    taskController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }


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
                titleWidgets(),
                const SizedBox(height: 18),
                subtiteWedgite(),
                const SizedBox(height: 18),
                if (_imagePath != null) imagePreview(),
                if (_imagePath != null) const SizedBox(height: 18),
                todoInput(),
                const SizedBox(height: 10),
                todoList(),
                const SizedBox(height: 22),
                button(),
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
            backgroundColor: const Color(0xFF2F80ED),
            minimumSize: const Size(170, 48),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          onPressed: () async {
            if (!mounted) return;


            final firestore = ref.read(firestoreRepositoryProvider);
            await firestore.updateNote(
              widget.note.id,
              _imagePath,
              title.text,
              subtitle.text,
              tasks,
              tasksChecked,
              travelDateTime: widget.note.travelDateTime,
            );


            if (!mounted) return;
            Navigator.pop(context);
          },
          child: const Text('atualizar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE6ECFF),
            minimumSize: const Size(170, 48),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'cancelar',
            style: TextStyle(color: Color(0xFF7C6BD7)),
          ),
        ),
      ],
    );
  }


  Widget imagePreview() {
    return GestureDetector(
      onTap: _showImageOptionsBottomSheet,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Image.file(
                File(_imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'editar imagem',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _showImageOptionsBottomSheet() async {
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Alterar imagem (galeria)'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null && mounted) {
                    setState(() => _imagePath = picked.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Alterar imagem (câmera)'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null && mounted) {
                    setState(() => _imagePath = picked.path);
                  }
                },
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Remover imagem',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _imagePath = null);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget titleWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'destino',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: customBlue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget subtiteWedgite() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'descrição',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: customBlue,
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
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ],
              ),
              child: TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: 'nova tarefa',
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffc5c5c5),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: customBlue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2F80ED),
              borderRadius: BorderRadius.circular(11),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3)
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3)
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(tasks[index]),
                    activeColor: const Color(0xFF2F80ED),
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
                  icon:
                      const Icon(Icons.delete, color: Color(0xFF5695F4)),
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