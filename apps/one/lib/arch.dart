/// BSD 3-Clause License
/// Copyright (c) 2023, EDNetCore project authors
/// All rights reserved.
///
/// Redistribution and use in source and binary forms, with or without
/// modification, are permitted provided that the following conditions are met:
///     * Redistributions of source code must retain the above copyright
///       notice, this list of conditions and the following disclaimer.
///     * Redistributions in binary form must reproduce the above copyright
///       notice, this list of conditions and the following disclaimer in the
///       documentation and/or other materials provided with the distribution.
///     * Neither the name of the EDNetCore nor the
///       names of its contributors may be used to endorse or promote products
///       derived from this software without specific prior written permission.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
/// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
/// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
/// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
/// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
/// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library ednet_core_architecture;

import 'package:ednet_core/ednet_core.dart';
import 'package:yaml/yaml.dart';

// repository.dart
class EdnetCoreArchitectureRepo extends CoreRepository {
  EdnetCoreArchitectureRepo([super.code = repository]) {
    final domain = Domain('EdnetCoreArchitecture');
    domains.add(domain);
    add(EdnetCoreArchitectureDomain(domain));
  }

  static const repository = 'EdnetCoreArchitectureRepo';
}

// gen/architecture/i_domain_models.dart
class EdnetCoreArchitectureModels extends DomainModels {
  EdnetCoreArchitectureModels(Domain domain) : super(domain) {
    final model = fromJsonToModel(
      '',
      domain,
      'ednet_core_architecture',
      loadYaml(ednetCoreArchitectureModelYaml) as Map<dynamic, dynamic>,
    );
    final architectureModel = EdnetCoreArchitectureModel(model);
    add(architectureModel);
  }
}

// gen/architecture/ednet_core_architecture/model_entries.dart
class EdnetCoreArchitectureEntries extends ModelEntries {
  EdnetCoreArchitectureEntries(super.model);

  @override
  Map<String, Entities> newEntries() {
    final entries = <String, Entities>{};
    entries['CoreMotivation'] =
        CoreMotivations(model.concepts.singleWhereCode('CoreMotivation')!);
    entries['Artifact'] =
        Artifacts(model.concepts.singleWhereCode('Artifact')!);
    entries['CrossCuttingConcern'] = CrossCuttingConcerns(
        model.concepts.singleWhereCode('CrossCuttingConcern')!);
    entries['Outcome'] = Outcomes(model.concepts.singleWhereCode('Outcome')!);
    entries['Layer'] = Layers(model.concepts.singleWhereCode('Layer')!);
    return entries;
  }

  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }
    if (concept.code == 'CoreMotivation') return CoreMotivations(concept);
    if (concept.code == 'Artifact') return Artifacts(concept);
    if (concept.code == 'CrossCuttingConcern')
      return CrossCuttingConcerns(concept);
    if (concept.code == 'Outcome') return Outcomes(concept);
    if (concept.code == 'Layer') return Layers(concept);
    return null;
  }

  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }
    if (concept.code == 'CoreMotivation') return CoreMotivation(concept);
    if (concept.code == 'Artifact') return Artifact(concept);
    if (concept.code == 'CrossCuttingConcern')
      return CrossCuttingConcern(concept);
    if (concept.code == 'Outcome') return Outcome(concept);
    if (concept.code == 'Layer') return Layer(concept);
    return null;
  }

  CoreMotivations get coreMotivations =>
      getEntry('CoreMotivation') as CoreMotivations;

  Artifacts get artifacts => getEntry('Artifact') as Artifacts;

  CrossCuttingConcerns get crossCuttingConcerns =>
      getEntry('CrossCuttingConcern') as CrossCuttingConcerns;

  Outcomes get outcomes => getEntry('Outcome') as Outcomes;

  Layers get layers => getEntry('Layer') as Layers;
}

// architecture/domain.dart
class EdnetCoreArchitectureDomain extends EdnetCoreArchitectureModels {
  EdnetCoreArchitectureDomain(super.domain);
}

// architecture/ednet_core_architecture/model.dart
class EdnetCoreArchitectureModel extends EdnetCoreArchitectureEntries {
  EdnetCoreArchitectureModel(super.model);

  void fromJsonToModel() {
    fromJson(ednetCoreArchitectureData);
  }

  void init() {
    // Optionally initialize with data here if needed
  }
}

