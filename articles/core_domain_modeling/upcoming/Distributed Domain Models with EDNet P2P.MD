
# Distributed Domain Models with EDNet P2P

## Introduction

Modern applications increasingly require distributed architectures where data and processing are spread across multiple nodes. Traditional client-server models can create single points of failure and limit collaboration. EDNet P2P extends EDNet Core with peer-to-peer networking capabilities, enabling truly decentralized domain models that can operate across networks of equal peers, share data, and maintain consistency without central coordination.

## Beyond Client-Server

The client-server paradigm has dominated application architecture for decades, but it has significant limitations:

1. **Central Point of Failure**: If the server goes down, all clients are affected
2. **Scalability Challenges**: Servers must be scaled to handle peak loads
3. **Connectivity Requirements**: Clients typically need constant server access
4. **Trust Requirements**: All participants must trust the central authority
5. **Ownership Constraints**: Data and processing are controlled by the server owner

In many domains – especially those involving collaboration, local autonomy, or resilience requirements – a peer-to-peer approach offers significant advantages:

1. **No Single Point of Failure**: The network can function even if some nodes fail
2. **Natural Scalability**: Each peer adds resources to the network
3. **Offline Capability**: Peers can work offline and synchronize later
4. **Distributed Trust**: No central authority is required
5. **Shared Ownership**: Data and processing can be distributed among participants

## EDNet P2P Architecture

EDNet P2P implements a distributed domain model architecture with several key components:

```dart
// The core P2P node that represents a peer in the network
class EDNetP2PNode {
  final String nodeId;
  final DomainModelRegistry modelRegistry;
  final PeerDiscovery peerDiscovery;
  final ConnectionManager connectionManager;
  final SynchronizationEngine syncEngine;
  final EventBus eventBus;
  
  EDNetP2PNode({
    required this.nodeId,
    required this.modelRegistry,
    required this.peerDiscovery,
    required this.connectionManager,
    required this.syncEngine,
    required this.eventBus,
  });
  
  // Start the P2P node
  Future<void> start() async {
    // Start peer discovery
    await peerDiscovery.start();
    
    // Start connection manager
    await connectionManager.start();
    
    // Start synchronization engine
    await syncEngine.start();
    
    // Register event handlers
    _registerEventHandlers();
  }
  
  // Register a domain model for P2P synchronization
  void registerDomainModel(String modelId, SynchronizableDomainModel model) {
    modelRegistry.register(modelId, model);
    syncEngine.registerModel(modelId, model);
  }
  
  // Connect to a known peer
  Future<bool> connectToPeer(PeerAddress address) async {
    return await connectionManager.connectToPeer(address);
  }
  
  // Synchronize a specific model with connected peers
  Future<SyncResult> synchronizeModel(String modelId) async {
    return await syncEngine.synchronize(modelId);
  }
  
  // Internal event handling setup
  void _registerEventHandlers() {
    // Handle new peer discovery
    eventBus.on<PeerDiscoveredEvent>().listen((event) {
      connectionManager.connectToPeer(event.peerAddress);
    });
    
    // Handle peer disconnection
    eventBus.on<PeerDisconnectedEvent>().listen((event) {
      // Handle peer disconnection, possibly retry connection
    });
    
    // Handle model change events
    eventBus.on<ModelChangedEvent>().listen((event) {
      // Trigger synchronization for the changed model
      syncEngine.synchronize(event.modelId);
    });
  }
}
```

## Synchronizable Domain Models

To participate in a P2P network, domain models must implement the `SynchronizableDomainModel` interface:

