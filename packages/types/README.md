# ednet_core_types

**Version:** 0.0.1  
**Homepage:** [ednet.dev](https://ednet.dev/)  
**Description:** A demonstration of **meta-programming** in [EDNet Core](https://github.com/ednet-dev/cms/tree/main/packages/core) and a minimal web UI for managing typed domain objects.

---

## Overview

**ednet_core_types** showcases how you can leverage **EDNet Core** to:
1. Define **typed concepts** (like `CoreType`) with various attributes (`title`, `email`, `started`, etc.).
2. Automatically generate **CRUD-like** web pages using meta-programming (e.g., `EntitiesTable`, `EntityTable`).
3. Persist data in the browser’s `localStorage` for a quick start in a purely client-side environment.

Although it can be extended to real-world needs, **ednet_core_types** is primarily an **illustrative project** rather than a production-ready library.

---

## Key Concepts

1. **Domain-Driven Design (DDD) with EDNet Core**  
   - Classes like `CoreType` and `CoreTypes` extend EDNet’s `Entity` and `Entities` to manage domain objects.
   - A `TypesModel` and `TypesEntries` tie these entities into a single domain model.

2. **Meta-Programming**  
   - Attributes (such as `title`, `email`, `price`) are dynamically handled via EDNet’s concept/attribute metadata.
   - The UI (`EntityTable`/`EntitiesTable`) reads these definitions at runtime to create forms and tables.

3. **Simple Web UI**  
   - Renders tables and forms using DOM elements (`TableElement`, `InputElement`, etc.).
   - Allows adding, updating, removing, and selecting entities in a live, reactive manner.

4. **Local Storage**  
   - The `TypesApp` class loads and saves JSON to `window.localStorage` so users can refresh their browser without losing data.

---

## Getting Started

> **Prerequisites**  
> - A working **Dart** environment (>= 3.5.0-180.3.beta).  
> - Basic familiarity with **EDNet Core** and web-based Dart/Flutter development is helpful.

1. **Clone or Add as a Local Package**  
   ```bash
   git clone https://github.com/ednet-dev/cms.git
   cd cms/packages/ednet_core_types
   ```
Or reference it locally from your own project if you want to explore its code.
2.	Install Dependencies
Inside ednet_core_types, run:
```
dart pub get
```

3.	Serve or Run the Example
You can either open the Dart files in an IDE with a web runner or use a tool like webdev:

```
webdev serve
```
Then navigate to the local URL (e.g., localhost:8080) to see the interactive UI.

### Example Workflow
	1.	View Entities: By default, TypesModel seeds three CoreType objects (type1, type2, type3).
	2.	Add a New Entity: Fill out the form (title, email, etc.) and click Add.
	3.	Update an Entity: Select a row, modify fields, and click Update.
	4.	Remove an Entity: Select a row, click Remove then Confirm to delete.
	5.	Persist to localStorage: Data is automatically saved with each operation.

## Under the Hood
	•	TypesApp
	•	Loads the domain model (TypesEntries) and instantiates the UI layers (EntitiesTableWc).
	•	Reads from/writes to localStorage.
	•	EntityTable
	•	Dynamically builds a form where each non-increment attribute (e.g., title, email) is rendered as an input or checkbox.
	•	Handles add/update/remove flows.
	•	EntitiesTable
	•	Displays a tabular view of essential attributes for each entity.
	•	Allows sorting by identifier attributes and entity selection.
	•	CoreType / CoreTypes
	•	Concrete classes generated from abstract TypeGen/TypesGen, giving each entity typed getters/setters.
	•	Demonstrates multiple attribute types: String, bool, double, Uri, DateTime, and even dynamic.
	•	TypesModel
	•	Initializes sample data in initTypes().
	•	Exposes domain logic for the CoreType concept.

## Use Cases & Extension
	•	Learning Tool: Great for exploring how EDNet Core’s metadata-driven approach can power dynamic UIs.
	•	Prototype: If you need a simple table-based interface to experiment with domain concepts, you can adapt ednet_core_types to your custom concept definitions.
	•	Further Integration: Combine this approach with ednet_cms or advanced code-generation to scale up.

## Limitations
	•	Not Production-Ready: This is a reference implementation showcasing EDNet Core features rather than a polished library.
	•	Minimal UI: Currently uses raw DOM elements without styling frameworks.
	•	Local Storage Only: For any serious app, you’d integrate a real database or an API layer.

## Contributing

We welcome improvements and discussions! Feel free to:
	1.	Fork the CMS Monorepo.
	2.	Open an Issue or Submit a Pull Request under packages/ednet_core_types.

If you have questions or ideas, check out the main EDNet.dev community resources.

## Contact

For any questions:

- **Email**: [dev@ednet.dev](mailto:dev@ednet.dev)
- **GitHub Discussions**: [https://github.com/ednet-dev/cms/discussions](https://github.com/ednet-dev/cms/discussions)
- **Discord**: [EDNet Dev Community](https://discord.gg/7E7bPjNMG3)

## License

Part of the EDNet.dev ecosystem. Distributed under the MIT License.
Use, share, and modify responsibly.

<p align="center">
  <img src="https://img1.wsimg.com/isteam/ip/4896c6bc-229c-47e9-afdd-ff5ab2d2fdbf/Logo-eb329c1.png/:/rs=w:107,h:107,cg:true,m/cr=w:107,h:107/qt=q:95" width="80" alt="EDNet Logo"/>
</p>


<p align="center">
  <b>A demonstration of typed domain modeling and meta-programming in EDNet Core.</b>
</p>
