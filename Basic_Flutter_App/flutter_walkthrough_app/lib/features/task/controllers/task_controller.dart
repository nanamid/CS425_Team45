import 'package:get/get.dart';
import 'package:test_app/features/task/models/example_task_model.dart';
import 'package:test_app/utils/constants/image_strings.dart';

enum TaskFilter { today, thisWeek, completed }

class TaskController extends GetxController {

  var allTasks = <ExampleTask>[].obs; //Make the list of tasks observable

  // Reactive properties for task counts
  var numTasks = 0.obs;
  var numTasksCompleted = 0.obs;
  

  var filteredTasks = <ExampleTask>[].obs;
  var filter = TaskFilter.today.obs; // Use TaskFilter enum

  int totalSwordCount = 0;


  // Reactive calculation of total swords
  int get totalSwords => allTasks.where((task) => task.isCompleted).fold(
      0,
      (sum, task) =>
          sum + (task.sword ?? 0)) - totalSwordCount; // Ensure to handle nullable sword count


  // Reactive Avatar Path
  var avatarImagePath = ImageStrings.avatarHappy.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks(); // Call this to load your tasks; Load tasks from Hive when the controller is initialized

    // React to changes in numTasks, numTasksCompleted, and time
    once(filteredTasks, (_) => updateAvatarImagePath());  // Update avatar on initial load
    ever(allTasks, (_) => updateFilteredTasks());
    ever(filter, (_) => updateFilteredTasks());
    ever(filteredTasks, (_) => updateTaskCounts());

    
    ever(numTasksCompleted, (_) => updateAvatarImagePath());  // Update avatar when tasks change
    ever(numTasks, (_) => updateAvatarImagePath());  // Update avatar when task totals change
    
  }

  void loadTasks() {
    /* Here, load your tasks from a database or a local file
        var box = await Hive.openBox<ExampleTask>('tasks');
        allTasks.assignAll(box.values); // Assign tasks from Hive to the observable list
    */

    // For demonstration, we'll add tasks manually
    allTasks.assignAll([
      ExampleTask(
        id: 0,
        title: 'CS 484: Chapter 10 questions',
        dueDate: DateTime.now(), // Today
        category: 'Homework',
        isCompleted: false,
      ),
      ExampleTask(
        id: 1,
        title: 'Study Math Problems',
        dueDate: DateTime.now().add(Duration(days: 1)), // Tomorrow
        category: 'Study',
        isCompleted: false,
      ),
      ExampleTask(
        id: 2,
        title: 'Write History Essay',
        dueDate: DateTime.now().subtract(Duration(days: 1)), // Yesterday
        category: 'Essay',
        isCompleted: false,
      ),
      ExampleTask(
        id: 3,
        title: 'CS 426 Final Demo',
        dueDate: DateTime.now().add(Duration(days: 3)), // Later this week
        category: 'Project',
        isCompleted: true,
      ),
      ExampleTask(
        id: 4,
        title: 'Submit History Homework',
        dueDate: DateTime.now().add(Duration(days: 3)), // Later this week
        category: 'Homework',
        isCompleted: true,
      ),
      ExampleTask(
        id: 5,
        title: 'Merge Code Changes',
        dueDate: DateTime.now().subtract(Duration(days: 7)), // Last week
        category: 'Project',
        isCompleted: true,
      ),
      ExampleTask(
        id: 6,
        title: 'Write Submission for Essay Competition',
        dueDate: DateTime.now().add(Duration(days: 4)), // Later this week
        category: 'Essay',
        isCompleted: true,
      ),
      ExampleTask(
        id: 7,
        title: 'CPE 301: Arduino Project',
        dueDate: DateTime.now(), // Today
        category: 'Homework',
        isCompleted: false,
      ),// Add more tasks as needed
    ]);

    updateFilteredTasks();
    updateAvatarImagePath(); // Explicitly call after tasks are loaded and filtered
  }

  void addTask(ExampleTask newTask) async {
    // var box = await Hive.openBox<ExampleTask>('tasks');
    // await box.add(newTask);
    allTasks.add(newTask);
  }

  void deleteTask(int taskIndex) async {
    // var box = await Hive.openBox<ExampleTask>('allTasks');
    // await box.deleteAt(taskIndex);
    
    allTasks.removeAt(taskIndex);
  }

  void toggleTaskStatus(ExampleTask task) {
    task.isCompleted = !task.isCompleted;
    allTasks.refresh();
  }

  void deleteAllTasks() {
    allTasks.clear();
  }

  void deleteCompletedTasks() {
    allTasks.removeWhere((task) => task.isCompleted);
  }

  void updateFilteredTasks() {
    handleFilterChange(filter.value);
    // Update counts based on the filtered tasks
    numTasks.value = filteredTasks.length;
    numTasksCompleted.value = filteredTasks.where((task) => task.isCompleted).length;
  }

   void handleFilterChange(TaskFilter filter) {
    DateTime now = DateTime.now();
    DateTime startOfWeek =
        DateTime(now.year, now.month, now.day - now.weekday + 1);
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    switch (filter) {
      case TaskFilter.today:
        filteredTasks.value = allTasks
            .where((task) =>
                task.dueDate.year == now.year &&
                task.dueDate.month == now.month &&
                task.dueDate.day == now.day)
            .toList()
            ..sort((ExampleTask a, ExampleTask b) => a.dueDate.compareTo(b.dueDate));
      case TaskFilter.thisWeek:
        filteredTasks.value = allTasks
            .where((task) =>
                task.dueDate.isAfter(startOfWeek) &&
                task.dueDate.isBefore(endOfWeek) 
                //&& !task.isCompleted // Remove this line to show all tasks for the week
                )
            .toList()
            ..sort((ExampleTask a, ExampleTask b) => a.dueDate.compareTo(b.dueDate));
      case TaskFilter.completed:
        filteredTasks.value =
            allTasks.where((task) => task.isCompleted).toList()
            ..sort((ExampleTask a, ExampleTask b) => a.dueDate.compareTo(b.dueDate));
    }
}


  void changeFilter(TaskFilter newFilter) {
    filter.value = newFilter;
  }


  static String getFilterImagePath(TaskFilter newFilter){
    if(newFilter == TaskFilter.completed){
      return ImageStrings.doneFilter;
    }else if(newFilter == TaskFilter.thisWeek){
      return ImageStrings.weekFilter;
    }else{
      return ImageStrings.todayFilter;
    }

  }

  void setTotalSwords(int totalSwordCount){
    totalSwordCount = totalSwordCount;
    //totalSwords = allTasks.where((task) => task.isCompleted).fold(
    //  0,
    //  (sum, task) =>
    //      sum + (task.sword ?? 0)); // Ensure to handle nullable sword count

  }


  //AVATAR FUNCTIONS

  void updateTaskCounts() {
    numTasks.value = filteredTasks.length;
    numTasksCompleted.value = filteredTasks.where((task) => task.isCompleted).length;
  }

  void updateAvatarImagePath() {
    avatarImagePath.value = getAvatarImagePath(numTasksCompleted.value, numTasks.value);
  }

  String getAvatarImagePath(int completedTasks, int totalTasks) {
    double percentageOfTasksCompleted = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;
    //final now = DateTime.now();
    //final currentHour = now.hour;

    //TRIAL
    final now = DateTime.now().subtract(Duration(hours: 4));
    final currentHour = now.hour;


    if (currentHour >= 8 && currentHour < 12) {
      return ImageStrings.avatarHappy;
    } else if (currentHour >= 12 && currentHour < 17) {
      if (percentageOfTasksCompleted >= 70) {
        return ImageStrings.avatarInLove;
      } else if (percentageOfTasksCompleted >= 50) {
        return ImageStrings.avatarSemiHappy;
      } else if (percentageOfTasksCompleted < 25) {
        return ImageStrings.avatarAnnoyed;
      } else {
        return ImageStrings.avatarHappy;
      }
    } else if (currentHour >= 17 && currentHour < 24) { //&& currentHour < 24
      if (percentageOfTasksCompleted >= 70) {
        return ImageStrings.avatarInLove;
      } else if (percentageOfTasksCompleted >= 50) {
        return ImageStrings.avatarAnnoyed;
      } else if (percentageOfTasksCompleted < 25) {
        return ImageStrings.avatarAngry;
      } else {
        return ImageStrings.avatarHappy;
      }
    } else {
      return ImageStrings.avatarHappy;
    }
  }
}