```dart
abstract class SynchronizableDomainModel {
  // Unique identifier for this model instance
  String get modelId;
  
  // Current version of the model (typically a vector clock or version vector)
  VersionVector get version;
  
  // Get all changes since a specific version
  List<ModelChange> getChangesSince(VersionVector sinceVersion);
  
  // Apply changes from another peer
  Future<ApplyChangesResult> applyChanges(List<ModelChange> changes);
  
  // Resolve conflicts between concurrent changes
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflictingChanges);
  
  // Get a snapshot of the entire model
  Future<ModelSnapshot> getSnapshot();
  
  // Initialize from a snapshot
  Future<bool> initializeFromSnapshot(ModelSnapshot snapshot);
}

// Implementation for an electoral system domain model
class ElectoralSystemModel implements SynchronizableDomainModel {
  final String _modelId;
  final ElectionRepository _electionRepo;
  final CandidateRepository _candidateRepo;
  final VoterRepository _voterRepo;
  final ConflictResolver _conflictResolver;
  final VersionVector _version = VersionVector();
  
  ElectoralSystemModel(
    this._modelId,
    this._electionRepo,
    this._candidateRepo,
    this._voterRepo,
    this._conflictResolver,
  );
  
  @override
  String get modelId => _modelId;
  
  @override
  VersionVector get version => _version;
  
  @override
  List<ModelChange> getChangesSince(VersionVector sinceVersion) {
    final changes = <ModelChange>[];
    
    // Get changes from each repository
    changes.addAll(_electionRepo.getChangesSince(sinceVersion));
    changes.addAll(_candidateRepo.getChangesSince(sinceVersion));
    changes.addAll(_voterRepo.getChangesSince(sinceVersion));
    
    return changes;
  }
  
  @override
  Future<ApplyChangesResult> applyChanges(List<ModelChange> changes) async {
    final result = ApplyChangesResult();
    
    // Group changes by entity type
    final electionChanges = changes.where((c) => c.entityType == 'Election').toList();
    final candidateChanges = changes.where((c) => c.entityType == 'Candidate').toList();
    final voterChanges = changes.where((c) => c.entityType == 'Voter').toList();
    
    // Apply changes to each repository
    result.electionResults = await _electionRepo.applyChanges(electionChanges);
    result.candidateResults = await _candidateRepo.applyChanges(candidateChanges);
    result.voterResults = await _voterRepo.applyChanges(voterChanges);
    
    // Update version vector
    for (final change in changes) {
      _version.update(change.sourceNodeId, change.sourceSequence);
    }
    
    return result;
  }
  
  @override
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflictingChanges) async {
    return await _conflictResolver.resolveConflicts(conflictingChanges);
  }
  
  @override
  Future<ModelSnapshot> getSnapshot() async {
    final snapshot = ModelSnapshot(modelId: _modelId, version: _version);
    
    // Add all entities to the snapshot
    snapshot.elections = await _electionRepo.getAll();
    snapshot.candidates = await _candidateRepo.getAll();
    snapshot.voters = await _voterRepo.getAll();
    
    return snapshot;
  }
  
  @override
  Future<bool> initializeFromSnapshot(ModelSnapshot snapshot) async {
    if (snapshot.modelId != _modelId) {
      return false;
    }
    
    // Clear existing data
    await _electionRepo.clear();
    await _candidateRepo.clear();
    await _voterRepo.clear();
    
    // Load from snapshot
    await _electionRepo.addAll(snapshot.elections);
    await _candidateRepo.addAll(snapshot.candidates);
    await _voterRepo.addAll(snapshot.voters);
    
    // Update version
    _version.mergeWith(snapshot.version);
    
    return true;
  }
}
```

## CRDT-Based Entity Synchronization

Conflict-Free Replicated Data Types (CRDTs) are a fundamental building block for distributed domain models, allowing for automatic conflict resolution:

