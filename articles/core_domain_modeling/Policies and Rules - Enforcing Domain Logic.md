# Policies and Rules: Enforcing Domain Logic

Domain models must enforce business rules to maintain consistency and validity. In EDNet Core, this enforcement is implemented through a robust policy system that allows you to define, evaluate, and enforce business rules at various levels of your domain model.

## The Challenge of Domain Logic

Business rules in domain models can be complex and multifaceted:

- **Attribute validation**: Ensuring individual values meet requirements
- **Entity validation**: Enforcing invariants across multiple attributes
- **Relationship validation**: Ensuring valid connections between entities
- **Aggregate validation**: Maintaining consistency across entity graphs
- **Cross-entity rules**: Enforcing rules that span multiple entities

Traditional approaches often scatter these rules throughout the codebase, making them difficult to maintain, test, and evolve. EDNet Core addresses this with a unified policy system.

## EDNet Core's Policy Framework

The policy system in EDNet Core provides a structured approach to defining and enforcing business rules:

```dart
abstract class IPolicy {
  /// Gets the unique name of this policy.
  String get name;

  /// Gets a human-readable description of what this policy enforces.
  String get description;

  /// Gets the scope at which this policy should be evaluated.
  /// If null, the policy can be evaluated at any scope.
  PolicyScope? get scope;

  /// Evaluates this policy against the given entity.
  bool evaluate(Entity entity);

  /// Evaluates this policy with detailed results.
  PolicyEvaluationResult evaluateWithDetails(Entity entity);
}
```

This architecture enables you to define policies as first-class citizens in your domain model, with their own identity, purpose, and evaluation logic.

## Policy Types

EDNet Core provides several implementations of the `IPolicy` interface to handle different types of business rules:

### 1. Simple Policies

The basic `Policy` class allows you to create policies using a function:

```dart
final minimumOrderAmountPolicy = Policy(
  'MinimumOrderAmount',
  'Orders must have a total amount of at least \$10',
  (entity) {
    if (entity is Order) {
      return entity.total >= 10.0;
    }
    return true;  // Policy doesn't apply to non-Order entities
  },
  scope: PolicyScope.entity
);
```

This approach is ideal for simple rules that can be expressed as a single condition.

### 2. Expression-Based Policies

For more complex rules, EDNet Core offers `PolicyWithDependencies` that uses expressions:

```dart
final validInventoryPolicy = PolicyWithDependencies(
  'ValidInventory',
  'Products must have a quantity greater than zero',
  'quantity > 0',
  {'quantity'},
  scope: PolicyScope.attribute
);
```

This approach is powerful for rules that can be expressed as formulas or conditions.

### 3. Attribute Policies

The `AttributePolicy` class specializes in validating individual attributes:

```dart
final emailFormatPolicy = AttributePolicy(
  'EmailFormat',
  'Email must be in a valid format',
  'email',
  (value) => value == null || RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.toString())
);
```

Attribute policies are efficient for field-level validations.

### 4. Composite Policies

The `CompositePolicy` class allows you to combine multiple policies using logical operators:

```dart
final customerValidationPolicy = CompositePolicy(
  'CustomerValidation',
  'Comprehensive customer validation',
  [
    emailFormatPolicy,
    nameRequiredPolicy,
    validAddressPolicy
  ],
  CompositeOperator.and  // All policies must pass
);
```

This approach helps in organizing complex rule sets.

### 5. Time-Based Policies

The `TimeBasedPolicy` class allows for rules that depend on timing:

```dart
final promotionAvailabilityPolicy = TimeBasedPolicy(
  'PromotionAvailability',
  'Promotion must be within its valid date range',
  (entity, currentTime) {
    if (entity is Promotion) {
      return entity.startDate.isBefore(currentTime) && 
             entity.endDate.isAfter(currentTime);
    }
    return true;
  }
);

// Evaluating with the current time
bool isValid = promotionAvailabilityPolicy.evaluateAt(
  promotion, 
  DateTime.now()
);
```

This is useful for temporal rules like promotions, contracts, or scheduling.

## Defining Custom Policy Types

You can create custom policy types for specific domain needs:

```dart
class InventoryPolicy implements IPolicy {
  @override
  final String name;
  
  @override
  final String description;
  
  final double minimumStockThreshold;
  
  InventoryPolicy(this.name, this.description, this.minimumStockThreshold);
  
  @override
  bool evaluate(Entity entity) {
    if (entity is Product) {
      return entity.stockLevel >= minimumStockThreshold;
    }
    return true;
  }
  
  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    bool result = evaluate(entity);
    if (result) {
      return PolicyEvaluationResult(true, []);
    } else {
      return PolicyEvaluationResult(
        false,
        [
          PolicyViolation(
            name,
            'Stock level too low, minimum required: $minimumStockThreshold'
          )
        ]
      );
    }
  }
  
  @override
  PolicyScope? get scope => PolicyScope.entity;
}
```

