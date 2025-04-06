# EDNet Role-Based Agent Rules

## What is Cursor?

Cursor is an AI-enhanced code editor built on top of VS Code that integrates powerful AI coding assistants directly into your development workflow. Unlike traditional code editors, Cursor can understand code context, generate code, answer questions, and help implement features through natural language conversation with its AI assistant.

## Understanding Cursor Rules

Rules in Cursor are a way to provide the AI assistant with specialized knowledge and guidance for specific contexts or tasks. They act as configurable "personalities" or "expertise modules" that the AI can access when needed:

- Rules contain structured information about best practices, conventions, and domain knowledge
- They are activated when relevant files are being edited or when explicitly invoked
- Rules help the AI provide more contextually appropriate and domain-aware assistance
- Multiple rules can be combined to address complex, multi-faceted tasks

Rules are stored as `.mdc` (Markdown with Code) files in the `.cursor/rules` directory, with YAML frontmatter describing when and how they should be applied.

## Using Rules Beyond Cursor

These MDC rule files are designed to be portable and usable across the broader ecosystem of AI-powered development tools:

- **AI Application Platforms**: These rules can be imported as knowledge files into various AI application management platforms that help install, run, and control AI tools, enhancing contextual understanding when automating development workflows.
- **Local LLM Environments**: Compatible with the growing ecosystem of locally-run language models and interfaces, providing domain-specific knowledge to tools that otherwise might lack specialized development expertise.
- **AI-Augmented IDEs**: Beyond Cursor, many code editors and IDEs are adding AI capabilities that can benefit from structured domain knowledge in markdown format.
- **DevOps & Automation**: These knowledge bases can be integrated into CI/CD pipelines, documentation generators, or serve as the basis for automated code reviews.
- **Community Knowledge Base**: The open format encourages community contributions and adaptations, creating a shared repository of best practices that can be leveraged across multiple tools and environments.

The value of these rules extends beyond any single tool - they represent codified domain knowledge and best practices that benefit the entire open source ecosystem. Teams can maintain a single set of rules and leverage them across multiple AI assistants, local LLMs, and development workflows.

## Role-Based Agent Rules in EDNet

This directory contains specialized agent rules that provide contextual guidance for different aspects of software development within the EDNet ecosystem. Each rule acts as a specialized "agent" with domain-specific knowledge that can be invoked when working on particular types of tasks.

## What Are Agent Rules?

Agent rules are structured guidance documents that:

- Provide expert advice for specific development activities
- Include best practices tailored to different roles and responsibilities
- Offer consistent patterns for common tasks
- Help maintain quality and coherence across the codebase
- Can be invoked on demand when you need domain-specific assistance

## How To Use Agent Rules

When facing a specific development task, invoke the appropriate agent by name in your prompts to Cursor:

```
Use the product-management agent to help me prioritize these features.
```

or

```
Apply the domain-modeling agent to review this core entity design.
```

Each agent will then provide guidance specific to that domain of expertise.

## Available Agents

| Agent                    | Description                                             | When to Use                                                    |
| ------------------------ | ------------------------------------------------------- | -------------------------------------------------------------- |
| **product-management**   | Product vision, feature prioritization, idea validation | When clarifying requirements or deciding what to build next    |
| **user-experience**      | UI/UX design principles and patterns                    | When designing interfaces or user flows                        |
| **domain-modeling**      | Domain-Driven Design implementation                     | When modeling business domains or core entities                |
| **architecture-design**  | System architecture and technical decisions             | When making high-level design choices                          |
| **code-quality**         | Code quality standards and refactoring                  | When writing or reviewing code                                 |
| **integration-platform** | Integration patterns and platform adaptation            | When building cross-platform features or external integrations |
| **testing-qa**           | Test strategy and implementation                        | When planning or writing tests                                 |
| **documentation-agent**  | Documentation standards and practices                   | When creating or updating docs                                 |
| **devops-cicd**          | CI/CD pipeline and DevOps practices                     | When setting up automation or deployment processes             |
| **release-publishing**   | Version management and release process                  | When preparing releases or publishing packages                 |
| **project-management**   | Task organization and workflow (GTD principles)         | When planning work or managing priorities                      |

## Agent Rule Structure

Each agent rule follows a consistent format:

```
---
description: When to use this agent
globs: ["**/matching/files/**/*"]
alwaysApply: false
---
# Agent Name

Overview of the agent's purpose

## Section 1
- Guideline 1
- Guideline 2
...

## Section 2
...

Remember that [key principle for this domain].
```

The YAML frontmatter includes:
- `description`: When to use this agent
- `globs`: File patterns where this agent's advice is most relevant
- `alwaysApply`: Whether the agent should be automatically applied (usually false)

## Contributing New Agents

To create a new agent rule:

1. Create a new `.mdc` file in the `.cursor/rules` directory
2. Follow the established format with YAML frontmatter
3. Structure the content with clear sections and actionable guidelines
4. Focus on providing specific, practical advice rather than general principles
5. Include a reminder statement that captures the essence of the domain

When modifying existing agents:
- Maintain the established structure
- Ensure guidelines remain clear and actionable
- Update file globs if the scope changes
- Preserve the agent's core focus and expertise

## How Agents Work Together

These agents are designed to complement each other throughout the development lifecycle:

- **Product Management** and **User Experience** agents help define what to build
- **Domain Modeling** and **Architecture Design** agents guide how to design it
- **Code Quality** and **Testing** agents ensure it's built correctly
- **Integration** and **DevOps** agents help deploy and connect it
- **Documentation** and **Release** agents support shipping and explaining it
- **Project Management** helps organize the entire process

Invoke multiple agents when a task spans multiple domains of expertise.

## Background and Philosophy

These agent rules embody the EDNet approach to software development:
- Domain-driven: The business domain model drives technical decisions
- Quality-focused: High standards at every stage of development
- User-centered: Solutions that address real user needs
- Well-documented: Clear communication and knowledge sharing
- Systematically organized: Structured but flexible processes

By following these agent guidelines, contributors help maintain consistency and quality across the EDNet ecosystem. 