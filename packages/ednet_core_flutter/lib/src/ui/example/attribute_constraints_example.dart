import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../ednet_core_flutter.dart';

/// Example usage of the constraint-validated form with enhanced TypeConstraintValidator
class AttributeConstraintsExample extends StatefulWidget {
  const AttributeConstraintsExample({Key? key}) : super(key: key);

  @override
  State<AttributeConstraintsExample> createState() =>
      _AttributeConstraintsExampleState();
}

class _AttributeConstraintsExampleState
    extends State<AttributeConstraintsExample> {
  // Domain model
  late Domain _domain;
  late Model _model;
  late Concept _userConcept;

  // Form data
  Map<String, dynamic> _userData = {};

  // Disclosure level state
  DisclosureLevel _currentLevel = DisclosureLevel.basic;

  @override
  void initState() {
    super.initState();
    _setupDomainModel();
  }

  /// Set up the domain model with constraints for the example
  void _setupDomainModel() {
    // Create domain
    _domain = Domain('ExampleDomain');
    _model = Model(_domain, 'UserManagement');
    _userConcept = Concept(_model, 'User');

    // Create attributes with constraints

    // Username - string with length and pattern constraints
    final usernameAttr = Attribute(_userConcept, 'username');
    usernameAttr.type = _domain.getType('String');
    usernameAttr.required = true;

    // Apply pattern constraint for username
    (usernameAttr.type as AttributeType).setMinLength(3);
    (usernameAttr.type as AttributeType).setPattern(r'^[a-zA-Z0-9_]+$');

    // Email - with email validation
    final emailAttr = Attribute(_userConcept, 'email');
    emailAttr.type = _domain.getType('Email');
    emailAttr.required = true;

    // Age - integer with min/max constraints
    final ageAttr = Attribute(_userConcept, 'age');
    ageAttr.type = _domain.getType('int');
    ageAttr.required = false;

    // Apply min/max value constraints for age
    (ageAttr.type as AttributeType).setMinValue(18);
    (ageAttr.type as AttributeType).setMaxValue(120);

    // Biography - long text with max length
    final bioAttr = Attribute(_userConcept, 'biography');
    bioAttr.type = _domain.getType('String');
    bioAttr.type!.length = 500; // Max length

    // Website - with URI validation
    final websiteAttr = Attribute(_userConcept, 'website');
    websiteAttr.type = _domain.getType('Uri');
    websiteAttr.required = false;

    // Active account - boolean
    final activeAttr = Attribute(_userConcept, 'isActive');
    activeAttr.type = _domain.getType('bool');
    activeAttr.required = false;
  }

  /// Handle form submission
  Future<bool> _handleSubmit(Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Store the submitted data
    setState(() {
      _userData = Map.from(data);
    });

    // Show the submitted data for debugging
    debugPrint('User data submitted: ${data.toString()}');

    // Return success
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain Model Constraints Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclosure level selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Disclosure Level',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<DisclosureLevel>(
                      segments: const [
                        ButtonSegment(
                          value: DisclosureLevel.basic,
                          label: Text('Basic'),
                        ),
                        ButtonSegment(
                          value: DisclosureLevel.intermediate,
                          label: Text('Intermediate'),
                        ),
                        ButtonSegment(
                          value: DisclosureLevel.advanced,
                          label: Text('Advanced'),
                        ),
                      ],
                      selected: {_currentLevel},
                      onSelectionChanged: (Set<DisclosureLevel> selection) {
                        setState(() {
                          _currentLevel = selection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Constraint-validated form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstraintValidatedForm(
                  concept: _userConcept,
                  disclosureLevel: _currentLevel,
                  title: 'User Registration',
                  submitButtonText: 'Register User',
                  onSubmit: _handleSubmit,
                  validateOnChange: true,
                  showConstraintIndicators: true,
                  customHints: {
                    'username':
                        'Enter 3-20 alphanumeric characters or underscores',
                    'email': 'Enter a valid email address',
                    'age': 'Must be between 18 and 120',
                    'biography': 'Tell us about yourself (max 500 characters)',
                    'website': 'Enter a valid URL with scheme and host',
                  },
                  customHelp: {
                    'username':
                        'This will be your unique identifier on the platform',
                    'isActive':
                        'Inactive accounts will be hidden from public view',
                  },
                ),
              ),
            ),

            // Display submitted data if available
            if (_userData.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submitted Data',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._userData.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child:
                                      Text(entry.value?.toString() ?? 'null'),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
