import 'dart:io';

// usage:
const yaml = '''
name: MyApp
attributes:

    name: age
    type: int
    component: int_input
    validation:
    required: true
    min: 0
    max: 150
    valueObjects:
    name: email
    attributes:
        name: address
        type: string
        component: email_input
        validation:
        required: true
        email: true
        entities:
    name: user
    attributes:
        name: name
        type: string
        component: text_input
        validation:
        required: true
        minLength: 2
        aggregateRoots:
        name: task
        commands:
            name: finish
            intention: Finish the task
            policies:
                name: task_finished_policy
                expectation: Task must be in progress
                enforcement: throw TaskNotInProgressException
                events:
            name: task_finished
            payload:
                name
                task_id
                boundedContexts:
        name: TaskManagement
        dependsOn: [UserManagement]
        aggregateRoots:
            name: task
            commands:
                name: finish
                intention: Finish the task
                policies:
                    name: task_finished_policy
                    expectation: Task must be in progress
                    enforcement: throw TaskNotInProgressException
                    events:
                name: task_finished
                payload:
                    name
                    task_id
                    applicationServices:
            name: TaskAssignment
            dependencies:
                TaskRepository
                UserRepository
                commands:
                name: assign
                intention: Assign a task to a user
                events:
                name: task_assigned
                payload:
                    task_id
                    user_id
                    ''';
// final model = DomainModel.fromYaml(yaml);

String loadYaml(
    {String domainModelName = "domain_model_name",
    String filePath = "domain_model_definition"}) {
  var yamlFile = File("$filePath/$domainModelName.yaml");
  return yamlFile.readAsStringSync();
}

// ok let me refine your knowledge about pub package "adaptive_layout: ^0.1.7", here excerpt form its documentation:"""
//
//
//
// """