// architecture/ednet_core_architecture/json/data.dart
String ednetCoreArchitectureData = r'''
{
  "CoreMotivation": [
    {
      "intention": "Provide a domain-centric, platform-agnostic framework",
      "rationale": "Separate concerns, foster maintainability",
      "influences": "DDD, code generation, separation of concerns",
      "impactOnEnvironment": "Reduces coupling, fosters reuse"
    }
  ],
  "Layer": [
    {"name": "DomainLayer", "artifactType": "Conceptual backbone"},
    {"name": "ModelEntries", "artifactType": "Data access abstraction"},
    {"name": "Concepts", "artifactType": "Semantic units"},
    {"name": "Entities", "artifactType": "Stateful domain instances"},
    {"name": "Attributes", "artifactType": "Data primitives"},
    {"name": "Repositories", "artifactType": "Persistence abstraction"},
    {"name": "CodeGeneration", "artifactType": "Productivity tooling"},
    {"name": "IntegrationPoints", "artifactType": "External connectors"}
  ],
  "Artifact": [
    {
      "name": "DomainLayer",
      "motivation": "Define the ubiquitous language",
      "structure": "Domains, Models, Concepts",
      "influencesOnEnvironment": "Guides all downstream layers",
      "influencedByEnvironment": "Evolves with domain requirements"
    },
    {
      "name": "ModelEntries",
      "motivation": "Encapsulate entity collections",
      "structure": "Entry points for CRUD",
      "influencesOnEnvironment": "Enables backend flexibility",
      "influencedByEnvironment": "Storage tech & scaling"
    },
    {
      "name": "Concepts",
      "motivation": "Represent meaningful domain abstractions",
      "structure": "Entities, attributes, invariants",
      "influencesOnEnvironment": "Drives UI forms, validations",
      "influencedByEnvironment": "Business feedback"
    },
    {
      "name": "Entities",
      "motivation": "Manage state & identity",
      "structure": "Instances of concepts",
      "influencesOnEnvironment": "Feeds logic and workflows",
      "influencedByEnvironment": "Persistence and caching"
    },
    {
      "name": "Attributes",
      "motivation": "Ensure data integrity and type safety",
      "structure": "Typed fields, constraints",
      "influencesOnEnvironment": "Affects UI, DB schema",
      "influencedByEnvironment": "Localization & compliance"
    },
    {
      "name": "Repositories",
      "motivation": "Abstract persistence layer",
      "structure": "Interfaces, adapters",
      "influencesOnEnvironment": "Storage and scalability",
      "influencedByEnvironment": "Performance & consistency needs"
    },
    {
      "name": "CodeGeneration",
      "motivation": "Automate boilerplate",
      "structure": "DSL parsing, code templates",
      "influencesOnEnvironment": "Consistent code standards",
      "influencedByEnvironment": "Domain growth and complexity"
    },
    {
      "name": "IntegrationPoints",
      "motivation": "Connect domain with external systems",
      "structure": "APIs, adapters",
      "influencesOnEnvironment": "Modularity and deployment",
      "influencedByEnvironment": "Protocols, security policies"
    }
  ],
  "CrossCuttingConcern": [
    {
      "name": "Security",
      "motivation": "Protect domain integrity",
      "influencesOnEnvironment": "Access control, encryption",
      "influencedByEnvironment": "Compliance & threat models"
    },
    {
      "name": "Performance",
      "motivation": "Ensure scalability & responsiveness",
      "influencesOnEnvironment": "Caching, indexing",
      "influencedByEnvironment": "User demand & hardware"
    },
    {
      "name": "TestingAndValidation",
      "motivation": "Maintain correctness & reliability",
      "influencesOnEnvironment": "Automated tests, CI/CD",
      "influencedByEnvironment": "Complexity & feedback loops"
    }
  ],
  "Outcome": [
    {
      "goal": "Domain-centric foundation, easy to adapt",
      "longTermVision": "Stable, extensible architecture",
      "ecosystemInfluence": "Unify complex systems, reduce debt"
    }
  ]
}
''';

