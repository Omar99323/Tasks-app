class Task {
  final int id;
  final String title;
  final String date;
  final String time;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Task.fromdb(data) {
    return Task(
      id: data['id'],
      title: data['name'],
      date: data['date'],
      time: data['time'],
      status: data['status'],
    );
  }
}
