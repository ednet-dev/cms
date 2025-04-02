import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test user implementation of SecuritySubject for testing
class TestUser implements SecuritySubject {
  final String id;
  final String name;
  @override
  final List<Role> roles;
  
  TestUser(this.id, this.name, this.roles);
  
  @override
  String toString() => 'TestUser($id, $name)';
}

/// Test entity for authorization testing
class TestTask extends Entity<TestTask> with AuthorizationFor<TestUser, TestTask> {
  String? title;
  String? description;
  String? assigneeId;
  bool? isCompleted;
  String? sensitiveNotes;
  
  TestTask() {
    concept = TestConcept();
  }
  
  @override
  IEntities<IPolicy> get accessPolicies {
    final policies = Entities<IPolicy>();
    
    // Owner can do anything
    if (assigneeId != null) {
      policies.add(OwnerPolicy<TestUser>(ownerId: assigneeId!));
    }
    
    // Anyone with 'Task:read' can view basic task info
    policies.add(CommandPolicy<TestUser>(allowedCommands: ['ReadTask']));
    
    return policies;
  }
}

/// Test concept for the TestTask entity
class TestConcept extends Concept {
  TestConcept() : super() {
    code = 'Task';
    attributes.add(StringAttribute('title', required: true));
    attributes.add(StringAttribute('description'));
    attributes.add(StringAttribute('assigneeId'));
    attributes.add(BooleanAttribute('isCompleted'));
    attributes.add(StringAttribute('sensitiveNotes', sensitive: true));
  }
}

/// StringAttribute for testing
class StringAttribute extends Attribute {
  StringAttribute(String code, {bool required = false, bool sensitive = false}) : super() {
    this.code = code;
    this.required = required;
    this.sensitive = sensitive;
  }
}

/// BooleanAttribute for testing
class BooleanAttribute extends Attribute {
  BooleanAttribute(String code, {bool required = false}) : super() {
    this.code = code;
    this.required = required;
  }
}

/// Test repository implementation
class TestTaskRepository implements Repository<TestTask> {
  final List<TestTask> _tasks = [];
  
  @override
  Future<void> add(TestTask entity) async {
    _tasks.add(entity);
  }
  
  @override
  Future<int> count() async => _tasks.length;
  
  @override
  Future<int> countByCriteria(Criteria<TestTask> criteria) async => _tasks.length;
  
  @override
  Future<void> delete(TestTask entity) async {
    _tasks.remove(entity);
  }
  
  @override
  Future<List<TestTask>> findAll({int? skip, int? take}) async => _tasks;
  
  @override
  Future<List<TestTask>> findByCriteria(Criteria<TestTask> criteria, {int? skip, int? take}) async => _tasks;
  
  @override
  Future<TestTask?> findById(dynamic id) async => _tasks.firstWhere((t) => t.id.toString() == id.toString(), orElse: () => null as TestTask);
  
  @override
  Future<void> update(TestTask entity) async {
    // Not needed for this test
  }
}

/// Test command for testing authorization
class CreateTaskCommand extends Command {
  final String title;
  final String? description;
  final String? assigneeId;
  
  CreateTaskCommand({
    required this.title,
    this.description,
    this.assigneeId,
  }) : super(name: 'CreateTask');
  
  @override
  bool doIt() {
    // In a real command, this would create a task
    return true;
  }
}

/// Test command for reading tasks
class ReadTaskCommand extends Command {
  final String taskId;
  
  ReadTaskCommand({required this.taskId}) : super(name: 'ReadTask');
  
  @override
  bool doIt() {
    // In a real command, this would read a task
    return true;
  }
}

/// Test query for testing query authorization
class FindTasksQuery extends Query {
  final bool? isCompleted;
  
  FindTasksQuery({this.isCompleted}) : super('FindTasks');
  
  @override
  Map<String, dynamic> getParameters() => {
    if (isCompleted != null) 'isCompleted': isCompleted,
  };
}

/// Secure application service for testing
class SecureTaskService extends SecureApplicationService<TestTask> {
  SecureTaskService(Repository<TestTask> repository)
      : super(repository, name: 'TaskService');
      
  @override
  List<Permission> getPermissionsForCommand(ICommand command) {
    if (command is CreateTaskCommand) {
      return [Permission('Task', 'create')];
    } else if (command is ReadTaskCommand) {
      return [Permission('Task', 'read')];
    }
    return super.getPermissionsForCommand(command);
  }
  