// architecture/ednet_core_architecture/json/model.dart
String ednetCoreArchitectureModelYaml = r'''
domain: "EdnetCoreArchitecture"
model: "ednet_core_architecture"

concepts:
  - name: CoreMotivation
    attributes:
      - name: intention
        type: String
      - name: rationale
        type: String
      - name: influences
        type: String
      - name: impactOnEnvironment
        type: String

  - name: Layer
    attributes:
      - name: name
        type: String
      - name: artifactType
        type: String

  - name: Artifact
    attributes:
      - name: name
        type: String
      - name: motivation
        type: String
      - name: structure
        type: String
      - name: influencesOnEnvironment
        type: String
      - name: influencedByEnvironment
        type: String

  - name: CrossCuttingConcern
    attributes:
      - name: name
        type: String
      - name: motivation
        type: String
      - name: influencesOnEnvironment
        type: String
      - name: influencedByEnvironment
        type: String

  - name: Outcome
    attributes:
      - name: goal
        type: String
      - name: longTermVisionx
        type: String
      - name: ecosystemInfluence
        type: String

relations:
  - from: Artifact
    to: Layer
    fromToName: belongsToLayer
    toFromName: hasArtifacts
    id:
      from: true
      to: false
    fromToCardinality:
      min: 0
      max: N
    toFromCardinality:
      min: 1
      max: N

''';

// architecture/ednet_core_architecture/core_motivations.dart
class CoreMotivation extends CoreMotivationGen {
  CoreMotivation(Concept concept) : super(concept);
}

class CoreMotivations extends CoreMotivationsGen {
  CoreMotivations(Concept concept) : super(concept);
}

// architecture/ednet_core_architecture/artifacts.dart
class Artifact extends ArtifactGen {
  Artifact(Concept concept) : super(concept);
}

class Artifacts extends ArtifactsGen {
  Artifacts(Concept concept) : super(concept);
}

// architecture/ednet_core_architecture/cross_cutting_concerns.dart
class CrossCuttingConcern extends CrossCuttingConcernGen {
  CrossCuttingConcern(Concept concept) : super(concept);
}

class CrossCuttingConcerns extends CrossCuttingConcernsGen {
  CrossCuttingConcerns(Concept concept) : super(concept);
}

// architecture/ednet_core_architecture/outcomes.dart
class Outcome extends OutcomeGen {
  Outcome(Concept concept) : super(concept);
}

class Outcomes extends OutcomesGen {
  Outcomes(Concept concept) : super(concept);
}

// architecture/ednet_core_architecture/layers.dart
class Layer extends LayerGen {
  Layer(Concept concept) : super(concept);
}

class Layers extends LayersGen {
  Layers(Concept concept) : super(concept);
}

// gen/architecture/ednet_core_architecture/core_motivations.dart
abstract class CoreMotivationGen extends Entity<CoreMotivation> {
  CoreMotivationGen(Concept concept) {
    this.concept = concept;
  }

  String get intention => getAttribute('intention') as String;

  set intention(String a) => setAttribute('intention', a);

  String get rationale => getAttribute('rationale') as String;

  set rationale(String a) => setAttribute('rationale', a);

  String get influences => getAttribute('influences') as String;

  set influences(String a) => setAttribute('influences', a);

  String get impactOnEnvironment =>
      getAttribute('impactOnEnvironment') as String;

  set impactOnEnvironment(String a) => setAttribute('impactOnEnvironment', a);

  @override
  CoreMotivation newEntity() => CoreMotivation(concept);

  @override
  CoreMotivations newEntities() => CoreMotivations(concept);
}

abstract class CoreMotivationsGen extends Entities<CoreMotivation> {
  CoreMotivationsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  CoreMotivations newEntities() => CoreMotivations(concept);

  @override
  CoreMotivation newEntity() => CoreMotivation(concept);
}

// gen/architecture/ednet_core_architecture/artifacts.dart
abstract class ArtifactGen extends Entity<Artifact> {
  ArtifactGen(Concept concept) {
    this.concept = concept;
  }

  Reference get belongsToLayerReference => getReference('belongsToLayer')!;

  set belongsToLayerReference(Reference reference) =>
      setReference('belongsToLayer', reference);

  Layer get belongsToLayer => getParent('belongsToLayer')! as Layer;

  set belongsToLayer(Layer p) => setParent('belongsToLayer', p);

  String get name => getAttribute('name') as String;

  set name(String a) => setAttribute('name', a);

  String get motivation => getAttribute('motivation') as String;

  set motivation(String a) => setAttribute('motivation', a);

  String get structure => getAttribute('structure') as String;

  set structure(String a) => setAttribute('structure', a);

