# aPdf CLI Tool

aPdf is a Dart-based command-line tool that concatenates source code files into a single PDF document. It's designed to be globally activated and used across various local repositories to generate documentation or reviews of codebases.

## Features

- Recursive file traversal with glob pattern filtering for including and excluding files.
- PDF generation from concatenated source code.
- Globally activated CLI tool for ease of use across different projects.
- Configurable output PDF file name via command-line option.
- Exclusion of specific file types (e.g., generated files like `*.g.dart`) by default.

## Installation and Usage

### Installing from Pub

1. Ensure you have Dart SDK installed on your system. You can download it from the [official Dart website](https://dart.dev/get-dart).

2. Install aPdf from pub.dev by running the following command:

    ```sh
    dart pub global activate apdf
    ```

3. Once activated, you can run the `apdf` command from anywhere within your terminal or command prompt.

    ```sh
    apdf --source path/to/directory --output output.pdf
    ```

### Checking for Updates and Updating

To check for and install updates to aPdf, use the following command:

```sh
apdf update
```
### Update Mechanism

aPdf includes a built-in update mechanism to facilitate keeping the CLI tool at the latest version. The `UpdateCommand` class is responsible for checking for any available updates and applying them if found. Using the `PubUpdater` service, it compares the current package version against the latest available version and performs the update if necessary.

Here's how the `UpdateCommand` works:

1. It checks for available updates for the CLI tool.
2. If an update is available, it prompts the user and applies the update.
3. Upon successful update, it provides feedback to the user.

## Local Development and Contribution

For contributors interested in enhancing aPdf or fixing bugs, you can clone the repository and work on it locally:

1. Clone the repository from GitHub to your local machine:

    ```sh
    git clone https://github.com/your-username/apdf.git
    ```

2. Navigate to the cloned directory and make your changes.

3. To compile your changes to an executable and activate it globally, you can use the following command:

    ```sh
    dart compile exe bin/apdf.dart -o bin/apdf && dart pub global activate -s path .
    ```

    This compiles your program to a native executable and activates it globally.

4. After making additional changes, re-run the compilation and activation command to update the global version with your latest changes.

5. Run the tests to ensure your changes don't break existing functionality.

6. Once you've made your improvements, push the changes to your fork and submit a pull request to the main repository.

We appreciate contributions that improve the project's quality and extend its capabilities. Before submitting new features or significant changes, please open an issue to discuss your ideas with the maintainers.

## License

aPdf is released under the [LICENSE](LICENSE)<!-- @IGNORE PREVIOUS: link -->.

---

Please note: This `README.md` is an evolving document and may be updated to provide more detailed information on using and contributing to aPdf.