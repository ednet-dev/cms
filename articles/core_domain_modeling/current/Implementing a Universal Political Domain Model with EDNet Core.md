# Implementing a Universal Political Domain Model with EDNet Core

## Domain-Specific Policies and Rule Engines

One of the most powerful aspects of EDNet Core for political modeling is its policy system. Political systems are defined by rules - constitutional requirements, voting eligibility, representation thresholds, and more. Let's examine how to implement these complex rule systems:

```dart
// Policy implementation for electoral thresholds
class ThresholdPolicy implements IPolicy {
  final double standardThreshold;
  final bool hasMinorityExemption;
  final double? minorityThreshold;
  
  ThresholdPolicy({
    required this.standardThreshold,
    this.hasMinorityExemption = false,
    this.minorityThreshold,
  });
  
  @override
  String get name => 'ElectoralThresholdPolicy';
  
  @override
  String get description => 'Enforces electoral threshold rules';
  
  @override
  bool evaluate(Entity entity) {
    if (entity is! ElectoralList) return true; // Only applies to electoral lists
    
    final percentageVotes = entity.getAttribute<double>('percentageVotes') ?? 0.0;
    final isMinorityList = entity.getAttribute<bool>('isMinorityList') ?? false;
    
    if (isMinorityList && hasMinorityExemption) {
      if (minorityThreshold != null) {
        return percentageVotes >= minorityThreshold!;
      }
      return true; // Fully exempt
    }
    
    return percentageVotes >= standardThreshold;
  }
  
  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    final success = evaluate(entity);
    
    if (success) {
      return PolicyEvaluationResult(true, []);
    } else {
      // Provide detailed information about threshold violation
      final percentageVotes = (entity as ElectoralList).getAttribute<double>('percentageVotes') ?? 0.0;
      final isMinorityList = entity.getAttribute<bool>('isMinorityList') ?? false;
      final threshold = isMinorityList && hasMinorityExemption && minorityThreshold != null 
          ? minorityThreshold! 
          : standardThreshold;
          
      return PolicyEvaluationResult(false, [
        PolicyViolation(
          name,
          'Electoral list received $percentageVotes% which is below the required threshold of $threshold%',
        ),
      ]);
    }
  }
}
```

Complex rule systems can be composed of multiple policies working together:

```dart
// Composing a complete electoral rule system
class ElectoralRuleSystem {
  final PolicyRegistry policyRegistry = PolicyRegistry();
  
  ElectoralRuleSystem() {
    // Register threshold policies
    policyRegistry.registerPolicy(
      'serbian.threshold',
      ThresholdPolicy(
        standardThreshold: 3.0,
        hasMinorityExemption: true,
      ),
    );
    
    policyRegistry.registerPolicy(
      'austrian.threshold',
      ThresholdPolicy(
        standardThreshold: 4.0,
      ),
    );
    
    // Register seat allocation policies
    policyRegistry.registerPolicy(
      'dhondt.allocation',
      SeatAllocationPolicy(
        method: DHondtCalculator(),
      ),
    );
    
    policyRegistry.registerPolicy(
      'sainte_lague.allocation',
      SeatAllocationPolicy(
        method: SainteLagueCalculator(),
      ),
    );
    
    // Register ballot validity policies
    policyRegistry.registerPolicy(
      'ballot.validity',
      BallotValidityPolicy(),
    );
    
    // And many more...
  }
  
  // Apply country-specific rule set to an election
  bool enforceRules(String countryCode, Election election) {
    switch (countryCode.toLowerCase()) {
      case 'rs':
        return PolicyEvaluator(policyRegistry).evaluateWithKeys(
          election,
          [
            'serbian.threshold',
            'dhondt.allocation',
            'ballot.validity',
          ],
        ).success;
      case 'at':
        return PolicyEvaluator(policyRegistry).evaluateWithKeys(
          election,
          [
            'austrian.threshold',
            'dhondt.allocation', // Austria also uses D'Hondt
            'ballot.validity',
          ],
        ).success;
      case 'ba':
        // Bosnia & Herzegovina has a complex set of rules
        return PolicyEvaluator(policyRegistry).evaluateWithKeys(
          election,
          [
            'bosnia.threshold',
            'sainte_lague.allocation',
            'bosnia.entityRepresentation',
            'bosnia.ethnicBalance',
            'ballot.validity',
          ],
        ).success;
      default:
        throw ArgumentException('Unknown country code: $countryCode');
    }
  }
}
```