```dart
// CRDT-based entity class
class CRDTEntity<T extends Entity<T>> extends Entity<T> {
  // Last-Write-Wins register for each attribute
  final Map<String, LWWRegister<dynamic>> _attributeRegisters = {};
  
  // Add-Wins Set for child collections
  final Map<String, AWSet<Entity>> _childSets = {};
  
  // Version vector for the entity
  final VersionVector _version = VersionVector();
  
  @override
  dynamic getAttribute<K>(String attributeCode) {
    final register = _attributeRegisters[attributeCode];
    return register?.value as K?;
  }
  
  @override
  bool setAttribute(String name, dynamic value) {
    // Get the current time and node ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nodeId = P2PContext.current.nodeId;
    
    // Create or update the LWW register
    _attributeRegisters[name] ??= LWWRegister<dynamic>();
    _attributeRegisters[name]!.update(value, timestamp, nodeId);
    
    // Update version vector
    _version.increment(nodeId);
    
    // Notify about the change
    P2PContext.current.eventBus.fire(
      EntityAttributeChangedEvent(
        entityId: oid.toString(),
        attributeName: name,
        newValue: value,
        timestamp: timestamp,
        nodeId: nodeId,
      ),
    );
    
    return true;
  }
  
  @override
  Object? getChild(String name) {
    final childSet = _childSets[name];
    if (childSet == null) return null;
    
    // Convert the AWSet to an Entities collection
    final entities = Entities<Entity>();
    for (final entity in childSet.items) {
      entities.add(entity);
    }
    
    return entities;
  }
  
  @override
  bool setChild(String name, Object entities) {
    if (entities is! Entities) return false;
    
    // Create or get the AWSet for this child relationship
    _childSets[name] ??= AWSet<Entity>();
    final childSet = _childSets[name]!;
    
    // Update the set with the entities
    for (final entity in entities) {
      childSet.add(entity);
    }
    
    // Update version vector
    _version.increment(P2PContext.current.nodeId);
    
    return true;
  }
  
  // Merge with another version of the same entity
  bool mergeWith(CRDTEntity<T> other) {
    if (oid != other.oid) return false;
    
    // Merge attribute registers
    for (final entry in other._attributeRegisters.entries) {
      _attributeRegisters[entry.key] ??= LWWRegister<dynamic>();
      _attributeRegisters[entry.key]!.mergeWith(entry.value);
    }
    
    // Merge child sets
    for (final entry in other._childSets.entries) {
      _childSets[entry.key] ??= AWSet<Entity>();
      _childSets[entry.key]!.mergeWith(entry.value);
    }
    
    // Merge version vectors
    _version.mergeWith(other._version);
    
    return true;
  }
}
```

## Peer Discovery Mechanisms

For peers to collaborate, they first need to find each other. EDNet P2P supports multiple discovery mechanisms:

```dart
// Base peer discovery interface
abstract class PeerDiscovery {
  Stream<PeerDiscoveredEvent> get peerDiscovered;
  Future<void> start();
  Future<void> stop();
  Future<List<PeerAddress>> discoverPeers();
}

// Local network discovery using mDNS/Bonjour
class LocalNetworkDiscovery implements PeerDiscovery {
  final String serviceType;
  final int servicePort;
  final StreamController<PeerDiscoveredEvent> _peerDiscoveredController = 
      StreamController.broadcast();
  
  LocalNetworkDiscovery({
    this.serviceType = '_ednet-p2p._tcp',
    this.servicePort = 8765,
  });
  
  @override
  Stream<PeerDiscoveredEvent> get peerDiscovered => _peerDiscoveredController.stream;
  
  @override
  Future<void> start() async {
    // Register our service
    await MDnsClient.register(serviceType, servicePort);
    
    // Start discovery
    MDnsClient.discover(serviceType).listen((service) {
      final address = PeerAddress(
        host: service.host,
        port: service.port,
        nodeId: service.attributes['nodeId'],
      );
      
      _peerDiscoveredController.add(PeerDiscoveredEvent(address));
    });
  }
  
  @override
  Future<void> stop() async {
    await MDnsClient.unregister(serviceType);
  }
  
  @override
  Future<List<PeerAddress>> discoverPeers() async {
    final peers = <PeerAddress>[];
    final services = await MDnsClient.discoverOnce(serviceType);
    
    for (final service in services) {
      peers.add(PeerAddress(
        host: service.host,
        port: service.port,
        nodeId: service.attributes['nodeId'],
      ));
    }
    
    return peers;
  }
}

// Server-based peer discovery
class ServerBasedDiscovery implements PeerDiscovery {
  final String serverUrl;
  final HttpClient _client = HttpClient();
  final StreamController<PeerDiscoveredEvent> _peerDiscoveredController = 
      StreamController.broadcast();
  Timer? _refreshTimer;
  
  ServerBasedDiscovery(this.serverUrl);
  
  @override
  Stream<PeerDiscoveredEvent> get peerDiscovered => _peerDiscoveredController.stream;
  
  @override
  Future<void> start() async {
    // Register with the discovery server
    final myAddress = PeerAddress(
      host: await getLocalIpAddress(),
      port: P2PContext.current.port,
      nodeId:
