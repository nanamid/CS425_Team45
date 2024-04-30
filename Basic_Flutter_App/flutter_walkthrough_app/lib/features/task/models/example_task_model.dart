class ExampleTask {
  int id ;
  String title;
  DateTime dueDate;
  String category;
  int sword = 0;
  bool isCompleted;

  ExampleTask({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.category,
    this.isCompleted = false,
  }): sword = getSwordValueForCategory(category);

  // Method to determine the sword value based on category
  static int getSwordValueForCategory(String category) {
    switch (category) {
      case "Study":
      case "Homework":
        return 1;
      case "Math Problems":
      case "Essay":
        return 2;
      case "Programming":
        return 3;
      case "Project":
        return 4;
      default:
        return 0;  // Default case if category does not match
    }
  }
}
