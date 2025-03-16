# EDNet One Roadmap

Below is an expanded roadmap outlining the long-term vision, use cases, and infrastructural directions for EDNet One. This roadmap is designed for a range of users—from enterprise architects and domain experts to full-stack developers looking to integrate domain-driven design principles into their applications.

---

## 1. Purpose & Audience

- **Domain Experts & Architects**: Provide a user-friendly environment to model, visualize, and evolve complex business domains.
- **Full-Stack Developers**: Quickly spin up domain-centric applications without reinventing the wheel for data access, identity management, or integration.
- **Technical Project Leads**: Enable a rapid but structured approach to iterating on domain requirements, fostering clear communication between business and technical stakeholders.

---

## 2. Enhanced Domain Editing

- **Inline Editing**: Real-time modifications of `.ednet.yaml` definitions directly from the EDNet One interface.
- **Model Merge & Sync**: Automated processes to merge local changes with remote `.ednet.yaml` definitions, reducing the risk of conflicts.
- **Extended Validation**: Advanced constraints, code generation previews, and direct conflict resolution for domain merges.

### Future Expansion
- **Side-by-Side Domain Diffing**: Compare changes across multiple versions or branches of a domain model.
- **Revision History**: Maintain a timeline of domain changes for auditing or rollback.

---

## 3. Repository & Storage Abstraction

- **Generic Repositories**: Offer out-of-the-box support for:
    - **In-Memory**: Simplify prototyping or quick data manipulation without external dependencies.
    - **Plain Disk JSON**: Already partially implemented; expand it for offline use cases and simple persistence.
    - **Relational Databases**: Provide adapters for PostgreSQL, MySQL, or MSSQL.
    - **NoSQL Databases**: Connect to MongoDB, CouchDB, or Cassandra.
    - **Cloud Services**: Native plugins for AWS DynamoDB, Azure Cosmos DB, or Google Firestore.

### Future Expansion
- **OpenAPI Generation**: Automatically generate OpenAPI specs from `.ednet.yaml` domain definitions, enabling external integrations and microservice architectures.
- **GraphQL Support**: Provide a layer that maps domain models to GraphQL schemas for reactive front-end experiences.

---

## 4. Identity & Security Management

- **Integration with Providers**: Streamline authentication and authorization via major providers like:
    - **Firebase Auth**
    - **Microsoft Azure AD**
    - **AWS Cognito**
    - **Auth0**
- **Role-Based Access Control**: Map EDNet One domain roles to user permissions, ensuring a secure multi-tenant environment.

### Future Expansion
- **Single Sign-On (SSO)**: Provide enterprise SSO capabilities (SAML, OIDC) for seamless user management.
- **Audit Logging**: Record all domain changes and user interactions for compliance and traceability.

---

## 5. Infrastructure & Scaling

- **Modular Architecture**: Support plugin-style expansions for new storage backends, identity providers, or advanced analytics.
- **Scalability**: Optimize for large domains with hundreds of concepts, ensuring minimal performance overhead.
- **Federated Models**: Combine multiple domain models from different repositories or teams, offering a unified architecture across business units.

### Future Expansion
- **Domain Sharding**: Partition large domain models across services or regions.
- **Offline-First**: Provide local caching and sync mechanisms for offline usage scenarios.

---

## 6. Visualization & Canvas Improvements

- **Advanced Graph Layouts**: Offer circular, hierarchical, and force-directed algorithms to better represent domain complexities.
- **Interactive Linking**: Create, modify, or remove relationships between entities directly on the canvas.
- **Live Collaboration**: Multiple team members editing the domain graph simultaneously.

### Future Expansion
- **Model-Level Theming**: Visual cues (colors, shapes) to highlight concept categories, relationships, or custom tags.

---

## 7. AI-Powered Insights

- **Concept Discovery**: Recommend missing attributes, relationships, or entirely new concepts based on usage patterns or domain text.
- **Domain Heuristics**: Suggest best practices around cardinalities, naming conventions, or entity splitting.

### Future Expansion
- **Intelligent Code Generation**: Analyze existing domain usage and generate boilerplate code, tests, or documentation automatically.

---

## 8. Testing & Validation

- **Scenario Simulations**: Run various domain scenarios to test constraints like cardinalities, referential integrity, or performance bounds.
- **Automated Regression Testing**: Catch regressions as domain definitions evolve.

---

## 9. Community & Plugin Ecosystem

- **Plugin Architecture**: Simplify the creation and distribution of custom domain analysis or visualization plugins.
- **Marketplace or Directory**: Showcase community-driven plugins that integrate new data sources, cloud services, or analytics engines.
- **Documentation & Tutorials**: Expand how-to guides, advanced user manuals, and sample domain models.

