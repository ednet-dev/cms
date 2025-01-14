 
part of project_planning; 
 
// lib/project/planning/model.dart 
 
class PlanningModel extends PlanningEntries { 
 
  PlanningModel(Model model) : super(model); 
 
  void fromJsonToPlanEntry() { 
    fromJsonToEntry(projectPlanningPlanEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(projectPlanningModel); 
  } 
 
  void init() { 
    initPlans(); 
  } 
 
  void initPlans() { 
    var plan1 = Plan(plans.concept); 
    plan1.name = 'economy'; 
    plans.add(plan1); 
 
    var plan2 = Plan(plans.concept); 
    plan2.name = 'ocean'; 
    plans.add(plan2); 
 
    var plan3 = Plan(plans.concept); 
    plan3.name = 'capacity'; 
    plans.add(plan3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