## Policy Registration and Management

Policies are typically registered with a model:

```dart
// Create a model
var model = Model(domain, 'ShopModel');

// Register policies with the model
model.registerPolicy('MinimumOrderAmount', minimumOrderAmountPolicy);
model.registerPolicy('ValidInventory', validInventoryPolicy);
model.registerPolicy('CustomerValidation', customerValidationPolicy);

// Remove a policy if needed
model.removePolicy('MinimumOrderAmount');
```

The `PolicyRegistry` class manages policy registration and lookup:

```dart
// Create a policy registry
var registry = PolicyRegistry();

// Register policies
registry.registerPolicy('MinimumOrderAmount', minimumOrderAmountPolicy);
registry.registerPolicy('ValidInventory', validInventoryPolicy);

// Get a policy by key
var policy = registry.getPolicy('MinimumOrderAmount');

// Get all policies
var allPolicies = registry.getAllPolicies();
```

## Policy Evaluation

The `PolicyEvaluator` class handles policy evaluation:

```dart
// Create a policy evaluator
var evaluator = PolicyEvaluator(registry);

// Evaluate a specific policy
var result = evaluator.evaluate(entity, policyKey: 'MinimumOrderAmount');

// Evaluate all applicable policies
var allResults = evaluator.evaluate(entity);

// Check if evaluation succeeded
if (allResults.success) {
  // All policies passed
} else {
  // Handle violations
  for (var violation in allResults.violations) {
    print('${violation.policyName}: ${violation.message}');
  }
}
```

### Evaluation Results

Policy evaluation produces a `PolicyEvaluationResult` containing success status and any violations:

```dart
class PolicyEvaluationResult {
  final bool success;
  final List<PolicyViolation> violations;
  
  PolicyEvaluationResult(this.success, this.violations);
}

class PolicyViolation {
  final String policyName;
  final String message;
  
  PolicyViolation(this.policyName, this.message);
}
```

This structure provides detailed information about what policies were violated and why.

## Policy Scopes

Policies can operate at different scopes within your domain model:

```dart
enum PolicyScope {
  attribute,  // Applies to individual attributes
  entity,     // Applies to complete entities
  children,   // Applies to child collections
  parents,    // Applies to parent references
  model       // Applies at the model level
}
```

This scoping enables appropriate policy evaluation at different levels of granularity.

## Integration with Entity Framework

EDNet Core integrates policy evaluation with entity operations:

```dart
// Policies are evaluated when attributes are set
entity.setAttribute('price', -10.0);  // May throw PolicyViolationException

// Policies are evaluated when relationships are modified
entity.setParent('category', category);  // May throw PolicyViolationException

// Explicit policy evaluation
var policyResult = entity.evaluatePolicies();
if (!policyResult.success) {
  // Handle validation errors
}
```

When a policy violation is detected, EDNet Core throws a `PolicyViolationException`:

```dart
try {
  entity.setAttribute('price', -10.0);
} catch (e) {
  if (e is PolicyViolationException) {
    for (var violation in e.violations) {
      print('${violation.policyName}: ${violation.message}');
    }
  }
}
```

## Advanced Policy Patterns

### 1. Hierarchical Policies

Policies can be organized hierarchically to reflect domain structure:

```dart
// Base policy for all financial rules
final financialPolicy = CompositePolicy(
  'FinancialPolicy',
  'Base financial rules',
  [
    // Sub-policies for specific financial aspects
    pricingPolicy,
    taxPolicy,
    discountPolicy
  ],
  CompositeOperator.and
);
```

### 2. Conditional Policies

Policies can include conditional logic:

```dart
final shippingPolicy = Policy(
  'ShippingPolicy',
  'Orders over $100 qualify for free shipping',
  (entity) {
    if (entity is Order) {
      if (entity.total >= 100.0) {
        return entity.shippingCost == 0.0;
      } else {
        return entity.shippingCost > 0.0;
      }
    }
    return true;
  }
);
```

### 3. Context-Aware Policies

Policies can take contextual information into account:

```dart
class UserRolePolicy implements IPolicy {
  @override
  final String name = 'UserRolePolicy';
  
  @override
  final String description = 'Enforces user role access rules';
  
  bool evaluateWithContext(Entity entity, UserContext context) {
    if (entity is SecureResource) {
      return context.userRoles.contains(entity.minimumRequiredRole);
    }
    return true;
  }
  
  @override
  bool evaluate(Entity entity) {
    // Default implementation without context
    return true;
  }
  
  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }
  
  @override
  PolicyScope? get scope => PolicyScope.entity;
}
```

