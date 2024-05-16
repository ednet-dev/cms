part of focus_project; 
 
// lib/gen/focus/project/model_entries.dart 
 
class ProjectEntries extends ModelEntries { 
 
  ProjectEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("Focus"); 
    entries["Focus"] = Focuss(concept); 
    concept = model.concepts.singleWhereCode("Task"); 
    entries["Task"] = Tasks(concept); 
    concept = model.concepts.singleWhereCode("Project"); 
    entries["Project"] = Projects(concept); 
    concept = model.concepts.singleWhereCode("User"); 
    entries["User"] = Users(concept); 
    concept = model.concepts.singleWhereCode("DueDate"); 
    entries["DueDate"] = DueDates(concept); 
    concept = model.concepts.singleWhereCode("Priority"); 
    entries["Priority"] = Priorities(concept); 
    concept = model.concepts.singleWhereCode("DueDateChangeComment"); 
    entries["DueDateChangeComment"] = DueDateChangeComments(concept); 
    concept = model.concepts.singleWhereCode("Urgency"); 
    entries["Urgency"] = Urgencies(concept); 
    concept = model.concepts.singleWhereCode("PriorityChangeComment"); 
    entries["PriorityChangeComment"] = PriorityChangeComments(concept); 
    concept = model.concepts.singleWhereCode("DescisionEngine"); 
    entries["DescisionEngine"] = DescisionEngines(concept); 
    concept = model.concepts.singleWhereCode("UrgencyEstimation"); 
    entries["UrgencyEstimation"] = UrgencyEstimations(concept); 
    concept = model.concepts.singleWhereCode("CommitmentType"); 
    entries["CommitmentType"] = CommitmentTypes(concept); 
    concept = model.concepts.singleWhereCode("GovernmentCommitment"); 
    entries["GovernmentCommitment"] = GovernmentCommitments(concept); 
    concept = model.concepts.singleWhereCode("ProffesionalCommitment"); 
    entries["ProffesionalCommitment"] = ProffesionalCommitments(concept); 
    concept = model.concepts.singleWhereCode("PrivateCommitment"); 
    entries["PrivateCommitment"] = PrivateCommitments(concept); 
    concept = model.concepts.singleWhereCode("SelfCommitment"); 
    entries["SelfCommitment"] = SelfCommitments(concept); 
    return entries; 
  } 
 
  Entities? newEntities(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Focus") { 
      return Focuss(concept); 
    } 
    if (concept.code == "Task") { 
      return Tasks(concept); 
    } 
    if (concept.code == "Project") { 
      return Projects(concept); 
    } 
    if (concept.code == "User") { 
      return Users(concept); 
    } 
    if (concept.code == "DueDate") { 
      return DueDates(concept); 
    } 
    if (concept.code == "Priority") { 
      return Priorities(concept); 
    } 
    if (concept.code == "DueDateChangeComment") { 
      return DueDateChangeComments(concept); 
    } 
    if (concept.code == "Urgency") { 
      return Urgencies(concept); 
    } 
    if (concept.code == "PriorityChangeComment") { 
      return PriorityChangeComments(concept); 
    } 
    if (concept.code == "DescisionEngine") { 
      return DescisionEngines(concept); 
    } 
    if (concept.code == "UrgencyEstimation") { 
      return UrgencyEstimations(concept); 
    } 
    if (concept.code == "CommitmentType") { 
      return CommitmentTypes(concept); 
    } 
    if (concept.code == "GovernmentCommitment") { 
      return GovernmentCommitments(concept); 
    } 
    if (concept.code == "ProffesionalCommitment") { 
      return ProffesionalCommitments(concept); 
    } 
    if (concept.code == "PrivateCommitment") { 
      return PrivateCommitments(concept); 
    } 
    if (concept.code == "SelfCommitment") { 
      return SelfCommitments(concept); 
    } 
    return null; 
  } 
 
  Entity? newEntity(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Focus") { 
      return Focus(concept); 
    } 
    if (concept.code == "Task") { 
      return Task(concept); 
    } 
    if (concept.code == "Project") { 
      return Project(concept); 
    } 
    if (concept.code == "User") { 
      return User(concept); 
    } 
    if (concept.code == "DueDate") { 
      return DueDate(concept); 
    } 
    if (concept.code == "Priority") { 
      return Priority(concept); 
    } 
    if (concept.code == "DueDateChangeComment") { 
      return DueDateChangeComment(concept); 
    } 
    if (concept.code == "Urgency") { 
      return Urgency(concept); 
    } 
    if (concept.code == "PriorityChangeComment") { 
      return PriorityChangeComment(concept); 
    } 
    if (concept.code == "DescisionEngine") { 
      return DescisionEngine(concept); 
    } 
    if (concept.code == "UrgencyEstimation") { 
      return UrgencyEstimation(concept); 
    } 
    if (concept.code == "CommitmentType") { 
      return CommitmentType(concept); 
    } 
    if (concept.code == "GovernmentCommitment") { 
      return GovernmentCommitment(concept); 
    } 
    if (concept.code == "ProffesionalCommitment") { 
      return ProffesionalCommitment(concept); 
    } 
    if (concept.code == "PrivateCommitment") { 
      return PrivateCommitment(concept); 
    } 
    if (concept.code == "SelfCommitment") { 
      return SelfCommitment(concept); 
    } 
    return null; 
  } 
 
  Focuss get focuss => getEntry("Focus") as Focuss; 
  Tasks get tasks => getEntry("Task") as Tasks; 
  Projects get projects => getEntry("Project") as Projects; 
  Users get users => getEntry("User") as Users; 
  DueDates get dueDates => getEntry("DueDate") as DueDates; 
  Priorities get priorities => getEntry("Priority") as Priorities; 
  DueDateChangeComments get dueDateChangeComments => getEntry("DueDateChangeComment") as DueDateChangeComments; 
  Urgencies get urgencies => getEntry("Urgency") as Urgencies; 
  PriorityChangeComments get priorityChangeComments => getEntry("PriorityChangeComment") as PriorityChangeComments; 
  DescisionEngines get descisionEngines => getEntry("DescisionEngine") as DescisionEngines; 
  UrgencyEstimations get urgencyEstimations => getEntry("UrgencyEstimation") as UrgencyEstimations; 
  CommitmentTypes get commitmentTypes => getEntry("CommitmentType") as CommitmentTypes; 
  GovernmentCommitments get governmentCommitments => getEntry("GovernmentCommitment") as GovernmentCommitments; 
  ProffesionalCommitments get proffesionalCommitments => getEntry("ProffesionalCommitment") as ProffesionalCommitments; 
  PrivateCommitments get privateCommitments => getEntry("PrivateCommitment") as PrivateCommitments; 
  SelfCommitments get selfCommitments => getEntry("SelfCommitment") as SelfCommitments; 
 
} 
 
