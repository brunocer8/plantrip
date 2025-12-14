class Note {
  String id;
  String subtitle;
  String title;
  String time;
  String? imagePath;
 
  bool isDon;

  List<String> tasks;
  List<bool> tasksStatus;

  DateTime? travelDateTime;

  Note(
    this.id,
    this.subtitle,
    this.time,
    this.imagePath,
    this.title,
    this.isDon,
    List<String>? tasks,
    List<bool>? tasksStatus,
    this.travelDateTime,
  )   : tasks = tasks ?? [],
        tasksStatus = tasksStatus ?? [];

  Note.newEmpty({
    required this.id,
    this.subtitle = '',
    this.title = '',
    this.time = '',
    this.imagePath,
    this.isDon = false,
    this.travelDateTime,
  })  : tasks = [],
        tasksStatus = [];
}