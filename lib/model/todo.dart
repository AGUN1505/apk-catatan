class ToDo {
  final int? id;
  final String task;
  bool isCompleted;

  ToDo({
    this.id,
    required this.task,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      task: map['task'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