## Event Sourcing for Legislative Changes

Political systems evolve over time as laws change. Event sourcing is perfect for tracking these changes:

```dart
class LegislativeChangeEvent extends DomainEvent {
  final String legislationId;
  final String title;
  final String description;
  final String countryCode;
  final LegislationChangeType changeType;
  final Map<String, dynamic> changes;
  
  LegislativeChangeEvent({
    required this.legislationId,
    required this.title,
    required this.description,
    required this.countryCode,
    required this.changeType,
    required this.changes,
    required String initiatorId,
  }) : super(initiatorId, DateTime.now());
}

// A legislative system that tracks changes through events
class EventSourcedLegislativeSystem {
  final EventStore _eventStore;
  final Map<String, LegislationSnapshot> _currentState = {};
  
  EventSourcedLegislativeSystem(this._eventStore) {
    // Replay all historical events to build current state
    _rehydrateFromEvents();
  }
  
  // Record a new legislative change
  Future<void> enactLegislation(LegislativeChangeEvent event) async {
    // Save the event to the store
    await _eventStore.saveEvent(event);
    
    // Apply the event to update current state
    _applyEvent(event);
  }
  
  // Get the current state of a piece of legislation
  LegislationSnapshot? getLegislation(String legislationId) {
    return _currentState[legislationId];
  }
  
  // Get the full history of changes for a piece of legislation
  Future<List<LegislativeChangeEvent>> getLegislationHistory(String legislationId) async {
    return await _eventStore.getEventsByFilter(
      (event) => event is LegislativeChangeEvent && event.legislationId == legislationId,
    ) as List<LegislativeChangeEvent>;
  }
  
  // Rebuild the current state from stored events
  void _rehydrateFromEvents() async {
    final events = await _eventStore.getAllEvents();
    for (final event in events) {
      if (event is LegislativeChangeEvent) {
        _applyEvent(event);
      }
    }
  }
  
  // Apply a single event to update state
  void _applyEvent(LegislativeChangeEvent event) {
    final existing = _currentState[event.legislationId];
    
    switch (event.changeType) {
      case LegislationChangeType.create:
        _currentState[event.legislationId] = LegislationSnapshot(
          id: event.legislationId,
          title: event.title,
          description: event.description,
          countryCode: event.countryCode,
          content: event.changes['content'],
          version: 1,
          lastModified: event.timestamp,
        );
        break;
        
      case LegislationChangeType.amend:
        if (existing != null) {
          _currentState[event.legislationId] = existing.copyWith(
            title: event.changes['title'] ?? existing.title,
            description: event.changes['description'] ?? existing.description,
            content: event.changes['content'] ?? existing.content,
            version: existing.version + 1,
            lastModified: event.timestamp,
          );
        }
        break;
        
      case LegislationChangeType.repeal:
        if (existing != null) {
          _currentState[event.legislationId] = existing.copyWith(
            isActive: false,
            version: existing.version + 1,
            lastModified: event.timestamp,
          );
        }
        break;
    }
  }
}
```

This event-sourced approach allows us to:
1. Track the complete history of any piece of legislation
2. Reconstruct the state of the legal system at any point in time
3. Perform audits on legal changes
4. Support temporal queries (e.g., "What was the electoral law in 2012?")

## Composite Patterns for International Organizations

Modeling international organizations requires composite patterns that can represent nested political structures:

```dart
// Composite pattern for political structures
abstract class PoliticalUnit {
  String get name;
  String get code;
  GovernanceType get governanceType;
  
  // Query capabilities
  List<Legislation> getApplicableLegislation();
  List<ElectoralEvent> getElectoralHistory();
}

// Leaf node - represents a single country
class Nation extends AggregateRoot implements PoliticalUnit {
  @override
  final String name;
  
  @override
  final String code;
  
  @override
  final GovernanceType governanceType;
  
  final List<ElectoralSystem> electoralSystems;
  final Constitution constitution;
  
  Nation({
    required this.name,
    required this.code,
    required this.governanceType,
    required this.electoralSystems,
    required this.constitution,
  });
  
  @override
  List<Legislation> getApplicableLegislation() {
    return constitution.legislationList;
  }
  
  @override
  List<ElectoralEvent> getElectoralHistory() {
    return electoralSystems
      .expand((system) => system.pastElections)
      .toList();
  }
}

// Composite node - represents an international organization
class InternationalOrganization extends AggregateRoot implements PoliticalUnit {
  @override
  final String name;
  
  @override
  final String code;
  
  @override
  final GovernanceType governanceType;
  
  final List<PoliticalUnit> members;
  final List<Treaty> foundingTreaties;
  final List<Legislation> commonLegislation;
  
  InternationalOrganization({
    required this.name,
    required this.code,
    required this.governanceType,
    this.members = const [],
    this.foundingTreaties = const [],
    this.commonLegislation = const [],
  });
  
  @override
  List<Legislation> getApplicableLegislation() {
    // Organization's own legislation plus founding treaties
    return [
      ...commonLegislation,
      ...foundingTreaties,
    ];
  }
  
  @override
  List<ElectoralEvent> getElectoralHistory() {
    // For supranational bodies with direct elections (like European Parliament)
    return [];
  }
  
  // Add a member to the organization
  void addMember(PoliticalUnit member, MembershipAgreement agreement) {
    recordEvent(
      'MemberAdded',
      'New member added to international organization',
      ['MembershipHandler'],
      data: {
        'memberCode': member.code,
        'memberName': member.name,
        'agreementId': agreement.id,
      },
    );
    
    members.add(member);
  }
  
  // Adopt common legislation for all members
  void adoptLegislation(Legislation legislation, VotingRecord votingRecord) {
    // Validate that adoption follows required procedures
    if (!_validateLegislationAdoption(legislation, votingRecord)) {
      throw ValidationException(
        'legislation',
        'Legislation adoption did not follow required procedures',
        entity: this,
      );
    }
    
    recordEvent(
      'LegislationAdopted',
      'Common legislation adopted by organization',
      ['LegislationHandler'],
      data: {
        'legislationId': legislation.id,
        'title': legislation.title,
        'votingRecord': votingRecord.toJson(),
      },
    );
    
    commonLegislation.add(legislation);
  }
  
  // Validate legislation adoption process
  bool _validateLegislationAdoption(Legislation legislation, VotingRecord votingRecord) {
    // Implementation depends on organization's governance rules
    switch (governanceType) {
      case GovernanceType.unanimousConsent:
        return votingRecord.votes.every((vote) => vote.inFavor);
        
      case GovernanceType.qualifiedMajority:
        final inFavorCount = votingRecord.votes.where((v) => v.inFavor).length;
        return inFavorCount >= members.length * 0.75; // 75% threshold
        
      case GovernanceType.simpleMajority:
        final inFavorCount = votingRecord.votes.where((v) => v.inFavor).length;
        return inFavorCount > members.length / 2;
        
      default:
        return false;
    }
  }
}
```

## Direct Democracy Implementation

Direct democracy mechanisms require special handling for citizen participation:

