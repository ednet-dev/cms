# EDNet Code Generation

[![Pub Version](https://img.shields.io/pub/v/ednet_code_generation.svg)](https://pub.dev/packages/ednet_code_generation)
[![License](https://img.shields.io/github/license/ednet-dev/cms)](https://github.com/ednet-dev/cms/blob/main/LICENSE)

A **CLI-driven** and programmatic code generator for **[EDNet Core](https://pub.dev/packages/ednet_core)** domain models. With **EDNet Code Generation**, you can transform YAML-based domain definitions into fully scaffolded, **domain-driven** Dart projects—saving you from boilerplate and keeping your code closely aligned with your business logic.

---

## Features

1. **YAML → Dart**: Start from a simple YAML schema describing your domain and let EDNet Code Generation produce:
   - Repositories
   - Entities and their attributes
   - Relation definitions
   - Scaffolding for tests & docs

2. **Integration-Ready**: The generated projects plug seamlessly into the **EDNet ecosystem**—including [ednet_core](https://pub.dev/packages/ednet_core), [ednet_cms](https://github.com/ednet-dev/cms/tree/main/packages/cms), and more.

3. **Two Generation Modes**:
   - **`--genall`**: Create a brand-new Dart project structure (ideal for new domains).
   - **`--gengen`**: Update/re-generate code in an existing project without overwriting top-level configuration.

4. **Multiple Models**: Generate multiple domain models in a single command (e.g., `finance`, `hr`, `sales`, etc.) from their respective YAML files.

---

## Installation

Add **EDNet Code Generation** to your `pubspec.yaml` in the **dev_dependencies** section:

```yaml
dev_dependencies:
  ednet_code_generation: ^0.0.5
```
Then fetch the package:

dart pub get
### or
flutter pub get

	Note: For best results, ensure you also include ednet_core in your dependencies or dev_dependencies.

## Quick Start

Below is a step-by-step guide to generating a new domain-driven Dart project. We’ll assume you have a YAML file describing your domain, for example:

| # lib/requirements/financial/ledger.yaml
```yaml
domain: Financial
model: Ledger

concepts:
  - name: Account
    attributes:
      - name: accountNumber
        type: string
      - name: balance
        type: number

  - name: Transaction
    attributes:
      - name: amount
        type: number
      - name: transactionDate
        type: datetime
      - name: description
        type: string

relations:
  - from: Account
    fromToName: transactions
    to: Transaction
    toFromName: account
    fromToCardinality:
      min: 0
      max: N
    toFromCardinality:
      min: 1
      max: 1
```
1. Organize Your YAML

Place your .yaml file(s) under a path you’ll reference—like lib/requirements/financial/ledger.yaml.

2. Run the Generator

Use the EDNet Code Generation CLI from within your project:
```
dart run ednet_code_generation:main \
  --genall lib/requirements/financial \
  build/financial_dart_project \
  financial ledger
```
	•	--genall: Instructs the generator to create a full Dart project.
	•	lib/requirements/financial: Base directory where our .yaml is located.
	•	build/financial_dart_project: Output directory for the new project.
	•	financial ledger: Domain name (financial) and model name (ledger).

When the command finishes, check build/financial_dart_project—you’ll see:
```
build/financial_dart_project/
  ├─ lib/
  │   ├─ financial_ledger.dart
  │   ├─ repository.dart
  │   ├─ financial/
  │   │   ├─ ledger/
  │   │   │   ├─ model.dart
  │   │   │   ├─ json/
  │   │   │   │   ├─ data.dart
  │   │   │   │   ├─ model.dart
  │   │   │   ├─ account.dart
  │   │   │   ├─ transaction.dart
  │   │   └─ domain.dart
  ├─ test/
  │   ├─ financial/ledger/...
  ├─ doc/
  ├─ .gitignore
  ├─ pubspec.yaml
  └─ README.md
```
3. Explore & Customize
	•	lib/financial_ledger.dart: Main entry to your domain model library.
	•	repository.dart: Defines a CoreRepository with your domain(s).
	•	account.dart and transaction.dart: Dart classes representing domain concepts.
	•	test/: Auto-generated test scaffolding to jumpstart your TDD/BDD journey.
	•	pubspec.yaml: Baseline file referencing ednet_core and other dependencies.

## Advanced Usage
	1.	Regenerate in an Existing Project
If you make changes to your domain model in YAML, run with --gengen:
```bash
dart run ednet_code_generation:main \
  --gengen build/financial_dart_project
```
This updates internal Dart library files without overwriting your top-level config (like pubspec.yaml).

	2.	Multiple Models
Generate multiple models in one command:
```bash
dart run ednet_code_generation:main \
  --genall lib/requirements/financial \
  build/financial_dart_project \
  financial ledger investments accounts
```
Each of ledger, investments, and accounts needs its own <model>.yaml in lib/requirements/financial/.

	3.	Scripted Approach
Programmatically call the generator from your own Dart code using the EDNetCodeGenerator class:
```dart
import 'dart:io';
import 'package:ednet_code_generation/ednet_code_generation.dart';

void main() async {
  final result = await EDNetCodeGenerator.generate(
    sourceDir: 'lib/requirements/financial',
    targetDir: 'build/financial_dart_project',
    domainName: 'financial',
    models: 'ledger',
  );
  print(result); // 'Code generation completed!'
}
```
### Tips & Best Practices
	•	Keep Domain & Model Names Descriptive: Reflect real business logic for clarity (e.g., financial / ledger, education / learning).
	•	Leverage the Tests: EDNet Code Generation creates basic test files for each concept. Fill these out to solidify domain invariants.
	•	Combine with EDNet CMS: Once your domain is stable, EDNet CMS can interpret it to build content-rich Flutter experiences.

### Troubleshooting
	•	YAML Not Found: Ensure file names, paths, and domain/model arguments match exactly.
	•	Invalid Domain or Model Name: The tool forbids certain reserved names (like domain or model). Use something more descriptive.
	•	Dependencies Outdated: Check that your Dart SDK (>=3.5.0-180.3.beta) and ednet_core versions meet minimum requirements.

## Contributing

We welcome community contributions!
	•	File issues or feature requests: GitHub Issues
	•	Pull Requests: Fork the CMS monorepo, update code in packages/code_generation/, and submit your PR.

## Contact

For any questions:

- **Email**: [dev@ednet.dev](mailto:dev@ednet.dev)
- **GitHub Discussions**: [https://github.com/ednet-dev/cms/discussions](https://github.com/ednet-dev/cms/discussions)
- **Discord**: [EDNet Dev Community](https://discord.gg/7E7bPjNMG3)

## License

Part of the EDNet.dev ecosystem. Licensed under the MIT License.

For more details, please visit the GitHub repository or explore additional documentation at https://ednet.dev.

<br/>


<p align="center">
  <img src="https://img1.wsimg.com/isteam/ip/4896c6bc-229c-47e9-afdd-ff5ab2d2fdbf/Logo-eb329c1.png/:/rs=w:107,h:107,cg:true,m/cr=w:107,h:107/qt=q:95" width="80" alt="EDNet Logo"/>
</p>


<p align="center">
  <b>Build robust domain-driven apps faster with EDNet Code Generation.</b>
</p>
