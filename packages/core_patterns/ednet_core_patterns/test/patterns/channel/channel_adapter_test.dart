import 'dart:convert';
import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;
import 'package:test/test.dart';
import '../../mocks/patterns/channel/adapter_domain.dart';
import '../../mocks/patterns/channel/adapter_entities.dart';

void main() {
  group('Channel Adapter Pattern', () {
    late ChannelAdapterDomain testDomain;
    late patterns.InMemoryChannel channel;
    late TestHttpChannelAdapter httpAdapter;
    late TestWebSocketChannelAdapter wsAdapter;

    setUp(() {
      // Initialize domain model
      testDomain = ChannelAdapterDomain();

      // Create test channel
      channel = testDomain.createChannel(id: 'test-channel', broadcast: true);

      // Create HTTP adapter
      httpAdapter = testDomain.createHttpAdapter(
        channel: channel,
        baseUrl: 'https://api.example.com',
      );

      // Create WebSocket adapter
      wsAdapter = testDomain.createWebSocketAdapter(
        channel: channel,
        path: '/ws',
        protocol: 'json',
      );
    });

    tearDown(() async {
      await channel.close();
    });

    test(
      'HTTP Adapter connects external services to internal messaging infrastructure',
      () async {
        // Setup HTTP request data representing a citizen login
        final httpRequest = HttpRequest(
          method: 'POST',
          path: '/auth/login',
          headers: {'Content-Type': 'application/json'},
          body: '{"username": "citizen123", "password": "secure_password"}',
        );

        // Expect no messages initially
        expect(channel.messageCount, equals(0));

        // Process the request through the adapter (simulating citizen authentication)
        await httpAdapter.handleRequest(httpRequest);

        // Verify a message was sent to the channel (authentication request delivered to internal system)
        expect(channel.messageCount, equals(1));

        // Get the message
        final message = await channel.receive().first;

        // Verify message contains the expected data for citizen login
        expect(message.metadata['httpMethod'], equals('POST'));
        expect(message.metadata['httpPath'], equals('/auth/login'));
        expect(message.payload, isA<Map>());
        expect(message.payload['username'], equals('citizen123'));
      },
    );

    test(
      'HTTP Adapter translates internal messages to external HTTP responses',
      () async {
        // Create message simulating successful voter registration
        final message = patterns.Message(
          payload: {
            'id': 'V123456',
            'name': 'Jane Citizen',
            'voterStatus': 'VERIFIED',
            'votingRights': ['NATIONAL', 'LOCAL'],
          },
          metadata: {'httpStatusCode': 201, 'contentType': 'application/json'},
        );

        // Convert message to HTTP response for external system
        final response = await httpAdapter.handleOutgoingMessage(message);

        // Verify response format for external system
        expect(response.statusCode, equals(201)); // Created
        expect(response.headers['Content-Type'], equals('application/json'));
        expect(response.body, contains('Jane Citizen'));

        // Verify we can parse the body back to JSON (external system receiving data)
        final responseBody = json.decode(response.body);
        expect(responseBody['id'], equals('V123456'));
        expect(responseBody['voterStatus'], equals('VERIFIED'));
        expect(responseBody['votingRights'], contains('NATIONAL'));
      },
    );

    test(
      'WebSocket Adapter facilitates real-time deliberation participation',
      () async {
        // Simulated citizen's message joining a deliberation
        final wsData =
            '{"action": "join", "deliberationId": "proposal-42", "citizenId": "C789012"}';

        // Process the citizen's WebSocket message
        await wsAdapter.handleIncomingData(wsData);

        // Verify a message was sent to the internal channel
        expect(channel.messageCount, equals(1));

        // Get the message delivered to the democracy platform core
        final incomingMessage = await channel.receive().first;

        // Verify message contains the citizen's participation data
        expect(incomingMessage.metadata['source'], equals('websocket'));
        expect(incomingMessage.metadata['path'], equals('/ws'));
        expect(incomingMessage.payload['action'], equals('join'));
        expect(
          incomingMessage.payload['deliberationId'],
          equals('proposal-42'),
        );

        // Create outgoing message with live participation update
        final outgoingMessage = patterns.Message(
          payload: {
            'event': 'participantJoined',
            'deliberationId': 'proposal-42',
            'participantCount': 42,
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {'broadcast': true},
        );

        // Process outgoing update to all citizens
        final wsResponse = await wsAdapter.handleOutgoingMessage(
          outgoingMessage,
        );

        // Verify response contains the participation update data
        expect(wsResponse, contains('participantJoined'));
        expect(wsResponse, contains('proposal-42'));
      },
    );

    test(
      'Channel Adapter lifecycle is properly managed for secure communication',
      () async {
        // Verify initial status (inactive = not listening to citizen data)
        expect(httpAdapter.status, equals('inactive'));

        // Start adapter (begin listening for citizen communications)
        await httpAdapter.start();

        // Verify active status (ready to process citizen data)
        expect(httpAdapter.status, equals('active'));

        // Stop adapter (cease operations, e.g., during maintenance)
        await httpAdapter.stop();

        // Verify inactive status (no longer processing citizen communications)
        expect(httpAdapter.status, equals('inactive'));
      },
    );

    test(
      'Channel Adapter configuration supports different democratic contexts',
      () {
        // Verify initialized properties for this democratic jurisdiction
        expect(httpAdapter.name, equals('test-http-adapter'));
        expect(httpAdapter.type, equals('HTTP'));
        expect(httpAdapter.baseUrl, equals('https://api.example.com'));

        // Verify configuration can be properly encoded/decoded for persistence
        final config = json.decode(httpAdapter.getProperty('configuration'));
        expect(config['baseUrl'], equals('https://api.example.com'));
      },
    );
  });
}
