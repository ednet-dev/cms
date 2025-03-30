# EDNet CMS

Your Content Management Superpower for Flutter

[![Codemagic build status](https://api.codemagic.io/apps/63ce7b5ab80ead4e2c0f4735/ci/status_badge.svg)](https://codemagic.io/apps/63ce7b5ab80ead4e2c0f4735/ci/latest_build)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

Hey Flutter devs! 👋 Ready to supercharge your content management game? EDNet CMS is here to make your life easier when
building complex, content-rich Flutter apps.

## What's EDNet CMS?

EDNet CMS is your secret weapon for creating multiplatform, web-integrated, business-rich MVPs. It's not just a library;
it's a whole new way of thinking about content management in Flutter, complete with a powerful interpreter app called
EDNet One.

## Why EDNet CMS?

Ever felt like content management in your apps is a bit... messy? Us too. That's why we created EDNet CMS. Here's what
makes it special:

1. **Content is King (and Queen)**: We recognize that content is everywhere, often recursive, and self-defined. Sounds
   complex? That's because it is! But don't worry, we've got you covered.

2. **User-Centric Approach**: We model content primarily based on how users interact with it in different contexts. It's
   all about that user experience!

3. **Abstraction Level: Expert**: We elevate the abstraction level above the current web landscape, making it easier to
   map content across different user contexts.

## Our Secret Sauce

We've baked in some seriously cool principles:

- **Human Biology**: We consider how humans physically interact with content.
- **Human Psychology**: We design with the human mind in focus, making UIs that just make sense.
- **Digital Realism**: We account for the limitations of digital products in our design process.

## The EDNet CMS Method

We're all about opinionated abstractions:

1. **Custom Language**: We speak your domain's language.
2. **Event Storming**: Capture your system's dynamics visually.
3. **Domain-Driven Design**: Your code structure mirrors your business logic.
4. **Code Generation**: Less boilerplate, more productivity.

## Getting Started

1. Add `ednet_core` and `ednet_cms` to your `pubspec.yaml`:
   ```yaml
   dependencies:
     ednet_core: latest
     ednet_cms: latest
   dev_dependencies:
     build_runner: latest
   ```

2. Model your domain:
   Create `.ednet.yaml` files in `lib/requirements/` for each of your bounded contexts.

   Example:
   ```yaml
   # lib/requirements/household/finance/finance.ednet.yaml
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

3. Start the build_runner in watch mode:
   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

4. Generated OneApplication is entry point into your domain models.

5. Use EDNet One to visualize and interact with your domain model:
   ```bash
   flutter run
   ```

## EDNet One: Your Domain Model Navigator

EDNet One is a multiplatform Flutter application that brings your EDNet.dev domain models to life:

- **Master-Detail UX Pattern**: Drill down from domains to models to entities seamlessly.
- **Interactive Graph View**: Visualize entity relationships across domains.
- **Multiplatform Support**: Run on Android, iOS, Web, and Desktop.
- **Theme Support**: Switch between light and dark themes.

## 🚀 Features

- **In-Vivo Domain Model Editing**: Modify your domain model directly within the app.
- **DBpedia and SPARQL Integration**: Enrich your data with vast knowledge graphs.
- **Generative AI**: Get AI-assisted suggestions for model and UI improvements.
- **API Integration**: Connect with calendar, email, project management, and more.

## 📝 Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/ednet-dev/cms.git
   ```

2. Navigate to the EDNet One directory:
   ```bash
   cd cms/apps/one
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Refer to **Getting Started**

5. Run the application:
   ```bash
   flutter run
   ```

## Join the EDNet.dev Community

We're not just building a library; we're cultivating a community of Flutter developers who believe in building scalable,
maintainable apps. Join us on [GitHub](https://github.com/ednet-dev/cms) to contribute, report issues, or just say hi!

## 📄 License

Individual packages and applications within this repository have their own licenses, - see the [LICENSE](LICENSE) file
for details.

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