```dart
class DirectDemocracyComponent extends AggregateRoot {
  final String name;
  final String jurisdictionCode;
  final DirectDemocracyRules rules;
  
  // Active initiatives and referendums
  final List<CitizenInitiative> activeInitiatives;
  final List<ScheduledReferendum> scheduledReferendums;
  
  // Historical records
  final List<CompletedInitiative> pastInitiatives;
  final List<CompletedReferendum> pastReferendums;
  
  DirectDemocracyComponent({
    required this.name,
    required this.jurisdictionCode,
    required this.rules,
    this.activeInitiatives = const [],
    this.scheduledReferendums = const [],
    this.pastInitiatives = const [],
    this.pastReferendums = const [],
  });
  
  // Submit a new citizen initiative
  void submitInitiative(CitizenInitiativeSubmission submission) {
    // Validate submission against rules
    if (!rules.validateInitiativeSubmission(submission)) {
      throw ValidationException(
        'initiative',
        'Initiative submission does not meet requirements',
        entity: this,
      );
    }
    
    final initiative = CitizenInitiative(
      id: Uuid().v4(),
      title: submission.title,
      description: submission.description,
      proposedText: submission.proposedText,
      initiatorId: submission.initiatorId,
      requiredSignatures: rules.requiredSignaturesForPopulation(submission.affectedPopulation),
      currentSignatures: [],
      submissionDate: DateTime.now(),
      expirationDate: DateTime.now().add(rules.signatureCollectionPeriod),
      status: InitiativeStatus.collectingSignatures,
    );
    
    recordEvent(
      'InitiativeSubmitted',
      'New citizen initiative submitted',
      ['InitiativeHandler'],
      data: {
        'initiativeId': initiative.id,
        'title': initiative.title,
        'initiatorId': initiative.initiatorId,
      },
    );
    
    activeInitiatives.add(initiative);
  }
  
  // Add signature to an initiative
  void signInitiative(String initiativeId, CitizenSignature signature) {
    final initiative = activeInitiatives.firstWhere(
      (i) => i.id == initiativeId,
      orElse: () => throw NotFoundException('Initiative not found'),
    );
    
    // Validate signature is eligible
    if (!rules.validateSignature(signature, initiative)) {
      throw ValidationException(
        'signature',
        'Signature is not valid for this initiative',
        entity: this,
      );
    }
    
    // Check if initiative is still collecting signatures
    if (initiative.status != InitiativeStatus.collectingSignatures) {
      throw ValidationException(
        'initiative',
        'Initiative is no longer collecting signatures',
        entity: this,
      );
    }
    
    recordEvent(
      'InitiativeSigned',
      'Citizen signed an initiative',
      ['InitiativeHandler'],
      data: {
        'initiativeId': initiative.id,
        'signatureId': signature.id,
        'citizenId': signature.citizenId,
      },
    );
    
    initiative.currentSignatures.add(signature);
    
    // Check if required signatures reached
    if (initiative.currentSignatures.length >= initiative.requiredSignatures) {
      _progressInitiativeToVerification(initiative);
    }
  }
  
  // Handle initiative verification
  void _progressInitiativeToVerification(CitizenInitiative initiative) {
    recordEvent(
      'InitiativeProgressedToVerification',
      'Initiative collected sufficient signatures and progressed to verification',
      ['InitiativeHandler'],
      data: {
        'initiativeId': initiative.id,
        'signaturesCollected': initiative.currentSignatures.length,
        'requiredSignatures': initiative.requiredSignatures,
      },
    );
    
    initiative.status = InitiativeStatus.underVerification;
    
    // In a real system, this would trigger a process to verify all signatures
    // For this example, we'll assume immediate verification
    _scheduleReferendumFromInitiative(initiative);
  }
  
  // Schedule referendum from verified initiative
  void _scheduleReferendumFromInitiative(CitizenInitiative initiative) {
    final referendum = ScheduledReferendum(
      id: Uuid().v4(),
      title: initiative.title,
      description: initiative.description,
      proposedText: initiative.proposedText,
      originatingInitiativeId: initiative.id,
      scheduledDate: DateTime.now().add(rules.referendumSchedulingPeriod),
      status: ReferendumStatus.scheduled,
    );
    
    recordEvent(
      'ReferendumScheduled',
      'Referendum scheduled from citizen initiative',
      ['ReferendumHandler'],
      data: {
        'referendumId': referendum.id,
        'initiativeId': initiative.id,
        'scheduledDate': referendum.scheduledDate.toIso8601String(),
      },
    );
    
    // Update initiative status and archive it
    initiative.status = InitiativeStatus.progressedToReferendum;
    activeInitiatives.remove(initiative);
    pastInitiatives.add(
      CompletedInitiative.fromInitiative(
        initiative, 
        InitiativeOutcome.progressedToReferendum,
      ),
    );
    
    // Add referendum to scheduled list
    scheduledReferendums.add(referendum);
  }
  
  // Many more methods would be needed for a full implementation...
}
```

## Repository Implementation for Political Entities

To persist and retrieve political entities, we need repositories tailored to this domain:

```dart
class PoliticalEntityRepository<T extends Entity<T>> extends Repository<T> {
  final DomainSession _session;
  final String _conceptCode;
  
  PoliticalEntityRepository(this._session, this._conceptCode);
  
  // Find entities by jurisdiction
  Entities<T> findByJurisdiction(String jurisdictionCode) {
    return getAll().where(
      (entity) => entity.getAttribute<String>('jurisdictionCode') == jurisdictionCode,
    ).whereType<T>() as Entities<T>;
  }
  
  // Find active legislation
  Entities<T> findActiveLegislation() {
    if (_conceptCode != 'Legislation') {
      throw Exception('This method is only valid for Legislation entities');
    }
    
    return getAll().where(
      (entity) => entity.getAttribute<bool>('isActive') == true,
    ).whereType<T>() as Entities<T>;
  }
  
  // Find by date range (for electoral events, legislation changes, etc.)
  Entities<T> findByDateRange(DateTime start, DateTime end, String dateField) {
    return getAll().where((entity) {
      final date = entity.getAttribute<DateTime>(dateField);
      if (date == null) return false;
      return date.isAfter(start) && date.isBefore(end);
    }).whereType<T>() as Entities<T>;
  }
  
  // Find multilingual entities by preferred language
  T? findByCodeAndLanguage(String code, String languageCode) {
    final entity = getAll().firstWhere(
      (entity) => entity.getAttribute<String>('code') == code,
      orElse: () => null,
    );
    
    if (entity == null) return null;
    
    // If this entity is multilingual, get the appropriate language version
    if (entity is MultilingualEntity) {
      return entity.getLanguageVariant(languageCode) as T;
    }
    
    return entity as T;
  }
}

// Usage example:
final legislationRepo = PoliticalEntityRepository<Legislation>(session, 'Legislation');
final serbianLaws = legislationRepo.findByJurisdiction('RS');
final recentLaws = legislationRepo.findByDateRange(
  DateTime(2022, 1, 1),
  DateTime.now(),
  'enactmentDate',
);
```

