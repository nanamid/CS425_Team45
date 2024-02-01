# CS425_Team45
Public repository for Team 45 of CS 425 - Software Engineering (2023)

## Project Assignment 4:
The ‘Stosh1’ branch takes a very basic template (in main) of a stateful listview and extends it to include the following features for our core task list functionality and client-side backend:
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
 
### Task List View
<img src='/Prototype%20Screenshots/Screenshot_1701755074.png' width='350'>

### Task Complete
<img src='/Prototype%20Screenshots/Screenshot_1701755170.png' width='350'>

### Task Detail View
<img src='/Prototype%20Screenshots/Screenshot_1701755176.png' width='350'>

### Slide to delete Task
<img src='/Prototype%20Screenshots/Screenshot_1701755187.png' width='350'>

### Enter Task data
<img src='/Prototype%20Screenshots/Screenshot_1701755194.png' width='350'>

## Create new Task
<img src='/Prototype%20Screenshots/Screenshot_1701755200.png' width='350'>

## Delete Task
<img src='/Prototype%20Screenshots/Screenshot_1701755213.png' width='350'>
