# EDNet One: Your Domain Model Explorer

[![EDNet One Logo](https://img1.wsimg.com/isteam/ip/4896c6bc-229c-47e9-afdd-ff5ab2d2fdbf/Logo-eb329c1.png/:/rs=w:107,h:107,cg:true,m/cr=w:107,h:107/qt=q:95)](https://github.com/ednet-dev/cms)

**EDNet One** is a multiplatform Flutter application designed to visualize, navigate, and interact with `ednet_core` domain models. It empowers developers and domain experts to explore complex data relationships and understand the structure of their applications.

**Explore • Interact • Integrate**

## Table of Contents

-   [Overview](#overview)
-   [Key Features](#key-features)
-   [Core Domains](#core-domains)
-   [Integration Capabilities](#integration-capabilities)
-   [Getting Started](#getting-started)
   -   [Prerequisites](#prerequisites)
   -   [Installation](#installation)
   -   [Defining a New Domain Model](#defining-a-new-domain-model)
   -   [Generating the Domain Model](#generating-the-domain-model)
   -   [Running EDNet One](#running-ednet-one)
-   [Design Decisions](#design-decisions)
-   [The Road Ahead](#the-road-ahead)
-   [Contributing](#contributing)
-   [FAQ](#faq)
-   [License](#license)
-   [Contact](#contact)

## Overview

EDNet One serves as a visual and interactive tool for understanding and working with domain models built using the `ednet_core` framework. It functions as a semantic web reader, allowing users to drill down into domains, models, and entities, making data exploration intuitive and efficient. As user, you can define a new `Role` and have the domain model reflect your current role.

## Key Features

-   **Master-Detail Navigation:** Seamlessly navigate from domains to models and down to individual entities.
-   **Breadcrumb Navigation:** Always maintain context with clear breadcrumb trails.
-   **Filtering:** Quickly find the entities and data you need using robust filtering capabilities.
-   **Bookmarking:** Save and return to specific points in your data exploration.
-   **Multiplatform Support:** Run EDNet One on Android, iOS, Web, and Desktop.
-   **Canvas Visualization:** Graphically represent relationships between domain entities using a visual canvas.
-   **Theming:** Customize the look and feel with light and dark mode options.

## Core Domains

EDNet One currently emphasizes the visualization of the following core domains:

-   **Project Management:** Tools for managing tasks, resources, and project progress effectively.
-   **Direct Democracy:** Features that support transparent and collaborative decision-making.

## Integration Capabilities

EDNet One is designed for extensibility and interoperability. It can integrate with various web APIs to enhance functionality, including:

-   **Calendar Synchronization:** Integrate with external calendars for event management.
-   **Email Integration:** Streamline email interactions.
-   **Event Booking:** Connect to event booking services.
-   **Transportation Management:** Interface with transportation services.
-   **Financial Management:** Integrate with financial tools and services.
-   **Skills and Learning Platforms:** Connect to educational resources.
-   **Health and Wellness:** Track personal well-being.
-   **Social Networking:** Facilitate social interactions.

## Getting Started

This section guides you through setting up and running EDNet One, including defining and generating a new domain model.

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and configured.
-   Basic familiarity with Dart and Flutter.
-   [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Installation

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/ednet-dev/cms.git
    ```

2.  **Navigate to the EDNet One App:**

    ```bash
    cd cms/apps/one
    ```

3.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

### Defining a New Domain Model

1.  **Create a Requirements Directory:**

    Navigate to the requirements directory and create a new folder and `yaml` file.
    This example creates a simple model for managing `Household` `Finance`.

    ```bash
    cd lib/requirements
    mkdir -p household/finance
    touch household/finance/finance.ednet.yaml
    ```

2.  **Define Your Domain Model:**

    Edit the `finance.ednet.yaml` file with your domain model definition. Below is an example of creating a `Finance` model for the `Household` domain:

    ```yaml
    # household/finance/finance.ednet.yaml
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
    Refer to `ednet_core` documentation for more advanced definitions.

### Generating the Domain Model

After defining your domain model, you need to generate the corresponding Dart code:
This command uses the `build_runner` tool to process your `yaml` definition and
generate the necessary Dart classes and utilities.

### Running EDNet One

Once the domain model is generated, launch the EDNet One app using the following
command:
```bash
flutter run
```
This will start the app in your configured Flutter environment.

## Design Decisions

EDNet One is built upon several core design principles:

- **Domain-Driven Design (DDD):** The application heavily utilizes DDD to
  structure its data and business logic.
- **Flutter's Widget-Based UI:** Leverages Flutter's reactive framework for
  building user interfaces.
- **`ednet_core` Integration:** The app integrates with `ednet_core` for data
  management and modeling.
- **Graph-Based Rendering:** Uses the `graphview` package to visualize complex
  relationships in the UI.
- **Conventional Commits** We use Conventional Commits specification, to make
  it easier to read the changelog.

## The Road Ahead

The following features and improvements are planned for future releases:

- **In-Vivo Domain Model Editing:** Direct editing of the domain model within
  the app's UI.
- **DBpedia and SPARQL Integration:** Ability to query and integrate external
  knowledge from DBpedia using SPARQL.
- **AI-Powered Enhancements:** AI-driven suggestions for improving the domain
  model and UI.

## Contributing

We welcome contributions from the community\! Please see our Contributing
Guidelines for more details on how to get involved.

## FAQ

**Q: What is `ednet_core`?**

A: `ednet_core` is a core framework for building domain models in Dart. It
provides essential components for DDD and domain model creation.

**Q: How can I define complex relationships between entities?**

A: You define complex relationships in the `yaml` file for your domain model,
using parent-child relationships, associations, or other DDD concepts supported
by `ednet_core`. Refer to `ednet_core` documentation.

**Q: What if the `dart run build_runner build` command fails?** A: Check that
you have all the dependencies. Run `flutter pub get` again. If there is still a
problem, please create a new issue in Issues page.

## License

This project is licensed under the MIT License.

## Contact

For any questions, ideas, or discussions, please contact our development team at
dev@ednet.dev.