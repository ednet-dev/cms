// library model;
//
// String defaultDomainModelYaml = '''
// name: TaskManagement
// dependsOn: [UserManagement]
// aggregateRoots:
//   name: task
//   commands:
//     name: finish
//     intention: Finish the task
//     policies:
//       name: task_finished_policy
//       expectation: Task must be in progress
//       enforcement: throw TaskNotInProgressException
//       events:
//     name: task_finished
//     payload:
//       name
//       task_id
// applicationServices:
//   name: TaskAssignment
//   dependencies:
//     TaskRepository
//     UserRepository
//   commands:
//     name: assign
//     intention: Assign a task to a user
//     events:
//       name: task_assigned
//       payload:
//         task_id
//         user_id
// ''';
