enum TodoStatus {
  inProgress,
  completed,
}

TodoStatus getStatusFromString(String status) {
  switch (status) {
    case 'TodoStatus.inProgress':
      return TodoStatus.inProgress;
    case 'TodoStatus.completed':
      return TodoStatus.completed;
    default:
      return TodoStatus.inProgress;
  }
}
