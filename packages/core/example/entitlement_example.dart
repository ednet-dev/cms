// import 'package:ednet_core/ednet_core.dart';
//
// /// This example demonstrates how to use the EDNet Core entitlement system
// /// in a real-world application. It shows:
// /// - Setting up roles and permissions
// /// - Creating secure application services
// /// - Applying field-level access control
// /// - Using entity-level authorization policies
// /// - Integrating with your domain model
//
// /// ===== DOMAIN MODEL =====
//
// /// Product entity with authorization support
// class Product extends Entity<Product> with AuthorizationFor<User, Product> {
//   String? name;
//   double? price;
//   bool? isPublished;
//   String? ownerId;
//   String? internalNotes; // Sensitive field
//
//   Product() {
//     concept = ProductConcept();
//   }
//
//   @override
//   IEntities<IPolicy> get accessPolicies {
//     final policies = Entities<IPolicy>();
//
//     // Owner can do anything with their product
//     if (ownerId != null) {
//       policies.add(OwnerPolicy<User>(ownerId: ownerId!));
//     }
//
//     // Published products can be viewed by anyone with 'Product:read'
//     if (isPublished == true) {
//       policies.add(CommandPolicy<User>(
//         allowedCommands: ['ViewProduct'],
//         requiredPermissions: ['Product:read'],
//       ));
//     }
//
//     // Only allow editing published products if user has 'Product:publish'
//     policies.add(AttributePolicy<User>(
//       attributeName: 'isPublished',
//       attributeValue: true,
//       allowedCommands: ['UpdateProduct'],
//       requiredPermissions: ['Product:publish'],
//     ));
//
//     return policies;
//   }
// }
//
// /// Product concept definition
// class ProductConcept extends Concept {
//   ProductConcept() : super() {
//     code = 'Product';
//     attributes.add(StringAttribute('name', required: true));
//     attributes.add(DoubleAttribute('price'));
//     attributes.add(BooleanAttribute('isPublished'));
//     attributes.add(StringAttribute('ownerId'));
//     attributes.add(StringAttribute('internalNotes', sensitive: true));
//   }
// }
//
// /// Simple double attribute
// class DoubleAttribute extends Attribute {
//   DoubleAttribute(String code, {bool required = false}) : super() {
//     this.code = code;
//     this.required = required;
//   }
// }
//
// /// Simple boolean attribute
// class BooleanAttribute extends Attribute {
//   BooleanAttribute(String code, {bool required = false}) : super() {
//     this.code = code;
//     this.required = required;
//   }
// }
//
// /// Simple string attribute
// class StringAttribute extends Attribute {
//   StringAttribute(String code, {bool required = false, bool sensitive = false}) : super() {
//     this.code = code;
//     this.required = required;
//     this.sensitive = sensitive;
//   }
// }
//
// /// ===== SECURITY MODEL =====
//
// /// User implementing SecuritySubject
// class User implements SecuritySubject {
//   final String id;
//   final String username;
//   @override
//   final List<Role> roles;
//
//   User(this.id, this.username, this.roles);
//
//   @override
//   String toString() => 'User($id, $username)';
// }
//
// /// ===== COMMANDS AND QUERIES =====
//
// /// Command to create a product
// class CreateProductCommand extends Command {
//   final String name;
//   final double price;
//   final bool isPublished;
//   final String ownerId;
//
//   CreateProductCommand({
//     required this.name,
//     required this.price,
//     this.isPublished = false,
//     required this.ownerId,
//   }) : super(name: 'CreateProduct');
//
//   @override
//   bool doIt() {
//     // In a real application, this would create the product
//     return true;
//   }
// }
//
// /// Command to view a product
// class ViewProductCommand extends Command {
//   final String productId;
//
//   ViewProductCommand({required this.productId}) : super(name: 'ViewProduct');
//
//   @override
//   bool doIt() {
//     // In a real application, this would read the product
//     return true;
//   }
// }
//
// /// Command to update a product
// class UpdateProductCommand extends Command {
//   final String productId;
//   final String? name;
//   final double? price;
//   final bool? isPublished;
//
//   UpdateProductCommand({
//     required this.productId,
//     this.name,
//     this.price,
//     this.isPublished,
//   }) : super(name: 'UpdateProduct');
//
//   @override
//   bool doIt() {
//     // In a real application, this would update the product
//     return true;
//   }
// }
//
// /// Query to find products
// class FindProductsQuery extends Query {
//   final bool? isPublished;
//   final String? ownerId;
//
//   FindProductsQuery({this.isPublished, this.ownerId}) : super('FindProducts');
//
//   @override
//   Map<String, dynamic> getParameters() => {
//     if (isPublished != null) 'isPublished': isPublished,
//     if (ownerId != null) 'ownerId': ownerId,
//   };
// }
//
// /// ===== APPLICATION SERVICES =====
//
// /// Secure product application service
// class SecureProductService extends SecureApplicationService<Product> {
//   SecureProductService(Repository<Product> repository)
//       : super(repository, name: 'ProductService');
//
//   @override
//   List<Permission> getPermissionsForCommand(ICommand command) {
//     if (command is CreateProductCommand) {
//       return [Permission('Product', 'create')];
//     } else if (command is ViewProductCommand) {
//       return [Permission('Product', 'read')];
//     } else if (command is UpdateProductCommand) {
//       final permissions = [Permission('Product', 'update')];
//       if (command.isPublished != null && command.isPublished == true) {
//         permissions.add(Permission('Product', 'publish'));
//       }
//       return permissions;
//     }
//     return super.getPermissionsForCommand(command);
//   }
//
//   @override
//   bool hasReadPermissionForEntity(Product entity, String resourceName) {
//     // Users can always view their own products
//     if (SecurityContext.getCurrentSubject() is User &&
//         entity.ownerId == (SecurityContext.getCurrentSubject() as User).id) {
//       return true;
//     }
//
//     // Regular users can only view published products
//     if (!SecurityContext.hasPermission(Permission('Product', 'read_all'))) {
//       return entity.isPublished == true;
//     }
//
//     // Users with read_all permission can view all products
//     return true;
//   }
//
//   /// Creates a new product
//   Future<CommandResult> createProduct(CreateProductCommand command) async {
//     return executeCommand(command);
//   }
//
//   /// Updates a product
//   Future<CommandResult> updateProduct(UpdateProductCommand command) async {
//     return executeCommand(command);
//   }
//
//   /// Finds products based on criteria
//   Future<QueryResult> findProducts(FindProductsQuery query) async {
//     return executeQuery(query);
//   }
// }
//
// /// ===== REPOSITORY =====
//
// /// In-memory product repository for example purposes
// class InMemoryProductRepository implements Repository<Product> {
//   final List<Product> _products = [];
//
//   @override
//   Future<void> add(Product entity) async {
//     _products.add(entity);
//   }
//
//   @override
//   Future<int> count() async => _products.length;
//
//   @override
//   Future<int> countByCriteria(Criteria<Product> criteria) async {
//     return (await findByCriteria(criteria)).length;
//   }
//
//   @override
//   Future<void> delete(Product entity) async {
//     _products.remove(entity);
//   }
//
//   @override
//   Future<List<Product>> findAll({int? skip, int? take}) async => _products;
//
//   @override
//   Future<List<Product>> findByCriteria(Criteria<Product> criteria, {int? skip, int? take}) async {
//     // Simple implementation for example
//     if (criteria is FilterCriteria<Product>) {
//       final Map<String, dynamic> params = criteria.filter;
//       return _products.where((p) {
//         bool match = true;
//         if (params.containsKey('isPublished')) {
//           match = match && p.isPublished == params['isPublished'];
//         }
//         if (params.containsKey('ownerId')) {
//           match = match && p.ownerId == params['ownerId'];
//         }
//         return match;
//       }).toList();
//     }
//     return _products;
//   }
//
//   @override
//   Future<Product?> findById(dynamic id) async {
//     try {
//       return _products.firstWhere((p) => p.id.toString() == id.toString());
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Future<void> update(Product entity) async {
//     final index = _products.indexWhere((p) => p.id == entity.id);
//     if (index >= 0) {
//       _products[index] = entity;
//     }
//   }
// }
//
// /// ===== MAIN EXAMPLE =====
//
// Future<void> main() async {
//   // Set up roles and permissions
//   final adminRole = Role('admin', [Permission('*', '*')]);
//   final sellerRole = Role('seller', [
//     Permission('Product', 'create'),
//     Permission('Product', 'read'),
//     Permission('Product', 'update'),
//   ]);
//   final editorRole = Role('editor', [
//     Permission('Product', 'read'),
//     Permission('Product', 'update'),
//     Permission('Product', 'publish'),
//   ]);
//   final customerRole = Role('customer', [Permission('Product', 'read')]);
//
//   // Create users
//   final adminUser = User('1', 'admin', [adminRole]);
//   final sellerUser = User('2', 'seller', [sellerRole]);
//   final editorUser = User('3', 'editor', [editorRole]);
//   final customerUser = User('4', 'customer', [customerRole]);
//
//   // Configure entitlement system
//   final config = EntitlementConfiguration()
//     ..addRole('admin', adminRole.permissions)
//     ..addRole('seller', sellerRole.permissions)
//     ..addRole('editor', editorRole.permissions)
//     ..addRole('customer', customerRole.permissions)
//     ..setFieldAccess('Product', FieldAccessConfiguration()
//       ..setPublicFields(['name', 'price', 'isPublished'])
//       ..setProtectedFields(['ownerId'], 'Product:read_all')
//       ..setPrivateFields(['internalNotes']));
//
//   SecurityManager.applyConfiguration(config);
//
//   // Create repository and service
//   final repository = InMemoryProductRepository();
//   final productService = SecureProductService(repository);
//
//   // Add some products
//   final sellerProduct1 = Product()
//     ..name = 'Seller Product 1'
//     ..price = 10.0
//     ..isPublished = true
//     ..ownerId = '2'
//     ..internalNotes = 'This is a great product';
//
//   final sellerProduct2 = Product()
//     ..name = 'Seller Product 2'
//     ..price = 20.0
//     ..isPublished = false
//     ..ownerId = '2'
//     ..internalNotes = 'Needs better description';
//
//   await repository.add(sellerProduct1);
//   await repository.add(sellerProduct2);
//
//   // Example 1: Seller creates a product
//   print('Example 1: Seller creates a product');
//   SecurityContext.setCurrentSubject(sellerUser);
//
//   final createCommand = CreateProductCommand(
//     name: 'New Product',
//     price: 15.0,
//     ownerId: sellerUser.id,
//   );
//
//   final createResult = await productService.createProduct(createCommand);
//   print('  Result: ${createResult.isSuccess}');
//
//   // Example 2: Customer tries to create a product (should fail)
//   print('\nExample 2: Customer tries to create a product');
//   SecurityContext.setCurrentSubject(customerUser);
//
//   final unauthorizedCreateCommand = CreateProductCommand(
//     name: 'Customer Product',
//     price: 5.0,
//     ownerId: customerUser.id,
//   );
//
//   final unauthorizedResult = await productService.createProduct(unauthorizedCreateCommand);
//   print('  Result: ${unauthorizedResult.isSuccess}');
//   print('  Error: ${unauthorizedResult.errorMessage}');
//
//   // Example 3: Customer queries products (should only see published)
//   print('\nExample 3: Customer queries products');
//   SecurityContext.setCurrentSubject(customerUser);
//
//   final customerQuery = FindProductsQuery();
//   final customerResult = await productService.findProducts(customerQuery);
//   print('  Number of visible products: ${(customerResult.data as List).length}');
//   print('  Products: ${(customerResult.data as List).map((p) => p.name).join(', ')}');
//
//   // Example 4: Seller queries products (should see own products)
//   print('\nExample 4: Seller queries products');
//   SecurityContext.setCurrentSubject(sellerUser);
//
//   final sellerQuery = FindProductsQuery();
//   final sellerResult = await productService.findProducts(sellerQuery);
//   print('  Number of visible products: ${(sellerResult.data as List).length}');
//   print('  Products: ${(sellerResult.data as List).map((p) => p.name).join(', ')}');
//
//   // Example 5: Editor updates a product's published status (should succeed)
//   print('\nExample 5: Editor updates a product\'s published status');
//   SecurityContext.setCurrentSubject(editorUser);
//
//   final updateCommand = UpdateProductCommand(
//     productId: sellerProduct2.id.toString(),
//     isPublished: true,
//   );
//
//   final updateResult = await productService.updateProduct(updateCommand);
//   print('  Result: ${updateResult.isSuccess}');
//
//   // Example 6: Seller tries to update published status (should fail)
//   print('\nExample 6: Seller tries to update published status');
//   SecurityContext.setCurrentSubject(sellerUser);
//
//   final unauthorizedUpdateCommand = UpdateProductCommand(
//     productId: sellerProduct1.id.toString(),
//     isPublished: false,
//   );
//
//   final unauthorizedUpdateResult = await productService.updateProduct(unauthorizedUpdateCommand);
//   print('  Result: ${unauthorizedUpdateResult.isSuccess}');
//   print('  Error: ${unauthorizedUpdateResult.errorMessage}');
//
//   // Example 7: Admin can see all fields including sensitive data
//   print('\nExample 7: Admin can see sensitive fields');
//   SecurityContext.setCurrentSubject(adminUser);
//
//   final adminQuery = FindProductsQuery();
//   final products = (await productService.findProducts(adminQuery)).data as List<Product>;
//
//   for (var product in products) {
//     print('  Product: ${product.name}');
//     print('    Price: ${product.price}');
//     print('    Published: ${product.isPublished}');
//     print('    Owner ID: ${product.ownerId}');
//     print('    Internal Notes: ${product.internalNotes}');
//   }
//
//   // Example 8: Customer can't see sensitive fields
//   print('\nExample 8: Customer can\'t see sensitive fields');
//   SecurityContext.setCurrentSubject(customerUser);
//
//   final visibleProducts = (await productService.findProducts(FindProductsQuery())).data as List<Product>;
//
//   for (var product in visibleProducts) {
//     print('  Product: ${product.name}');
//     print('    Price: ${product.price}');
//     print('    Published: ${product.isPublished}');
//     print('    Owner ID: ${product.ownerId}'); // Will be null due to field-level security
//     print('    Internal Notes: ${product.internalNotes}'); // Will be null due to field-level security
//   }
// }