  @override
  bool hasReadPermissionForEntity(TestTask entity, String resourceName) {
    // Only allow reading completed tasks for users without specific permissions
    if (!SecurityContext.hasPermission(Permission('Task', 'read_all'))) {
      return entity.isCompleted == true || 
             SecurityContext.getCurrentSubject() is TestUser && 
             (entity.assigneeId == (SecurityContext.getCurrentSubject() as TestUser).id);
    }
    return true;
  }
}

void main() {
  group('Entitlement System Tests', () {
    // Test Permission class
    group('Permission Tests', () {
      test('Basic Permission Creation', () {
        final permission = Permission('Task', 'read');
        expect(permission.resource, equals('Task'));
        expect(permission.operation, equals('read'));
        expect(permission.toString(), equals('Task:read'));
      });
      
      test('Permission From String', () {
        final permission = Permission.fromString('Task:write');
        expect(permission.resource, equals('Task'));
        expect(permission.operation, equals('write'));
      });
      
      test('Permission Equality', () {
        final permission1 = Permission('Task', 'read');
        final permission2 = Permission('Task', 'read');
        final permission3 = Permission('Task', 'write');
        
        expect(permission1, equals(permission2));
        expect(permission1.hashCode, equals(permission2.hashCode));
        expect(permission1, isNot(equals(permission3)));
      });
      
      test('Permission Wildcards', () {
        final wildcardAll = Permission('*', '*');
        final wildcardResource = Permission('*', 'read');
        final wildcardOperation = Permission('Task', '*');
        final specific = Permission('Task', 'read');
        
        expect(wildcardAll.implies(specific), isTrue);
        expect(wildcardResource.implies(specific), isTrue);
        expect(wildcardOperation.implies(specific), isTrue);
        expect(specific.implies(wildcardAll), isFalse);
      });
      
      test('Hierarchical Permissions', () {
        final hierarchical = Permission('Project.*', 'read');
        final specific = Permission('Project.Task', 'read');
        
        expect(hierarchical.implies(specific), isTrue);
        expect(specific.implies(hierarchical), isFalse);
      });
    });
    
    // Test Role class
    group('Role Tests', () {
      test('Role Creation', () {
        final adminRole = Role('admin', [
          Permission('*', '*'),
        ]);
        
        expect(adminRole.name, equals('admin'));
        expect(adminRole.permissions.length, equals(1));
      });
      
      test('Role Permission Checking', () {
        final userRole = Role('user', [
          Permission('Task', 'read'),
          Permission('Task', 'create'),
        ]);
        
        expect(userRole.hasPermission(Permission('Task', 'read')), isTrue);
        expect(userRole.hasPermission(Permission('Task', 'delete')), isFalse);
        expect(userRole.hasPermissionString('Task:create'), isTrue);
      });
    });
    
    // Test Security Subject and Context
    group('SecuritySubject and Context Tests', () {
      late TestUser adminUser;
      late TestUser regularUser;
      late TestUser guestUser;
      
      setUp(() {
        adminRole = Role('admin', [Permission('*', '*')]);
        userRole = Role('user', [
          Permission('Task', 'read'),
          Permission('Task', 'create'),
        ]);
        guestRole = Role('guest', [Permission('Task', 'read')]);
        
        adminUser = TestUser('1', 'Admin', [adminRole]);
        regularUser = TestUser('2', 'Regular', [userRole]);
        guestUser = TestUser('3', 'Guest', [guestRole]);
        
        // Clear the security context
        SecurityContext.clear();
      });
      
      late Role adminRole;
      late Role userRole;
      late Role guestRole;
      
      test('SecuritySubject Permission Checking', () {
        expect(adminUser.hasPermission(Permission('Task', 'delete')), isTrue);
        expect(regularUser.hasPermission(Permission('Task', 'read')), isTrue);
        expect(regularUser.hasPermission(Permission('Task', 'delete')), isFalse);
        expect(guestUser.hasPermissionString('Task:read'), isTrue);
      });
      
      test('SecurityContext Basic Usage', () {
        SecurityContext.setCurrentSubject(regularUser);
        expect(SecurityContext.getCurrentSubject(), equals(regularUser));
        expect(SecurityContext.hasPermission(Permission('Task', 'read')), isTrue);
        expect(SecurityContext.hasPermission(Permission('Task', 'delete')), isFalse);
      });
      
      test('SecurityContext System Privileges', () {
        SecurityContext.setCurrentSubject(guestUser);
        expect(SecurityContext.hasPermission(Permission('Task', 'delete')), isFalse);
        
        final result = SecurityContext.runWithSystemPrivileges(() {
          return SecurityContext.hasPermission(Permission('Task', 'delete'));
        });
        
        expect(result, isTrue);
        expect(SecurityContext.getCurrentSubject(), equals(guestUser));
      });
      
      test('SecurityContext Field Access', () {
        SecurityContext.setCurrentSubject(regularUser);
        
        final checkField = SecurityContext.createFieldAccessChecker('Task', 'read');
        expect(checkField('title'), isTrue);
        
        SecurityContext.setCurrentSubject(guestUser);
        expect(checkField('title'), isTrue);
      });
    });
    
    // Test Entity with Authorization
    group('Authorizable Entity Tests', () {
      late TestUser owner;
      late TestUser otherUser;
      late TestTask task;
      
      setUp(() {
        ownerRole = Role('user', [Permission('Task', 'read'), Permission('Task', 'update')]);
        otherRole = Role('user', [Permission('Task', 'read')]);
        
        owner = TestUser('1', 'Owner', [ownerRole]);
        otherUser = TestUser('2', 'Other', [otherRole]);
        
        task = TestTask()
          ..title = 'Test Task'
          ..description = 'Test Description'
          ..assigneeId = '1'
          ..isCompleted = false;
      });
      
      late Role ownerRole;
      late Role otherRole;
      
      test('Owner Authorization', () {
        expect(task.isAuthorized(ReadTaskCommand(taskId: '1'), owner), isTrue);
      });
      
      test('Non-Owner Authorization for Read', () {
        expect(task.isAuthorized(ReadTaskCommand(taskId: '1'), otherUser), isTrue);
      });
    });
    
    // Test Secure Application Service
    group('Secure Application Service Tests', () {
      late TestUser adminUser;
      late TestUser regularUser;
      late TestUser guestUser;
      late SecureTaskService taskService;
      late TestTaskRepository repository;
      
      setUp(() {
        adminRole = Role('admin', [Permission('*', '*')]);
        userRole = Role('user', [
          Permission('Task', 'read'),
          Permission('Task', 'create'),
        ]);
        guestRole = Role('guest', [Permission('Task', 'read')]);
        
        adminUser = TestUser('1', 'Admin', [adminRole]);
        regularUser = TestUser('2', 'Regular', [userRole]);
        guestUser = TestUser('3', 'Guest', [guestRole]);
        
        repository = TestTaskRepository();
        taskService = SecureTaskService(repository);
        
        // Add some test tasks
        task1 = TestTask()
          ..title = 'Complete Task'
          ..isCompleted = true;
        
        task2 = TestTask()
          ..title = 'Assigned Task'
          ..assigneeId = '2'
          ..isCompleted = false;
        
        task3 = TestTask()
          ..title = 'Incomplete Task'
          ..isCompleted = false;
        
        repository.add(task1);
        repository.add(task2);
        repository.add(task3);
        
        // Clear the security context
        SecurityContext.clear();
      });
      
      late Role adminRole;
      late Role userRole;
      late Role guestRole;
      late TestTask task1;
      late TestTask task2;
      late TestTask task3;
      
      test('Command Authorization - Allow', () async {
        SecurityContext.setCurrentSubject(regularUser);
        
        final command = CreateTaskCommand(
          title: 'New Task',
          description: 'Task Description',
        );
        
        final result = await taskService.executeCommand(command);
        expect(result.isSuccess, isTrue);
      });
      
      test('Command Authorization - Deny', () async {
        SecurityContext.setCurrentSubject(guestUser);
        
        final command = CreateTaskCommand(
          title: 'New Task',
          description: 'Task Description',
        );
        
        final result = await taskService.executeCommand(command);
        expect(result.isSuccess, isFalse);
      });
      
      test('Result Filtering - Regular User', () async {
        SecurityContext.setCurrentSubject(regularUser);
        
        final query = FindTasksQuery();
        final result = await taskService.executeQuery(query);
        
        expect(result.isSuccess, isTrue);
        expect((result.data as List).length, equals(2)); // Should only see completed tasks and their own tasks
      });
      
      test('Result Filtering - Admin User', () async {
        SecurityContext.setCurrentSubject(adminUser);
        
        final query = FindTasksQuery();
        final result = await taskService.executeQuery(query);
        
        expect(result.isSuccess, isTrue);
        expect((result.data as List).length, equals(3)); // Should see all tasks
      });
    });
    
    // Test Configuration and Manager
    group('EntitlementConfiguration and SecurityManager Tests', () {
      late EntitlementConfiguration config;
      
      setUp(() {
        config = EntitlementConfiguration()
          ..addRole('admin', [Permission('*', '*')])
          ..addRole('user', [
            Permission('Task', 'read'),
            Permission('Task', 'create'),
          ])
          ..addRole('guest', [Permission('Task', 'read')])
          ..setResourceParent('Project.Task', 'Project')
          ..setFieldAccess('Task', FieldAccessConfiguration()
            ..setPublicFields(['title', 'description', 'isCompleted'])
            ..setProtectedFields(['assigneeId'], 'Task:read_all')
            ..setPrivateFields(['sensitiveNotes']));
        
        SecurityManager.applyConfiguration(config);
      });
      
      test('Configuration Setup', () {
        expect(config.getRoles().length, equals(3));
        expect(config.getResourceParent('Project.Task'), equals('Project'));
        expect(config.getFieldAccess('Task'), isNotNull);
      });
      
      test('Operation Aliases', () {
        expect(config.resolveOperation('view'), equals('read'));
        expect(config.resolveOperation('modify'), equals('update'));
      });
      
      test('SecurityManager Permission Checking', () {
        SecurityContext.setCurrentSubject(TestUser('1', 'Admin', [
          config.getRole('admin')!,
        ]));
        
        expect(SecurityManager.hasResourcePermission('Task', 'delete'), isTrue);
        expect(SecurityManager.hasResourcePermission('Task', 'view'), isTrue); // Using alias
      });
      
      test('Field Access Control', () {
        SecurityContext.setCurrentSubject(TestUser('1', 'User', [
          config.getRole('user')!,
        ]));
        
        expect(SecurityManager.isFieldAccessible('Task', 'title'), isTrue);
        expect(SecurityManager.isFieldAccessible('Task', 'assigneeId'), isFalse);
        expect(SecurityManager.isFieldAccessible('Task', 'sensitiveNotes'), isFalse);
        
        SecurityContext.setCurrentSubject(TestUser('1', 'Admin', [
          config.getRole('admin')!,
        ]));
        
        expect(SecurityManager.isFieldAccessible('Task', 'assigneeId'), isTrue);
        expect(SecurityManager.isFieldAccessible('Task', 'sensitiveNotes'), isTrue);
      });
    });
    
    // Test Attribute-based Authorization
    group('Attribute-based Authorization Tests', () {
      setUp(() {
        AuthorizationAttributeHandler.registerType('OrderService', [
          RequirePermission('Order', 'read'),
        ]);
        
        AuthorizationAttributeHandler.registerMethod('OrderService.createOrder', [
          RequirePermission('Order', 'create'),
        ]);
        
        AuthorizationAttributeHandler.registerMethod('OrderService.getPublicOrders', [
          AllowAnonymous(),
        ]);
      });
      
      test('Type-level Authorization', () {
        SecurityContext.setCurrentSubject(TestUser('1', 'User', [
          Role('user', [Permission('Order', 'read')]),
        ]));
        
        expect(
          AuthorizationAttributeHandler.isAuthorized('OrderService.someMethod', 'Order', 'read'),
          isTrue,
        );
      });
      
      test('Method-level Authorization', () {
        SecurityContext.setCurrentSubject(TestUser('1', 'User', [
          Role('user', [Permission('Order', 'read')]),
        ]));
        
        expect(
          AuthorizationAttributeHandler.isAuthorized('OrderService.createOrder', 'Order', 'create'),
          isFalse,
        );
        
        SecurityContext.setCurrentSubject(TestUser('1', 'Admin', [
          Role('admin', [Permission('Order', 'create')]),
        ]));
        
        expect(
          AuthorizationAttributeHandler.isAuthorized('OrderService.createOrder', 'Order', 'create'),
          isTrue,
        );
      });
      
      test('AllowAnonymous Attribute', () {
        // Clear the security context
        SecurityContext.clear();
        
        expect(
          AuthorizationAttributeHandler.isAuthorized('OrderService.getPublicOrders', 'Order', 'read'),
          isTrue,
        );
      });
    });
  });
} 