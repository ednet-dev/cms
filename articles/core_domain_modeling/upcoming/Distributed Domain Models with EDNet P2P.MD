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
      nodeId: P2PContext.current.nodeId,
    );
    
    await registerWithServer(myAddress);
    
    // Start periodic refresh
    _refreshTimer = Timer.periodic(Duration(minutes: 5), (_) async {
      await registerWithServer(myAddress);
      final peers = await discoverPeers();
      for (final peer in peers) {
        _peerDiscoveredController.add(PeerDiscoveredEvent(peer));
      }
    });
    
    // Initial discovery
    final peers = await discoverPeers();
    for (final peer in peers) {
      _peerDiscoveredController.add(PeerDiscoveredEvent(peer));
    }
  }
  
  Future<void> registerWithServer(PeerAddress address) async {
    try {
      final request = await _client.postUrl(Uri.parse('$serverUrl/peers/register'));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(address.toJson()));
      final response = await request.close();
      
      if (response.statusCode != 200) {
        print('Error registering with discovery server: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during server registration: $e');
    }
  }
  
  @override
  Future<void> stop() async {
    _refreshTimer?.cancel();
    try {
      final request = await _client.postUrl(Uri.parse('$serverUrl/peers/unregister'));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        'nodeId': P2PContext.current.nodeId,
      }));
      await request.close();
    } catch (e) {
      print('Exception during server unregistration: $e');
    }
  }
  
  @override
  Future<List<PeerAddress>> discoverPeers() async {
    final peers = <PeerAddress>[];
    try {
      final request = await _client.getUrl(Uri.parse('$serverUrl/peers'));
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final jsonString = await response.transform(utf8.decoder).join();
        final jsonList = jsonDecode(jsonString) as List;
        
        for (final peerJson in jsonList) {
          if (peerJson['nodeId'] != P2PContext.current.nodeId) {
            peers.add(PeerAddress.fromJson(peerJson));
          }
        }
      }
    } catch (e) {
      print('Exception during peer discovery: $e');
    }
    
    return peers;
  }
}

// DHT-based peer discovery using Kademlia
class DHTDiscovery implements PeerDiscovery {
  final List<PeerAddress> bootstrapNodes;
  final StreamController<PeerDiscoveredEvent> _peerDiscoveredController = 
      StreamController.broadcast();
  late KademliaDHT _dht;
  
  DHTDiscovery({
    required this.bootstrapNodes,
  });
  
  @override
  Stream<PeerDiscoveredEvent> get peerDiscovered => _peerDiscoveredController.stream;
  
  @override
  Future<void> start() async {
    // Initialize the DHT with our nodeId
    _dht = KademliaDHT(
      nodeId: P2PContext.current.nodeId,
      bootstrapNodes: bootstrapNodes,
    );
    
    // Start the DHT
    await _dht.start();
    
    // Add ourselves to the network
    await _dht.storePeer(
      PeerAddress(
        host: await getLocalIpAddress(),
        port: P2PContext.current.port,
        nodeId: P2PContext.current.nodeId,
      ),
    );
    
    // Listen for new peers
    _dht.onPeerDiscovered.listen((peer) {
      _peerDiscoveredController.add(PeerDiscoveredEvent(peer));
    });
  }
  
  @override
  Future<void> stop() async {
    await _dht.stop();
  }
  
  @override
  Future<List<PeerAddress>> discoverPeers() async {
    // Query the DHT for peers
    return await _dht.findPeers();
  }
}

## Connection Management

Once peers are discovered, establishing and maintaining connections between them is crucial for a functioning P2P network:

```dart
// Connection manager handles peer connections
class ConnectionManager {
  final String nodeId;
  final int port;
  final EventBus eventBus;
  final Map<String, PeerConnection> _connections = {};
  HttpServer? _server;
  
  ConnectionManager({
    required this.nodeId,
    required this.port,
    required this.eventBus,
  });
  
  // Get all active connections
  List<PeerConnection> get connections => _connections.values.toList();
  
  // Start the connection manager
  Future<void> start() async {
    // Start listening for incoming connections
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    
    // Handle incoming WebSocket connections
    _server!.listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        try {
          final socket = await WebSocketTransformer.upgrade(request);
          _handleIncomingConnection(socket);
        } catch (e) {
          print('Error upgrading to WebSocket: $e');
        }
      } else {
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
      }
    });
    
    print('P2P node listening on port $port');
  }
  
  // Handle a new incoming connection
  void _handleIncomingConnection(WebSocket socket) {
    // Wait for the initial handshake message with the peer's nodeId
    socket.listen((message) {
      try {
        final json = jsonDecode(message);
        if (json['type'] == 'handshake' && json['nodeId'] != null) {
          final peerId = json['nodeId'];
          
          // Avoid self-connections
          if (peerId == nodeId) {
            socket.close(1000, 'Self-connection rejected');
            return;
          }
          
          // Create a new peer connection
          final connection = PeerConnection(
            nodeId: peerId,
            socket: socket,
            eventBus: eventBus,
            isIncoming: true,
          );
          
          // Send our handshake response
          connection.sendHandshake();
          
          // Store the connection
          _connections[peerId] = connection;
          
          // Notify about the new connection
          eventBus.fire(PeerConnectedEvent(peerId));
          
          // Remove initial message handler
          socket.listen(null);
          
          // Set up the regular message handler
          connection.startListening();
        }
      } catch (e) {
        print('Error during handshake: $e');
        socket.close(1002, 'Invalid handshake');
      }
    }, onDone: () {
      // Connection closed before handshake completed
    });
  }
  
  // Connect to a peer given its address
  Future<bool> connectToPeer(PeerAddress address) async {
    // Skip if we're already connected to this peer
    if (_connections.containsKey(address.nodeId)) {
      return true;
    }
    
    try {
      // Connect via WebSocket
      final socket = await WebSocket.connect('ws://${address.host}:${address.port}');
      
      // Create a new peer connection
      final connection = PeerConnection(
        nodeId: address.nodeId,
        socket: socket,
        eventBus: eventBus,
        isIncoming: false,
      );
      
      // Send handshake
      connection.sendHandshake();
      
      // Store the connection
      _connections[address.nodeId] = connection;
      
      // Set up message handling
      connection.startListening();
      
      // Notify about the new connection
      eventBus.fire(PeerConnectedEvent(address.nodeId));
      
      return true;
    } catch (e) {
      print('Failed to connect to peer ${address.nodeId}: $e');
      return false;
    }
  }
  
  // Disconnect from a peer
  Future<void> disconnectFromPeer(String peerId) async {
    final connection = _connections.remove(peerId);
    if (connection != null) {
      await connection.close();
      eventBus.fire(PeerDisconnectedEvent(peerId));
    }
  }
  
  // Send a message to a specific peer
  Future<bool> sendToPeer(String peerId, Message message) async {
    final connection = _connections[peerId];
    if (connection != null) {
      return connection.sendMessage(message);
    }
    return false;
  }
  
  // Broadcast a message to all connected peers
  Future<Map<String, bool>> broadcast(Message message) async {
    final results = <String, bool>{};
    for (final entry in _connections.entries) {
      results[entry.key] = await entry.value.sendMessage(message);
    }
    return results;
  }
  
  // Stop the connection manager
  Future<void> stop() async {
    // Close all connections
    for (final connection in _connections.values) {
      await connection.close();
    }
    _connections.clear();
    
    // Stop listening for new connections
    await _server?.close();
  }
}

// Connection to a single peer
class PeerConnection {
  final String nodeId;
  final WebSocket socket;
  final EventBus eventBus;
  final bool isIncoming;
  bool _isHandshakeCompleted = false;
  
  PeerConnection({
    required this.nodeId,
    required this.socket,
    required this.eventBus,
    required this.isIncoming,
  });
  
  // Send a handshake message
  void sendHandshake() {
    final handshake = {
      'type': 'handshake',
      'nodeId': P2PContext.current.nodeId,
      'version': '1.0.0',
      'capabilities': ['sync', 'pubsub'],
    };
    socket.add(jsonEncode(handshake));
  }
  
  // Start listening for messages
  void startListening() {
    socket.listen(
      (message) => _handleMessage(message),
      onDone: () => eventBus.fire(PeerDisconnectedEvent(nodeId)),
      onError: (error) {
        print('Error in connection to $nodeId: $error');
        eventBus.fire(PeerDisconnectedEvent(nodeId));
      },
    );
  }
  
  // Handle an incoming message
  void _handleMessage(dynamic rawMessage) {
    try {
      final json = jsonDecode(rawMessage);
      
      // Handle handshake completion
      if (json['type'] == 'handshake' && !_isHandshakeCompleted) {
        _isHandshakeCompleted = true;
        return;
      }
      
      // Parse the message
      final message = Message.fromJson(json);
      
      // Fire the appropriate event based on message type
      switch (message.type) {
        case MessageType.sync:
          eventBus.fire(SyncMessageReceivedEvent(
            peerId: nodeId,
            message: message as SyncMessage,
          ));
          break;
        case MessageType.modelChange:
          eventBus.fire(ModelChangeMessageReceivedEvent(
            peerId: nodeId,
            message: message as ModelChangeMessage,
          ));
          break;
        case MessageType.snapshot:
          eventBus.fire(SnapshotMessageReceivedEvent(
            peerId: nodeId,
            message: message as SnapshotMessage,
          ));
          break;
        // Handle other message types
      }
    } catch (e) {
      print('Error handling message from $nodeId: $e');
    }
  }
  
  // Send a message to this peer
  Future<bool> sendMessage(Message message) async {
    try {
      socket.add(jsonEncode(message.toJson()));
      return true;
    } catch (e) {
      print('Error sending message to $nodeId: $e');
      return false;
    }
  }
  
  // Close the connection
  Future<void> close() async {
    await socket.close();
  }
}

## Synchronization Engine

The heart of EDNet P2P is the synchronization engine, which ensures that domain models remain consistent across all peers:

```dart
// Engine responsible for synchronizing domain models across peers
class SynchronizationEngine {
  final ConnectionManager connectionManager;
  final EventBus eventBus;
  final DomainModelRegistry modelRegistry;
  final Map<String, DateTime> _lastSyncTimes = {};
  Timer? _syncTimer;
  
