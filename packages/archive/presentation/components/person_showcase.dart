import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart'
    show oneApplication; // Import the global instance

/// A showcase component for demonstrating progressive disclosure
class PersonShowcase extends StatefulWidget {
  /// Constructor
  const PersonShowcase({Key? key}) : super(key: key);

  @override
  State<PersonShowcase> createState() => _PersonShowcaseState();
}

class _PersonShowcaseState extends State<PersonShowcase> {
  DisclosureLevel _currentLevel = DisclosureLevel.basic;
  late final Domain _testDomain;
  late final Entity _testPerson;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDomainAndEntities();
  }

  void _initializeDomainAndEntities() {
    try {
      // Try to find the TestDomain in the OneApplication
      _testDomain =
          oneApplication.findDomain('TestDomain') ?? _createTestDomain();

      // Create a test person entity
      _testPerson = _createTestPersonEntity();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing domain: $e');
    }
  }

  Domain _createTestDomain() {
    // Create a domain, or use an existing one from the application
    final domain = oneApplication.createDomain('TestDomain');
    domain.description =
        'Domain for showcasing EDNet Core with progressive disclosure';

    // Add a model for Person entities
    final model = Model(domain, 'PersonModel');
    model.description = 'Model for Person entities';
    domain.models.add(model);

    // Create Person concept
    final personConcept = Concept(model, 'Person');
    personConcept.description = 'A person entity with various attributes';
    personConcept.entry = true; // Mark as aggregate root
    model.concepts.add(personConcept);

    // Add attributes to the Person concept
    _addAttribute(personConcept, 'firstName', required: true);
    _addAttribute(personConcept, 'lastName', required: true);
    _addAttribute(personConcept, 'email');
    _addAttribute(personConcept, 'age');
    _addAttribute(personConcept, 'notes', sensitive: true);

    return domain;
  }

  void _addAttribute(
    Concept concept,
    String name, {
    bool required = false,
    bool sensitive = false,
  }) {
    final attribute = Attribute(concept, name);
    attribute.required = required;
    attribute.sensitive = sensitive;
    concept.attributes.add(attribute);
  }

  Entity _createTestPersonEntity() {
    // Find the Person concept in our domain
    Concept? personConcept;
    for (final model in _testDomain.models) {
      for (final concept in model.concepts) {
        if (concept.code == 'Person') {
          personConcept = concept;
          break;
        }
      }
      if (personConcept != null) break;
    }

    if (personConcept == null) {
      throw Exception('Person concept not found');
    }

    // Create a new Person entity
    final entity = personConcept.newEntity();
    entity.code = 'person-demo';

    // Set attributes
    entity.setAttribute('firstName', 'John');
    entity.setAttribute('lastName', 'Doe');
    entity.setAttribute('email', 'john.doe@example.com');
    entity.setAttribute('age', 32);
    entity.setAttribute('notes',
        'This is a private note that should only be visible at advanced disclosure levels.');

    return entity;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EDNet Core Domain Entity Showcase'),
        actions: [
          // Disclosure level selector
          PopupMenuButton<DisclosureLevel>(
            icon: const Icon(Icons.visibility),
            tooltip: 'Change disclosure level',
            onSelected: (level) {
              setState(() {
                _currentLevel = level;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DisclosureLevel.minimal,
                child: Text('Minimal'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.basic,
                child: Text('Basic'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.intermediate,
                child: Text('Intermediate'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.advanced,
                child: Text('Advanced'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.complete,
                child: Text('Complete'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Domain: ${_testDomain.code}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (_testDomain.description.isNotEmpty)
                      Text(_testDomain.description),
                    const SizedBox(height: 8),
                    Text(
                      'Models: ${_testDomain.models.length}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ..._testDomain.models.map((model) => Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                          child: Text(
                              '- ${model.code} (${model.concepts.length} concepts)'),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Display current disclosure level
            Text(
              'Current Disclosure Level: ${_currentLevel.toString().split('.').last}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Show disclosure level description
            Text(_getDisclosureLevelDescription(_currentLevel)),

            const SizedBox(height: 24),

            // Person entity card
            Text(
              'Person Entity with Current Disclosure Level',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildEntityCard(context, _testPerson, _currentLevel),
            ),

            const SizedBox(height: 32),

            // Entity attributes
            Text(
              'Entity Attributes with Progressive Disclosure',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            _buildAttributesList(context, _testPerson, _currentLevel),

            const SizedBox(height: 32),

            // Comparison of different disclosure levels
            Text(
              'Comparison of Different Disclosure Levels',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Minimal Disclosure',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    _buildEntityCard(
                        context, _testPerson, DisclosureLevel.minimal),
                    const Divider(height: 32),
                    Text('Basic Disclosure',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    _buildEntityCard(
                        context, _testPerson, DisclosureLevel.basic),
                    const Divider(height: 32),
                    Text('Intermediate Disclosure',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    _buildEntityCard(
                        context, _testPerson, DisclosureLevel.intermediate),
                    const Divider(height: 32),
                    Text('Advanced Disclosure',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    _buildEntityCard(
                        context, _testPerson, DisclosureLevel.advanced),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form example
            ElevatedButton.icon(
              onPressed: () {
                // Show form with progressive disclosure
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: SizedBox(
                      width: 400,
                      child:
                          _buildEntityForm(context, _testPerson, _currentLevel),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Person Entity'),
            ),

            const SizedBox(height: 32),

            // Domain model exploration
            Text(
              'Explore All OneApplication Domains',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            _buildDomainList(context),
          ],
        ),
      ),
    );
  }

  /// Build a list of all domains in OneApplication
  Widget _buildDomainList(BuildContext context) {
    final domains = oneApplication.domains;

    if (domains.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No domains available in OneApplication'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Domains (${domains.length})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...domains.map(
              (domain) => ListTile(
                title: Text(domain.code),
                subtitle: Text('Models: ${domain.models.length}'),
                onTap: () {
                  // Show domain details
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Domain: ${domain.code}'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (domain.description != null &&
                                  domain.description!.isNotEmpty)
                                Text(
                                  domain.description!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              const SizedBox(height: 16),
                              Text(
                                'Models:',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              ...domain.models.map(
                                (model) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.code,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (model.description != null &&
                                          model.description!.isNotEmpty)
                                        Text(model.description!),
                                      Text(
                                          'Concepts: ${model.concepts.length}'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build an attributes list with progressive disclosure
  Widget _buildAttributesList(
      BuildContext context, Entity entity, DisclosureLevel level) {
    final concept = entity.concept;
    final attributes = concept.attributes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Concept: ${concept.code}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (concept.description != null && concept.description!.isNotEmpty)
              Text(concept.description!),
            const SizedBox(height: 16),

            Text(
              'Attributes:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Show attributes based on disclosure level
            ...attributes.map((property) {
              // Cast to Attribute if possible
              final attribute = property is Attribute ? property : null;
              if (attribute == null) return const SizedBox.shrink();

              // Determine if this attribute should be shown at current disclosure level
              bool visible = _shouldShowAttributeAtLevel(attribute, level);

              if (!visible) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        attribute.code,
                        style: TextStyle(
                          fontWeight: attribute.required
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatAttributeValue(
                            entity.getAttribute(attribute.code)),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: _attributeBadge(attribute),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Create a badge showing attribute properties
  Widget _attributeBadge(Attribute attribute) {
    List<Widget> badges = [];

    if (attribute.required) {
      badges.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Required',
            style: TextStyle(fontSize: 10),
          ),
        ),
      );
    }

    if (attribute.sensitive) {
      badges.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Sensitive',
            style: TextStyle(fontSize: 10),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 4,
      children: badges,
    );
  }

  /// Format an attribute value for display
  String _formatAttributeValue(dynamic value) {
    if (value == null) return 'null';
    return value.toString();
  }

  /// Determine if an attribute should be shown at the given disclosure level
  bool _shouldShowAttributeAtLevel(Attribute attribute, DisclosureLevel level) {
    if (level == DisclosureLevel.minimal) {
      // Only show required attributes at minimal level
      return attribute.required;
    } else if (level == DisclosureLevel.basic) {
      // Show required and non-sensitive attributes at basic level
      return attribute.required || !attribute.sensitive;
    } else if (level == DisclosureLevel.intermediate) {
      // Show almost everything at intermediate level
      return true;
    } else {
      // Show everything at advanced level and above
      return true;
    }
  }

  /// Build a dynamic card for the entity with proper disclosure levels
  Widget _buildEntityCard(
      BuildContext context, Entity entity, DisclosureLevel level) {
    return DomainEntityCard.forEntity(
      entity: entity,
      disclosureLevel: level,
      onTap: () {
        // Show entity details when tapped
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: SizedBox(
              width: 400,
              child: _buildEntityForm(context, entity, level),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name is always shown (minimal disclosure)
          Text(
            '${entity.getAttribute("firstName")} ${entity.getAttribute("lastName")}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          // Show attributes progressively based on disclosure level
          if (level.index >= DisclosureLevel.basic.index) ...[
            Text('Email: ${entity.getAttribute("email")}'),
            const SizedBox(height: 4),
          ],

          if (level.index >= DisclosureLevel.intermediate.index) ...[
            Text('Age: ${entity.getAttribute("age")}'),
            const SizedBox(height: 4),
          ],

          if (level.index >= DisclosureLevel.advanced.index) ...[
            const Divider(),
            const SizedBox(height: 4),
            if (entity.getAttribute("notes") != null)
              Text('Notes: ${entity.getAttribute("notes")}'),
            Text('ID: ${entity.id}'),
            Text('Concept: ${entity.concept.code}'),
          ],
        ],
      ),
    );
  }

  /// Build a form for the entity with progressive disclosure
  Widget _buildEntityForm(
      BuildContext context, Entity entity, DisclosureLevel level) {
    return DomainEntityCard.forEntity(
      entity: entity,
      header: Text('Edit ${entity.concept.code}'),
      disclosureLevel: level,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Always show first name and last name (minimal disclosure)
            TextFormField(
              initialValue: entity.getAttribute('firstName')?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              initialValue: entity.getAttribute('lastName')?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Show email at basic disclosure or higher
            if (level.index >= DisclosureLevel.basic.index) ...[
              TextFormField(
                initialValue: entity.getAttribute('email')?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Show age at intermediate disclosure or higher
            if (level.index >= DisclosureLevel.intermediate.index) ...[
              TextFormField(
                initialValue: entity.getAttribute('age')?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Show notes at advanced disclosure or higher
            if (level.index >= DisclosureLevel.advanced.index) ...[
              TextFormField(
                initialValue: entity.getAttribute('notes')?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Notes (Sensitive)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
            ],

            // Save and cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // In a real application, this would save the form data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Entity saved (simulated)')),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get a description of what each disclosure level means
  String _getDisclosureLevelDescription(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return 'Minimal: Shows only essential information needed for identification';
      case DisclosureLevel.basic:
        return 'Basic: Shows common information for everyday use';
      case DisclosureLevel.intermediate:
        return 'Intermediate: Shows additional details for power users';
      case DisclosureLevel.advanced:
        return 'Advanced: Shows technical details including metadata';
      case DisclosureLevel.complete:
        return 'Complete: Shows all available information including sensitive data';
      default:
        return 'Standard level of information';
    }
  }
}
