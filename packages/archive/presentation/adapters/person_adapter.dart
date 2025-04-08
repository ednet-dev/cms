import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A showcase implementation of an entity adapter with progressive disclosure
class PersonAdapter {
  /// Build a card for a Person entity with appropriate disclosure levels
  static Widget buildPersonCard(
    BuildContext context,
    Entity entity, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
    VoidCallback? onTap,
  }) {
    // Extract person data from entity
    final firstName = entity.getAttribute('firstName')?.toString() ?? 'Unknown';
    final lastName = entity.getAttribute('lastName')?.toString() ?? '';
    final email = entity.getAttribute('email')?.toString();
    final age = entity.getAttribute('age')?.toString();

    // Build content with progressive disclosure
    return DomainEntityCard.forEntity(
      entity: entity,
      disclosureLevel: disclosureLevel,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name is always shown (minimal disclosure)
          Text(
            '$firstName $lastName',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          // Email is shown in basic disclosure or higher
          if (email != null &&
              disclosureLevel.index >= DisclosureLevel.basic.index) ...[
            Text('Email: $email'),
            const SizedBox(height: 4),
          ],

          // Age is shown in intermediate disclosure or higher
          if (age != null &&
              disclosureLevel.index >= DisclosureLevel.intermediate.index) ...[
            Text('Age: $age'),
            const SizedBox(height: 4),
          ],

          // Technical details are shown in advanced disclosure or higher
          if (disclosureLevel.index >= DisclosureLevel.advanced.index) ...[
            const Divider(),
            const SizedBox(height: 4),
            Text('ID: ${entity.id}'),
            Text('Concept: ${entity.concept.code}'),
          ],
        ],
      ),
    );
  }

  /// Build a list of Person entities with appropriate disclosure levels
  static Widget buildPersonList(
    BuildContext context,
    List<Entity> entities, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    return ListView.separated(
      itemCount: entities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final entity = entities[index];
        return buildPersonCard(
          context,
          entity,
          disclosureLevel: disclosureLevel,
          onTap: () {
            // Show person details in a dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Person Details'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: buildPersonCard(
                    context,
                    entity,
                    disclosureLevel: DisclosureLevel.advanced,
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
        );
      },
    );
  }

  /// Create a form for editing a Person entity
  static Widget buildPersonForm(
    BuildContext context,
    Entity entity, {
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Extract person data from entity
    final firstName = entity.getAttribute('firstName')?.toString() ?? '';
    final lastName = entity.getAttribute('lastName')?.toString() ?? '';
    final email = entity.getAttribute('email')?.toString() ?? '';
    final age = entity.getAttribute('age')?.toString() ?? '';

    return DomainEntityCard.forEntity(
      entity: entity,
      header: Text('Edit Person'),
      disclosureLevel: disclosureLevel,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First name and last name are minimal disclosure fields
            TextFormField(
              initialValue: firstName,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              initialValue: lastName,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email is shown in basic disclosure or higher
            if (disclosureLevel.index >= DisclosureLevel.basic.index) ...[
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Age is shown in intermediate disclosure or higher
            if (disclosureLevel.index >=
                DisclosureLevel.intermediate.index) ...[
              TextFormField(
                initialValue: age,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Save button
            ElevatedButton(
              onPressed: () {
                // In a real application, this would save the form data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Person saved (simulated)')),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