  SynchronizationEngine({
    required this.connectionManager,
    required this.eventBus,
    required this.modelRegistry,
  });
  
  // Start the synchronization engine
  Future<void> start() async {
    // Listen for sync-related events
    _registerEventHandlers();
    
    // Start periodic synchronization
    _syncTimer = Timer.periodic(Duration(minutes: 5), (_) {
      _syncAllModels();
    });
  }
  
  // Register for synchronization-related events
  void _registerEventHandlers() {
    // Handle peer connection
    eventBus.on<PeerConnectedEvent>().listen((event) {
      // When a new peer connects, initiate synchronization
      _syncWithPeer(event.peerId);
    });
    
    // Handle sync request messages
    eventBus.on<SyncMessageReceivedEvent>().listen((event) {
      _handleSyncMessage(event.peerId, event.message);
    });
    
    // Handle model change messages
    eventBus.on<ModelChangeMessageReceivedEvent>().listen((event) {
      _handleModelChangeMessage(event.peerId, event.message);
    });
    
    // Handle snapshot messages
    eventBus.on<SnapshotMessageReceivedEvent>().listen((event) {
      _handleSnapshotMessage(event.peerId, event.message);
    });
    
    // Handle local model changes
    eventBus.on<LocalModelChangedEvent>().listen((event) {
      _handleLocalModelChange(event.modelId, event.changes);
    });
  }
  
  // Synchronize all models with a specific peer
  Future<void> _syncWithPeer(String peerId) async {
    for (final modelId in modelRegistry.registeredModels) {
      final syncMessage = SyncMessage(
        modelId: modelId,
        requestType: SyncRequestType.versionCheck,
      );
      
      await connectionManager.sendToPeer(peerId, syncMessage);
    }
  }
  
  // Synchronize all models with all peers
  Future<void> _syncAllModels() async {
    for (final peerId in connectionManager.connections.map((c) => c.nodeId)) {
      await _syncWithPeer(peerId);
    }
  }
  
  // Handle a sync message from a peer
  Future<void> _handleSyncMessage(String peerId, SyncMessage message) async {
    final modelId = message.modelId;
    final model = modelRegistry.getModel(modelId);
    
    if (model == null) {
      // We don't have this model
      return;
    }
    
    switch (message.requestType) {
      case SyncRequestType.versionCheck:
        // Peer is checking our version of the model
        final versionMessage = SyncMessage(
          modelId: modelId,
          requestType: SyncRequestType.versionResponse,
          versionVector: model.version,
        );
        await connectionManager.sendToPeer(peerId, versionMessage);
        break;
        
      case SyncRequestType.versionResponse:
        // Peer has sent their version, compare with ours
        if (message.versionVector != null) {
          final ourVersion = model.version;
          
          if (_needsSync(ourVersion, message.versionVector!)) {
            // Request changes since our version
            final requestChangesMessage = SyncMessage(
              modelId: modelId,
              requestType: SyncRequestType.requestChanges,
              versionVector: ourVersion,
            );
            await connectionManager.sendToPeer(peerId, requestChangesMessage);
          }
        }
        break;
        
      case SyncRequestType.requestChanges:
        // Peer is requesting changes since a specific version
        if (message.versionVector != null) {
          final changes = model.getChangesSince(message.versionVector!);
          
          if (changes.isNotEmpty) {
            // Send the changes
            final changesMessage = ModelChangeMessage(
              modelId: modelId,
              changes: changes,
            );
            await connectionManager.sendToPeer(peerId, changesMessage);
          }
        }
        break;
        
      case SyncRequestType.requestSnapshot:
        // Peer is requesting a full snapshot of the model
        final snapshot = await model.getSnapshot();
        final snapshotMessage = SnapshotMessage(
          modelId: modelId,
          snapshot: snapshot,
        );
        await connectionManager.sendToPeer(peerId, snapshotMessage);
        break;
    }
  }
  
  // Check if synchronization is needed based on version vectors
  bool _needsSync(VersionVector ourVersion, VersionVector theirVersion) {
    // If our version is ahead of theirs or vice versa, or if they're concurrent,
    // then synchronization is needed
    return !ourVersion.isIdenticalTo(theirVersion);
  }
  
  // Handle a model change message from a peer
  Future<void> _handleModelChangeMessage(
    String peerId,
    ModelChangeMessage message,
  ) async {
    final modelId = message.modelId;
    final model = modelRegistry.getModel(modelId);
    
    if (model == null || message.changes.isEmpty) {
      return;
    }
    
    try {
      // Apply the changes to our model
      final result = await model.applyChanges(message.changes);
      
      // Handle any conflicts that were detected
      if (result.conflicts.isNotEmpty) {
        await _handleConflicts(modelId, result.conflicts);
      }
      
      // Update the last sync time
      _lastSyncTimes[modelId] = DateTime.now();
      
      // Notify about the successful sync
      eventBus.fire(ModelSyncedEvent(
        modelId: modelId,
        peerId: peerId,
        changesApplied: message.changes.length,
      ));
    } catch (e) {
      print('Error applying changes to model $modelId: $e');
      
      // If there was an error, request a full snapshot instead
      final requestSnapshotMessage = SyncMessage(
        modelId: modelId,
        requestType: SyncRequestType.requestSnapshot,
      );
      await connectionManager.sendToPeer(peerId, requestSnapshotMessage);
    }
  }
  
