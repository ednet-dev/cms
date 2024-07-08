part of global_democracy_electoral_system;

// lib/gen/global_democracy/electoral_system/citizens.dart

abstract class CitizenGen extends Entity<Citizen> {
  CitizenGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }

  String get citizenId => getAttribute("citizenId");

  void set citizenId(String a) => setAttribute("citizenId", a);

  String get name => getAttribute("name");

  void set name(String a) => setAttribute("name", a);

  @override
  Citizen newEntity() => Citizen(concept);

  Citizens newEntities() => Citizens(concept);
}

abstract class CitizensGen extends Entities<Citizen> {
  CitizensGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Citizens newEntities() => Citizens(concept);

  @override
  Citizen newEntity() => Citizen(concept);
}

// Commands for Citizen will be generated here
// Events for Citizen will be generated here
// Policies for Citizen will be generated here
