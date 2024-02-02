# CS425_Team45
Public repository for Team 45 of CS 425-426 - Software Engineering (2023-2024)

## Spring 2024 Project Assignment 1:
The app includes the following features for our core task list functionality and client-side backend:
- Users can add tasks
- Users can remove tasks
- Users can clock-in and out of tasks
  - Time entries are viewable and a total time field is calculated. This will be the basis for our gamified XP system
- Users can view and modify task status (TODO, WAIT, DONE, etc.)
- When set to ‘DONE,’ tasks appear ‘checked off’
- Client-side backend: The above UI is a proof-of-concept interface to our backend structures:
  - List of Task Lists: Supports an arbitrary number of separate task lists (Intended for Home, Work, Friends, etc.)
  - Task List: Named and contains an arbitrary number of tasks. (Intended as the unit for task collaboration: Users will create a shared Task List)
  - Task: Contains fields for name, description, clock history, etc. as described in P2 and P3. Time calculations use the native Dart DateTime class.
  - Backend storage: Using the Flutter Hive package, our structures persist on disk. Our custom objects use generated TypeAdapters (serializers), and this model sets the stage for pushing structures to a remote database.

Additionally, we have added the following features since our last demo:
- Confirmation dialogs
- Widget refresh fixes
- Code readability
- Improved clock entry widget
- Improved Material design theme
- Using bottomNavigationBar() with placeholder screens for later use
 
### Task List View
<img src='/Prototype%20Screenshots/Screenshot_1706825324.png' width='350'>

### Task Complete
<img src='/Prototype%20Screenshots/Screenshot_1706825331.png' width='350'>

### Task Detail View
<img src='/Prototype%20Screenshots/Screenshot_1706825351.png' width='350'>

### Slide to delete Task
<img src='/Prototype%20Screenshots/Screenshot_1706825358.png' width='350'>

## Delete Task
<img src='/Prototype%20Screenshots/Screenshot_1706825385.png' width='350'>

### Enter Task data
<img src='/Prototype%20Screenshots/Screenshot_1706825365.png' width='350'>

### Clock Running Indicator
<img src='/Prototype%20Screenshots/Screenshot_1706825418.png' width='350'>
