**Categories**: ednet_core, model, code generation

## Description

The yaml representation of a model designed with EDNetCoreDSL must be copied in
the model.json file in the project directory.

Run bin/ednet_core_gen.dart Dart script:
for single json model.json
--genall projectpath domain model
or
for multiple models with yaml
--genall yamldomainpath output domain model1 model2... modeln

Example:

--genall C:/Users/johns/dart/demo_projects demo projects

or

--genall example_domain output ednet user news 

By running the main function in the bin/ednet_core_gen.dart file,
a project, with its demo domain and projects model, 
will be generated in the project directory.

Credentials:
- Based on [Dartling](https://github.com/dzenanr/dartling)
