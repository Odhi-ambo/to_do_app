class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morining Exercise', isDone: true),
      ToDo(id: '02', todoText: 'Buy breakfast', isDone: true),
      ToDo(
        id: '3',
        todoText: 'Talk to someone',
      ),
      ToDo(
        id: '04',
        todoText: 'Study on the incoming test',
      ),
      ToDo(
        id: '05',
        todoText: 'Do some Coding',
      ),
      ToDo(
        id: '06',
        todoText: 'Watch a RugbyMatch',
      ),
    ];
  }
}
