# EDNet Drift Repository

A Powerful Drift-backed Repository for EDNet Core Domain Models

[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)
[![pub package](https://img.shields.io/pub/v/ednet_drift_repository.svg)](https://pub.dev/packages/ednet_drift_repository)

Hey Dart devs! 👋 Ready to take your EDNet Core domain models to the next level? Meet **EDNet Drift Repository**, your reliable solution for persistent, scalable, and type-safe domain model management using [Drift](https://pub.dev/packages/drift).

---

## 🎯 What's EDNet Drift Repository?

EDNet Drift Repository seamlessly integrates EDNet Core's powerful domain-driven modeling with Drift’s expressive, type-safe, and multiplatform database capabilities. Think of it as your domain's trusted database manager—keeping your entities safe, organized, and accessible at all times.

Whether you're building robust Flutter apps, backend services, or multiplatform software, EDNet Drift Repository ensures your domain models persist reliably and efficiently.

---

## 🚀 Why EDNet Drift Repository?

If you've ever thought, "I love EDNet Core, but managing persistence feels tricky," then this library is for you. Here's why:

1. **Easy Integration**: Automatically generates database tables and schema directly from your EDNet domain model definitions.
2. **Safety First**: Type-safe, fully validated operations ensure your data stays consistent.
3. **Performance**: Efficient SQL queries and optimized database operations powered by Drift.
4. **Multiplatform Support**: Works flawlessly on Web, Mobile (Android/iOS), Desktop, and Server environments.

---

## 🧩 How it Works: Explained Simply

Imagine your domain model is a big, friendly LEGO castle 🏰.

- **EDNet Core** helps you build and structure this castle neatly.
- **Drift** gives you sturdy shelves to store each LEGO brick safely.
- **EDNet Drift Repository** effortlessly connects your neatly organized castle (EDNet Core models) to these safe shelves (Drift tables), ensuring your bricks (data entities) are always exactly where you left them.

---

## 🌟 Features

- **Automated Schema Generation**: No manual database setup; your EDNet Core domain definitions automatically become database tables.
- **CRUD Simplicity**: Create, Read, Update, and Delete domain entities with ease.
- **Advanced Domain Constraints**: Enforce uniqueness, cardinalities, and essential relationships automatically.
- **Lifecycle Tracking**: Automatically track timestamps (`whenAdded`, `whenSet`, `whenRemoved`) for your domain entities.
- **Robust Testing Suite**: Extensive tests included, ensuring rock-solid reliability.
- **Easy Integration with Existing EDNet Projects**: Fully compatible with EDNet Core, CMS, and other ecosystem tools.

---

## 🚦 Getting Started: A Friendly Tutorial

### 1. 📦 Install Dependencies

In your project's `pubspec.yaml`, add:

```yaml
dependencies:
  ednet_core: ^1.0.0
  ednet_drift_repository: latest
  drift: ^2.26.0

dev_dependencies:
  build_runner: ^2.4.10
  drift_dev: ^2.26.0
```
Run this command to install:

```bash 
dart pub get
# or, if using Flutter
flutter pub get
```
---


2. 🛠 Define Your Domain Model

First, clearly define your domain model using EDNet Core’s conventions:

```dart
import 'package:ednet_core/ednet_core.dart';

class TodoDomain extends Domain {
  TodoDomain() : super("Todo");
}

class TodoModel extends ModelEntries {
  late Tasks tasks;

  TodoModel(Domain domain) : super(domain, "TodoModel") {
    tasks = Tasks(this);
    addEntry("Task", tasks);
  }
}

class Task extends Entity<Task> {
  String title = "";
  bool done = false;

  Task(Concept concept) : super(concept);
}

class Tasks extends Entities<Task> {
  Tasks(ModelEntries modelEntries) : super(modelEntries);
}
```
---
3. 🧙‍♂️ Initialize the DriftCoreRepository

Now, bring your domain model into Drift:

```dart
import 'package:ednet_drift_repository/ednet_drift_repository.dart';

final domain = TodoDomain();
final todoModel = TodoModel(domain);
domain.addModelEntries(todoModel);

final repository = DriftCoreRepository(domains: [domain]);
```
---
4. 💾 Use Your Repository (CRUD Example)

Let’s insert a new Task:

```dart
final task = Task(todoModel.tasks.concept!)
  ..title = 'Setup Drift repository'
  ..done = false;

await repository.insertEntity(task);
```

Easy, right? ✅ Your entity is now safely stored in your database!

---

5. 🔍 Retrieve and Update Entities

Fetch your entity back:

```dart
final fetchedTask = await repository.loadEntityByOid<Task>(todoModel.tasks.concept!, task.oid!);
print(fetchedTask?.title); // Output: Setup Drift repository
```

Update its details:

```dart
fetchedTask?.title = 'Update documentation';
await repository.updateEntity(fetchedTask!);
```
---

6. 🗑 Delete Entities (Safely)

Deleting an entity is straightforward:

```dart
await repository.deleteEntity(task);
```
>EDNet Drift Repository ensures domain constraints, like essential relationships, are respected before deleting.
---

🧪 Extensive Built-in Tests

EDNet Drift Repository comes with an exhaustive testing suite demonstrating best practices and verifying each functionality:
- Database initialization and schema creation.
- Entity insertion, updates, and deletions.
- Attribute validation and enforcement of domain rules.
- Persistence and reloading of entities.


## Join the EDNet.dev Community

We're not just building a library; we're cultivating a community of Flutter developers who believe
in building scalable, maintainable apps. Join us on [GitHub](https://github.com/ednet-dev/cms) to
contribute, report issues, or just say hi!

## 📄 License

Individual packages and applications within this repository have their own licenses, - see
the [LICENSE](LICENSE) file for details.

## Contact

For any questions:

- **Email**: [dev@ednet.dev](mailto:dev@ednet.dev)
- **GitHub Discussions**: [https://github.com/ednet-dev/cms/discussions](https://github.com/ednet-dev/cms/discussions)
- **Discord**: [EDNet Dev Community](https://discord.gg/7E7bPjNMG3)

---
&nbsp;
<div align="center">

![EDNet One](https://img1.wsimg.com/isteam/ip/4896c6bc-229c-47e9-afdd-ff5ab2d2fdbf/Logo-eb329c1.png/:/rs=w:107,h:107,cg:true,m/cr=w:107,h:107/qt=q:95)

**Explore • Interact • Integrate**

</div>