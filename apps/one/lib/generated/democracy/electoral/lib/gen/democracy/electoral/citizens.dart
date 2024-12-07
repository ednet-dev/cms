part of '../../../democracy_electoral.dart';

// lib/gen/democracy/electoral/citizens.dart

abstract class CitizenGen extends Entity<Citizen> {
  CitizenGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }
  

  

    String get citizenId => getAttribute('citizenId') as String;
  
  set citizenId(String a) => setAttribute('citizenId', a);

  String get firstName => getAttribute('firstName') as String;
  
  set firstName(String a) => setAttribute('firstName', a);

  String get lastName => getAttribute('lastName') as String;
  
  set lastName(String a) => setAttribute('lastName', a);


  
  @override
  Citizen newEntity() => Citizen(concept);

  @override
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