## Practical Example: E-Commerce Order Validation

Let's implement a comprehensive validation for an e-commerce order:

```dart
// Define individual policies
final minimumOrderAmountPolicy = Policy(
  'MinimumOrderAmount',
  'Orders must have a total amount of at least \$10',
  (entity) {
    if (entity is Order) {
      return entity.calculateTotal() >= 10.0;
    }
    return true;
  }
);

final orderLineQuantityPolicy = Policy(
  'OrderLineQuantity',
  'Order lines must have a quantity greater than zero',
  (entity) {
    if (entity is OrderLine) {
      return entity.quantity > 0;
    }
    return true;
  }
);

final deliveryAddressPolicy = Policy(
  'DeliveryAddress',
  'Orders must have a valid delivery address',
  (entity) {
    if (entity is Order) {
      return entity.deliveryAddress != null && 
             entity.deliveryAddress.isValid();
    }
    return true;
  }
);

final paymentMethodPolicy = Policy(
  'PaymentMethod',
  'Orders must have a valid payment method',
  (entity) {
    if (entity is Order) {
      return entity.paymentMethod != null;
    }
    return true;
  }
);

// Create a composite order validation policy
final orderValidationPolicy = CompositePolicy(
  'OrderValidation',
  'Comprehensive order validation',
  [
    minimumOrderAmountPolicy,
    deliveryAddressPolicy,
    paymentMethodPolicy
  ],
  CompositeOperator.and
);

// Register policies with the model
model.registerPolicy('OrderValidation', orderValidationPolicy);
model.registerPolicy('OrderLineQuantity', orderLineQuantityPolicy);

// Order implementation with policy validation
class Order extends Entity<Order> {
  // Properties and methods...
  
  bool validate() {
    // First validate the order itself
    var orderResult = evaluatePolicies(policyKey: 'OrderValidation');
    if (!orderResult.success) {
      return false;
    }
    
    // Then validate all order lines
    for (var line in lines) {
      var lineResult = line.evaluatePolicies(policyKey: 'OrderLineQuantity');
      if (!lineResult.success) {
        return false;
      }
    }
    
    return true;
  }
  
  bool submit() {
    if (!validate()) {
      return false;
    }
    
    // Process the order...
    return true;
  }
}
```

## Event-Triggered Policies

A powerful feature of EDNet Core is the ability to trigger policies based on domain events, enabling reactive business rules:

```dart
class LowStockNotificationPolicy implements IEventTriggeredPolicy {
  @override
  String get name => 'LowStockNotification';
  
  @override
  String get description => 'Notify when stock levels are low';
  
  @override
  bool evaluate(Entity entity) {
    return entity is Product;
  }
  
  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event.name == 'StockChanged';
  }
  
  @override
  void executeActions(dynamic entity, dynamic event) {
    final product = entity as Product;
    final newStock = event.data['newStock'] as int;
    
    if (newStock < product.reorderThreshold) {
      NotificationService.sendLowStockAlert(
        product.code,
        product.name,
        newStock,
        product.reorderThreshold
      );
    }
  }
  
  @override
  List<dynamic> generateCommands(dynamic entity, dynamic event) {
    final product = entity as Product;
    final newStock = event.data['newStock'] as int;
    
    if (newStock < product.reorderThreshold && !product.reorderPlaced) {
      return [CreatePurchaseOrderCommand(product)];
    }
    return [];
  }
}
```

This pattern integrates with the command-event-policy cycle we'll explore in more detail in a later article.

## Performance Considerations

While policies provide excellent separation of concerns and maintainability, they can impact performance if not used judiciously:

1. **Granularity**: Use the appropriate policy scope to avoid unnecessary evaluations
2. **Optimization**: For frequently evaluated policies, consider caching or optimized implementations
3. **Evaluation Strategy**: Evaluate policies only when needed, not on every operation
4. **Batch Validation**: For bulk operations, consider batch validation approaches

## Conclusion

EDNet Core's policy system provides a powerful and flexible way to enforce domain logic in your applications. By representing business rules as first-class objects, you gain:

- **Clear separation of concerns**: Business rules are isolated from entity implementation
- **Improved testability**: Policies can be tested independently
- **Better maintainability**: Rules are explicit and documented
- **Enhanced flexibility**: Rules can be changed and composed dynamically
- **Richer error handling**: Detailed violation information enhances user experience

In the next article, we'll explore how EDNet Core implements event sourcing and domain events, providing a foundation for capturing and replaying state changes in your domain model.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.* 