class Note {
  String id;
  String subtitle;
  String title;
  String time;
  int image;
  bool isDon;

  List<String>? tasks;       
  List<bool>? tasksStatus;    

  Note(this.id, this.subtitle, this.time, this.image, this.title, this.isDon, this.tasks, this.tasksStatus);
}
