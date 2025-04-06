part of settings_application;

// lib/settings/application/model.dart

class ApplicationModel extends ApplicationEntries {
  ApplicationModel(Model model) : super(model);

  void fromJsonToModel() {
    fromJson(settingsApplicationModel);
  }

  void init() {
    // Initialize users
    var userConcept = model.concepts.singleWhereCode("User");
    if (userConcept != null) {
      // Create sample users
      var user1 = User(userConcept);
      user1.name = 'Admin';
      user1.email = 'admin@example.com';
      user1.password = 'password123';
      getEntry("User").add(user1);

      var user2 = User(userConcept);
      user2.name = 'User';
      user2.email = 'user@example.com';
      user2.password = 'password456';
      getEntry("User").add(user2);

      var user3 = User(userConcept);
      user3.name = 'Guest';
      user3.email = 'guest@example.com';
      user3.password = 'password789';
      getEntry("User").add(user3);
    }
  }

  // added after code gen - begin

  // added after code gen - end
}