  String get influencesOnEnvironment =>
      getAttribute('influencesOnEnvironment') as String;

  set influencesOnEnvironment(String a) =>
      setAttribute('influencesOnEnvironment', a);

  String get influencedByEnvironment =>
      getAttribute('influencedByEnvironment') as String;

  set influencedByEnvironment(String a) =>
      setAttribute('influencedByEnvironment', a);

  @override
  Artifact newEntity() => Artifact(concept);

  @override
  Artifacts newEntities() => Artifacts(concept);
}

abstract class ArtifactsGen extends Entities<Artifact> {
  ArtifactsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Artifacts newEntities() => Artifacts(concept);

  @override
  Artifact newEntity() => Artifact(concept);
}

// gen/architecture/ednet_core_architecture/cross_cutting_concerns.dart
abstract class CrossCuttingConcernGen extends Entity<CrossCuttingConcern> {
  CrossCuttingConcernGen(Concept concept) {
    this.concept = concept;
  }

  String get name => getAttribute('name') as String;

  set name(String a) => setAttribute('name', a);

  String get motivation => getAttribute('motivation') as String;

  set motivation(String a) => setAttribute('motivation', a);

  String get influencesOnEnvironment =>
      getAttribute('influencesOnEnvironment') as String;

  set influencesOnEnvironment(String a) =>
      setAttribute('influencesOnEnvironment', a);

  String get influencedByEnvironment =>
      getAttribute('influencedByEnvironment') as String;

  set influencedByEnvironment(String a) =>
      setAttribute('influencedByEnvironment', a);

  @override
  CrossCuttingConcern newEntity() => CrossCuttingConcern(concept);

  @override
  CrossCuttingConcerns newEntities() => CrossCuttingConcerns(concept);
}

abstract class CrossCuttingConcernsGen extends Entities<CrossCuttingConcern> {
  CrossCuttingConcernsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  CrossCuttingConcerns newEntities() => CrossCuttingConcerns(concept);

  @override
  CrossCuttingConcern newEntity() => CrossCuttingConcern(concept);
}

// gen/architecture/ednet_core_architecture/outcomes.dart
abstract class OutcomeGen extends Entity<Outcome> {
  OutcomeGen(Concept concept) {
    this.concept = concept;
  }

  String get goal => getAttribute('goal') as String;

  set goal(String a) => setAttribute('goal', a);

  String get longTermVision => getAttribute('longTermVision') as String;

  set longTermVision(String a) => setAttribute('longTermVision', a);

  String get ecosystemInfluence => getAttribute('ecosystemInfluence') as String;

  set ecosystemInfluence(String a) => setAttribute('ecosystemInfluence', a);

  @override
  Outcome newEntity() => Outcome(concept);

  @override
  Outcomes newEntities() => Outcomes(concept);
}

abstract class OutcomesGen extends Entities<Outcome> {
  OutcomesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Outcomes newEntities() => Outcomes(concept);

  @override
  Outcome newEntity() => Outcome(concept);
}

// gen/architecture/ednet_core_architecture/layers.dart
abstract class LayerGen extends Entity<Layer> {
  LayerGen(Concept concept) {
    this.concept = concept;
    final artifactConcept = concept.model.concepts.singleWhereCode('Artifact');
    assert(artifactConcept != null, 'Artifact concept is not defined.');
    setChild('hasArtifacts', Artifacts(artifactConcept!));
  }

  String get name => getAttribute('name') as String;

  set name(String a) => setAttribute('name', a);

  String get artifactType => getAttribute('artifactType') as String;

  set artifactType(String a) => setAttribute('artifactType', a);

  Artifacts get hasArtifacts => getChild('hasArtifacts')! as Artifacts;

  @override
  Layer newEntity() => Layer(concept);

  @override
  Layers newEntities() => Layers(concept);
}

abstract class LayersGen extends Entities<Layer> {
  LayersGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Layers newEntities() => Layers(concept);

  @override
  Layer newEntity() => Layer(concept);
}

// main.dart (example usage):
void main() {
  final repo = EdnetCoreArchitectureRepo();
  final domain = repo.getDomainModels('EdnetCoreArchitecture');
  final model = domain?.getModelEntries('ednet_core_architecture')
      as EdnetCoreArchitectureModel;

  model.fromJsonToModel();
  // Now model contains the loaded data from ednetCoreArchitectureData.
}
