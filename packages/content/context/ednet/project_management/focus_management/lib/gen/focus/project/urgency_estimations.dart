part of focus_project; 
 
// lib/gen/focus/project/urgency_estimations.dart 
 
abstract class UrgencyEstimationGen extends Entity<UrgencyEstimation> { 
 
  UrgencyEstimationGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  UrgencyEstimation newEntity() => UrgencyEstimation(concept); 
  UrgencyEstimations newEntities() => UrgencyEstimations(concept); 
  
} 
 
abstract class UrgencyEstimationsGen extends Entities<UrgencyEstimation> { 
 
  UrgencyEstimationsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  UrgencyEstimations newEntities() => UrgencyEstimations(concept); 
  UrgencyEstimation newEntity() => UrgencyEstimation(concept); 
  
} 
 