  // Handle conflicts detected during change application
  Future<void> _handleConflicts(String modelId, List<ModelChange> conflicts) async {
    final model = modelRegistry.getModel(modelId);
    if (model == null) return;
    
    // Use the model's conflict resolver to resolve the conflicts
    final resolution = await model.resolveConflicts(conflicts);
    
    // If there are any changes resulting from conflict resolution, apply them
    if (resolution.changes.isNotEmpty) {
      await model.applyChanges(resolution.changes);
      
      // Broadcast these conflict resolution changes to all peers
      final changeMessage = ModelChangeMessage(
        modelId: modelId,
        changes: resolution.changes,
      );
      await connectionManager.broadcast(changeMessage);
    }
  }
  
  // Handle a snapshot message from a peer
  Future<void> _handleSnapshotMessage(
    String peerId,
    SnapshotMessage message,
  ) async {
    final modelId = message.modelId;
    final model = modelRegistry.getModel(modelId);
    
    if (model == null || message.snapshot == null) {
      return;
    }
    
    // Initialize our model from the snapshot
    final success = await model.initializeFromSnapshot(message.snapshot!);
    
    if (success) {
      // Update the last sync time
      _lastSyncTimes[modelId] = DateTime.now();
      
      // Notify about the successful sync
      eventBus.fire(ModelSyncedEvent(
        modelId: modelId,
        peerId: peerId,
        fullSnapshot: true,
      ));
    }
  }
  
  // Handle local changes to a model
  Future<void> _handleLocalModelChange(
    String modelId,
    List<ModelChange> changes,
  ) async {
    // Broadcast the changes to all peers
    final changeMessage = ModelChangeMessage(
      modelId: modelId,
      changes: changes,
    );
    await connectionManager.broadcast(changeMessage);
  }
  
  // Synchronize a specific model with all peers
  Future<SyncResult> synchronize(String modelId) async {
    final result = SyncResult(modelId: modelId);
    final model = modelRegistry.getModel(modelId);
    
    if (model == null) {
      result.success = false;
      result.errorMessage = 'Model not found';
      return result;
    }
    
    // Send version check to all peers
    final syncMessage = SyncMessage(
      modelId: modelId,
      requestType: SyncRequestType.versionCheck,
    );
    
    final broadcastResult = await connectionManager.broadcast(syncMessage);
    result.peerResults = broadcastResult;
    result.success = broadcastResult.values.any((success) => success);
    
    // Update the last sync time
    _lastSyncTimes[modelId] = DateTime.now();
    
    return result;
  }
  
  // Register a model for synchronization
  void registerModel(String modelId, SynchronizableDomainModel model) {
    modelRegistry.register(modelId, model);
  }
  
  // Stop the synchronization engine
  Future<void> stop() async {
    _syncTimer?.cancel();
  }
}

## Conflict Resolution

In a distributed system, conflicts are inevitable when multiple peers make concurrent changes to the same data. EDNet P2P provides several strategies for detecting and resolving these conflicts:

