<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Flutter Calendar implementation

## Features

Calendar serves Entity abstraction from ednet_core, this allows us to implement array of generic use cases
sharing similar infrastructure. 

As Time is at the Core of calendar's Domain model, Calendar is implementing set of generic interfaces around common types of behaviours 
and policies of usual consuments of Time content and give them at disposal for client developers to specialize for their use case. Those are:

**Basic themed rendering** - for date time, and other compatible types, provides basic themed rendering of generic attributes so that user can immediatly spawn functional MVP for Entity and its role in Calendar.

**Additional** Default semantic mappings for supported Content types

**Additional** Higher abstractions handling concepts of time, space and human relation to them for fine-tuning of advanced use cases 

**Additional** Array of Time representations based on its role in context 

**Additional** Localized instances of time

**Additional** Common calendars like Gregorian, Julian, Hebrew, Islam...

**Additional** Support for handling multiple time zones



## Getting started

## Usage

```dart
import 'ednet_flutter/time/calendar.dart

final Project project = await projectService.getById(1);
final List<Task> tasks = project.allTasks();
final List<TeamMember> members = projectService.allMembers(); 
final 

 
```