## Integration with External Data Sources

A complete political model must integrate with external data sources for demographics, geographical information, and other relevant data:

```dart
class PoliticalDataIntegrationService {
  final HttpClient _client;
  final String _apiKey;
  
  PoliticalDataIntegrationService(this._client, this._apiKey);
  
  // Fetch demographic data for a jurisdiction
  Future<DemographicData> fetchDemographicData(String jurisdictionCode) async {
    final response = await _client.get(
      Uri.parse('https://api.politicaldata.org/v1/demographics/$jurisdictionCode'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    
    if (response.statusCode == 200) {
      return DemographicData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load demographic data: ${response.statusCode}');
    }
  }
  
  // Fetch electoral district boundaries
  Future<List<GeoDistrict>> fetchElectoralDistricts(String jurisdictionCode) async {
    final response = await _client.get(
      Uri.parse('https://api.politicaldata.org/v1/districts/$jurisdictionCode'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> districts = jsonDecode(response.body);
      return districts.map((json) => GeoDistrict.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load district data: ${response.statusCode}');
    }
  }
  
  // Fetch historical election results
  Future<List<ElectionResult>> fetchHistoricalResults(
    String jurisdictionCode,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await _client.get(
      Uri.parse(
        'https://api.politicaldata.org/v1/elections/$jurisdictionCode'
        '?start=${startDate.toIso8601String()}'
        '&end=${endDate.toIso8601String()}',
      ),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      return results.map((json) => ElectionResult.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load election results: ${response.statusCode}');
    }
  }
  
  // Update model with real-world data
  Future<void> populateModel(
    PoliticalDomainModel model,
    String jurisdictionCode,
  ) async {
    // Fetch all necessary data
    final demographics = await fetchDemographicData(jurisdictionCode);
    final districts = await fetchElectoralDistricts(jurisdictionCode);
    final pastResults = await fetchHistoricalResults(
      jurisdictionCode,
      DateTime(2000, 1, 1),
      DateTime.now(),
    );
    
    // Update domain model with real-world data
    model.updateDemographics(demographics);
    model.updateDistricts(districts);
    model.importHistoricalResults(pastResults);
  }
}
```

## Conclusion: Toward a Universal Political Domain Framework

Through the examples in this article, we've demonstrated how EDNet Core can evolve from modeling specific electoral systems into a comprehensive framework for political domain modeling. The key advantages of this approach include:

1. **Adaptability**: The framework can model diverse political systems from simple electoral processes to complex international organizations.

2. **Language Agnosticism**: By treating language as content metadata, the model can work across linguistic boundaries while preserving semantic meaning.

3. **Event Sourcing**: The ability to track changes over time is crucial for political systems where history and legal precedent matter.

4. **Rich Policy System**: Complex rules and constraints can be expressed as composable, reusable policies.

5. **Integrated Data Model**: The ability to incorporate external data sources ensures models reflect real-world political conditions.

As EDNet Core continues to develop, it promises to become an invaluable tool for political scientists, electoral system designers, and direct democracy advocates. By providing a common language and framework for modeling political systems, it can facilitate cross-border collaboration, comparative analysis, and the design of more effective democratic processes.

The journey from national electoral systems to universal political modeling showcases the power of domain-driven design principles when applied to complex real-world domains. By starting with concrete implementations and carefully extracting common patterns, we create models that are both practically useful and theoretically sound.

In future articles, we'll explore how these political domain models can be deployed in real-world applications, from electoral management systems to direct democracy platforms and international governance tools.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*
