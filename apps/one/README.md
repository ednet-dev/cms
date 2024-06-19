# EDNet One

EDNet One is a multiplatform Flutter application designed to navigate domain models defined by
the `ednet_core` framework. It employs a master-detail UX pattern, providing a consistent and
intuitive way to explore and interact with domain entities. This project implements a transparent
and democratic general-purpose project management tool built on top of the web. It is a
next-generation semantic web reader focused on the `User` and the different `Roles` that the `User`
assumes throughout their life.

Our core domains are generalized interactions and behaviors of `Project Management`
and `Direct Democracy`.

The core orchestrates human-centric processes by integrating with a wide range of web-exposed APIs
from various service providers. These include calendar management, email, project management, event
booking, transport, accounting and tax submission, education and skill development, self-care,
social networks, and other relevant domains.

## 🚀 Features

- **Master-Detail UX Pattern**: Simplifies navigation through domain models, allowing you to drill
  down from domains to models to entities seamlessly.
- **Breadcrumb Navigation**: Easily navigate back to previous states using breadcrumb trails,
  providing a clear sense of your location within the application.
- **Path Management**: Maintain and manage navigation paths seamlessly, ensuring a smooth and
  intuitive user experience.
- **Entity Filtering**: Filter entities dynamically based on various attributes, allowing you to
  quickly find the information you need.
- **Bookmarking**: Save and quickly access important entities, streamlining your workflow.
- **Multiplatform**: Runs on Android, iOS, Web, and Desktop, providing flexibility and
  accessibility.
- **Web Layout**: A traditional web-style layout with left and right sidebars for efficient
  navigation and information display.
- **Meta Domain Canvas**: An interactive canvas for visualizing entity relationships across domains,
  offering a unique perspective on your data.
    - **Layout Algorithms**: Choose from various layout algorithms (force-directed, grid, circular,
      master-detail) to optimize the visualization for your needs.
    - **Pan and Zoom**: Explore the canvas with ease using pan and zoom functionality.
- **Theme Support**: Switch between light and dark themes to personalize your experience.

## 🌐 Core Domains

### Project Management

Generalized interactions and behaviors for managing projects effectively, including task management,
resource allocation, and progress tracking.

### Direct Democracy

Tools and functionalities supporting transparent and democratic decision-making processes, enabling
collaborative governance and community engagement.

## 🛠️ Integration

EDNet One integrates with a wide range of web-exposed APIs to enhance user value by leveraging
services like:

- **Calendar Management**: Synchronize your schedule and events across platforms.
- **E-mail Communication**: Streamline your communication workflows.
- **Event Booking**: Easily manage event registrations and attendance.
- **Transport Management**: Optimize your travel and logistics.
- **Accounting and Tax Submission**: Simplify financial management and compliance.
- **Education and Competence Development**: Access and track your learning progress.
- **Self-Care and Social Networks**: Stay connected and maintain your well-being.

## 📱 Platforms

- **Android**: Reach a wide audience with the most popular mobile platform.
- **iOS**: Deliver a premium experience on Apple devices.
- **Web**: Provide universal access through any web browser.
- **Desktop**: Offer a powerful and feature-rich experience on desktop computers.

## 📝 Usage

1. **Clone the repository:**

```bash
git clone https://github.com/ednet-dev/cms.git
```

2. **Navigate to the project directory:**


```
cd cms/apps/one
```

3. **Install dependencies:**

```
flutter pub get
```

4. Use EDNet DSL to define your domain model in the `ednet_core` package.
```bash
cd lib/requirements
# in this folder we will define our domain of interest 
mkdir household
# once in the household folder we will define the domain models
cd household
# here we create a folder for the finance model
mkdir finance
mkdir health
mkdir education
mkdir social
mkdir work
mkdir leisure
cd finance
touch finance.ednet.yaml

```
create a domain model in the `finance.ednet.yaml` file:
```yaml
domain: Household
model: Finances
concepts: 
  - name: Income
    attributes:
      - name: amount
        type: number
      - name: source
        type: string
  - name: Expense
  - name: Budget
  - name: Transaction
```
Please see here [DSL documentation](DSL.md) for more information on how to define your domain model.

5. **Generate the domain model:**

```bash
 dart run build_runner build --delete-conflicting-outputs
```

6. **Run the application:**

```
flutter run
```

## 🗺️ Roadmap

### In-Vivo Domain Model Editing

**Goal:** Empower users to directly modify and extend the domain model within the application,
fostering a dynamic and adaptable environment.

**Features:**

- **Editable Graph View:** Enable users to add, delete, and modify entities and relationships
  directly within the interactive graph visualization.
- **Real-time Synchronization:** Ensure that changes made in the graph view are immediately
  reflected in the default master-detail view, maintaining consistency across the application.
- **Intuitive UI Controls:** Provide user-friendly controls for editing the graph, such as
  drag-and-drop for creating relationships and context menus for node and edge modifications.
- **Validation and Feedback:** Implement real-time validation to ensure the integrity of the domain
  model and provide clear feedback to users on any potential errors or conflicts.

### DBpedia and SPARQL Integration

**Goal:** Leverage the vast knowledge base of DBpedia and the querying power of SPARQL to enrich
the semantic context of EDNet One.

**Features:**

- **DBpedia as a Data Source:** Integrate DBpedia as a primary data source, allowing users to
  seamlessly access and incorporate information from this extensive knowledge graph.
- **SPARQL Querying:** Implement SPARQL query capabilities, enabling users to perform complex
  queries on DBpedia and other linked data sources to retrieve relevant information.
- **Ednet Core Dialect:** Develop a dialect of Ednet Core criteria that maps to SPARQL queries,
  providing a unified and intuitive way to interact with semantic data.
- **Contextual Enrichment:** Utilize DBpedia and SPARQL to automatically enrich the context of
  entities and relationships within EDNet One, providing users with a deeper understanding of the
  data.

### Generative AI for Domain Model and Interface Evolution

**Goal:** Harness the power of generative AI to assist users in evolving the domain model and
optimizing the user interface.

**Features:**

- **AI-Assisted Modeling:** Employ generative AI to suggest potential enhancements to the domain
  model based on user interactions and data patterns.
- **UI Optimization:** Leverage AI to analyze user behavior and preferences to suggest improvements
  to the user interface, enhancing usability and efficiency.
- **Personalized Experiences:** Utilize AI to tailor the application experience to individual users,
  providing customized views and recommendations.

## 🤝 Contributing

Contributions are welcome! Please read the [contribution guidelines](CONTRIBUTING.md) first. You
can also check the [issues page](https://github.com/your-username/ednet-one/issues).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Contact

For more information, please contact [dev team](mailto:dev@ednet.dev).

---
&nbsp;
<div align="center">

![EDNet One](https://img1.wsimg.com/isteam/ip/4896c6bc-229c-47e9-afdd-ff5ab2d2fdbf/Logo-eb329c1.png/:/rs=w:107,h:107,cg:true,m/cr=w:107,h:107/qt=q:95)

**Explore • Interact • Integrate**

</div>