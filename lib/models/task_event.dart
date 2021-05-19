class TaskEvent {
  TaskEvent({
    this.isComplete,
    this.eventCode,
    this.title,
    this.message
  });

  bool isComplete;
  int eventCode;
  String title;
  String message;
}