```dart
// Base interface for conflict resolvers
abstract class ConflictResolver {
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflicts);
}

// Automatic conflict resolution based on predefined strategies
class StrategyBasedResolver implements ConflictResolver {
  final Map<String, ConflictStrategy> _entityStrategies;
  final Map<String, ConflictStrategy> _attributeStrategies;
  final ConflictStrategy _defaultStrategy;
  
  StrategyBasedResolver({
    Map<String, ConflictStrategy>? entityStrategies,
    Map<String, ConflictStrategy>? attributeStrategies,
    ConflictStrategy defaultStrategy = ConflictStrategy.lastWriteWins,
  }) : 
    _entityStrategies = entityStrategies ?? {},
    _attributeStrategies = attributeStrategies ?? {},
    _defaultStrategy = defaultStrategy;
  
  @override
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflicts) async {
    final resolution = ConflictResolution();
    final groupedConflicts = _groupConflictsByEntity(conflicts);
    
    // Resolve conflicts for each entity
    for (final entry in groupedConflicts.entries) {
      final entityId = entry.key;
      final entityType = entry.value.first.entityType;
      final entityConflicts = entry.value;
      
      // Determine the strategy for this entity type
      final strategy = _entityStrategies[entityType] ?? _defaultStrategy;
      
      // Apply the strategy
      final entityResolution = await _applyStrategy(
        entityId,
        entityType,
        entityConflicts,
        strategy,
      );
      
      resolution.changes.addAll(entityResolution);
    }
    
    return resolution;
  }
  
  // Group conflicts by entity ID for processing
  Map<String, List<ModelChange>> _groupConflictsByEntity(List<ModelChange> conflicts) {
    final grouped = <String, List<ModelChange>>{};
    
    for (final conflict in conflicts) {
      final entityId = conflict.entityId;
      grouped.putIfAbsent(entityId, () => []).add(conflict);
    }
    
    return grouped;
  }
  
  // Apply a conflict resolution strategy to a set of conflicts
  Future<List<ModelChange>> _applyStrategy(
    String entityId,
    String entityType,
    List<ModelChange> conflicts,
    ConflictStrategy strategy,
  ) async {
    final resolvedChanges = <ModelChange>[];
    
    // Group conflicts by attribute
    final attributeConflicts = <String, List<ModelChange>>{};
    for (final conflict in conflicts) {
      if (conflict is AttributeChange) {
        attributeConflicts.putIfAbsent(conflict.attributeName, () => [])
          .add(conflict);
      } else if (conflict is RelationshipChange) {
        attributeConflicts.putIfAbsent(conflict.relationshipName, () => [])
          .add(conflict);
      }
    }
    
    // Resolve conflicts for each attribute
    for (final entry in attributeConflicts.entries) {
      final attributeName = entry.key;
      final attrConflicts = entry.value;
      
      // Determine the strategy for this attribute
      final attrKey = '$entityType.$attributeName';
      final attrStrategy = _attributeStrategies[attrKey] ?? strategy;
      
      // Apply the attribute-specific strategy
      switch (attrStrategy) {
        case ConflictStrategy.lastWriteWins:
          resolvedChanges.add(_resolveLastWriteWins(attrConflicts));
          break;
        case ConflictStrategy.firstWriteWins:
          resolvedChanges.add(_resolveFirstWriteWins(attrConflicts));
          break;
        case ConflictStrategy.merge:
          resolvedChanges.addAll(_resolveMerge(entityId, entityType, attributeName, attrConflicts));
          break;
        case ConflictStrategy.custom:
          // Custom strategies would be implemented by subclasses
          break;
      }
    }
    
    return resolvedChanges;
  }
  
  // Resolve using last-write-wins strategy
  ModelChange _resolveLastWriteWins(List<ModelChange> conflicts) {
    // Sort by timestamp, descending
    conflicts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Return the most recent change
    return conflicts.first;
  }
  
  // Resolve using first-write-wins strategy
  ModelChange _resolveFirstWriteWins(List<ModelChange> conflicts) {
    // Sort by timestamp, ascending
    conflicts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    // Return the earliest change
    return conflicts.first;
  }
  
  // Resolve by merging changes when possible
  List<ModelChange> _resolveMerge(
    String entityId,
    String entityType,
    String attributeName,
    List<ModelChange> conflicts,
  ) {
    // For relationship changes (e.g., collections), we can merge additions
    if (conflicts.first is RelationshipChange) {
      final additions = <String>{};
      final removals = <String>{};
      
      for (final conflict in conflicts) {
        final relChange = conflict as RelationshipChange;
        if (relChange.operation == RelationshipOperation.add) {
          additions.add(relChange.relatedEntityId);
        } else if (relChange.operation == RelationshipOperation.remove) {
          removals.add(relChange.relatedEntityId);
        }
      }
      
      // Remove any entity that was both added and removed (conflict)
      for (final removal in removals) {
        additions.remove(removal);
      }
      
      // Create merged changes - one per added entity that wasn't also removed
      return additions.map((relatedId) => 
        RelationshipChange(
          entityId: entityId,
          entityType: entityType,
          relationshipName: attributeName,
          relatedEntityId: relatedId,
          operation: RelationshipOperation.add,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          sourceNodeId: P2PContext.current.nodeId,
          sourceSequence: 0, // Will be set properly before sending
        )
      ).toList();
    }
    
    // For attribute changes, we default to last-write-wins if merging isn't possible
    return [_resolveLastWriteWins(conflicts)];
  }
}

// Custom conflict resolver that presents conflicts to the user
class UserInteractionResolver implements ConflictResolver {
  final ConflictResolver _automaticResolver;
  final UserInteractionService _userService;
  
  UserInteractionResolver(this._userService, [ConflictResolver? automaticResolver])
      : _automaticResolver = automaticResolver ?? StrategyBasedResolver();
  
  @override
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflicts) async {
    // Try automatic resolution first
    final autoResolution = await _automaticResolver.resolveConflicts(conflicts);
    
    // If there are still conflicts that couldn't be resolved automatically,
    // ask the user to resolve them
    final unresolvedConflicts = _findUnresolvedConflicts(conflicts, autoResolution.changes);
    
    if (unresolvedConflicts.isEmpty) {
      return autoResolution;
    }
    
    // Group remaining conflicts by entity for user presentation
    final entityConflicts = _groupConflictsByEntity(unresolvedConflicts);
    
    // Present each conflict to the user and get their decision
    for (final entry in entityConflicts.entries) {
      final entityId = entry.key;
      final entityConflicts = entry.value;
      
      final userResolutions = await _userService.resolveConflicts(
        entityId, 
        entityConflicts,
      );
      
      autoResolution.changes.addAll(userResolutions);
    }
    
    return autoResolution;
  }
  
  // Find conflicts that weren't resolved by the automatic resolution
  List<ModelChange> _findUnresolvedConflicts(
    List<ModelChange> conflicts,
    List<ModelChange> resolutions,
  ) {
    final unresolvedConflicts = <ModelChange>[];
    final resolvedAttrMap = <String, bool>{};
    
    // Mark which attributes were resolved
    for (final resolution in resolutions) {
      String key;
      if (resolution is AttributeChange) {
        key = '${resolution.entityId}.${resolution.attributeName}';
      } else if (resolution is RelationshipChange) {
        key = '${resolution.entityId}.${resolution.relationshipName}';
      } else {
        // Other change types
        key = resolution.entityId;
      }
      resolvedAttrMap[key] = true;
    }
    
    // Find conflicts that weren't resolved
    for (final conflict in conflicts) {
      String key;
      if (conflict is AttributeChange) {
        key = '${conflict.entityId}.${conflict.attributeName}';
      } else if (conflict is RelationshipChange) {
        key = '${conflict.entityId}.${conflict.relationshipName}';
      } else {
        // Other change types
        key = conflict.entityId;
      }
      
      if (!resolvedAttrMap.containsKey(key)) {
        unresolvedConflicts.add(conflict);
      }
    }
    
    return unresolvedConflicts;
  }
  
  // Group conflicts by entity ID for user presentation
  Map<String, List<ModelChange>> _groupConflictsByEntity(List<ModelChange> conflicts) {
    final grouped = <String, List<ModelChange>>{};
    
    for (final conflict in conflicts) {
      grouped.putIfAbsent(conflict.entityId, () => []).add(conflict);
    }
    
    return grouped;
  }
}
