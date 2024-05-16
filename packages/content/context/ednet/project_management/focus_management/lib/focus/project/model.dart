 
part of focus_project; 
 
// lib/focus/project/model.dart 
 
class ProjectModel extends ProjectEntries { 
 
  ProjectModel(Model model) : super(model); 
 
  void fromJsonToFocusEntry() { 
    fromJsonToEntry(focusProjectFocusEntry); 
  } 
 
  void fromJsonToTaskEntry() { 
    fromJsonToEntry(focusProjectTaskEntry); 
  } 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(focusProjectProjectEntry); 
  } 
 
  void fromJsonToUserEntry() { 
    fromJsonToEntry(focusProjectUserEntry); 
  } 
 
  void fromJsonToDueDateEntry() { 
    fromJsonToEntry(focusProjectDueDateEntry); 
  } 
 
  void fromJsonToPriorityEntry() { 
    fromJsonToEntry(focusProjectPriorityEntry); 
  } 
 
  void fromJsonToDueDateChangeCommentEntry() { 
    fromJsonToEntry(focusProjectDueDateChangeCommentEntry); 
  } 
 
  void fromJsonToUrgencyEntry() { 
    fromJsonToEntry(focusProjectUrgencyEntry); 
  } 
 
  void fromJsonToPriorityChangeCommentEntry() { 
    fromJsonToEntry(focusProjectPriorityChangeCommentEntry); 
  } 
 
  void fromJsonToDescisionEngineEntry() { 
    fromJsonToEntry(focusProjectDescisionEngineEntry); 
  } 
 
  void fromJsonToUrgencyEstimationEntry() { 
    fromJsonToEntry(focusProjectUrgencyEstimationEntry); 
  } 
 
  void fromJsonToCommitmentTypeEntry() { 
    fromJsonToEntry(focusProjectCommitmentTypeEntry); 
  } 
 
  void fromJsonToGovernmentCommitmentEntry() { 
    fromJsonToEntry(focusProjectGovernmentCommitmentEntry); 
  } 
 
  void fromJsonToProffesionalCommitmentEntry() { 
    fromJsonToEntry(focusProjectProffesionalCommitmentEntry); 
  } 
 
  void fromJsonToPrivateCommitmentEntry() { 
    fromJsonToEntry(focusProjectPrivateCommitmentEntry); 
  } 
 
  void fromJsonToSelfCommitmentEntry() { 
    fromJsonToEntry(focusProjectSelfCommitmentEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(focusProjectModel); 
  } 
 
  void init() { 
    initFocuss(); 
    initTasks(); 
    initProjects(); 
    initUsers(); 
    initDueDates(); 
    initPriorities(); 
    initDueDateChangeComments(); 
    initUrgencies(); 
    initPriorityChangeComments(); 
    initDescisionEngines(); 
    initUrgencyEstimations(); 
    initCommitmentTypes(); 
    initGovernmentCommitments(); 
    initProffesionalCommitments(); 
    initPrivateCommitments(); 
    initSelfCommitments(); 
  } 
 
  void initFocuss() { 
    var focus1 = Focus(focuss.concept); 
    focuss.add(focus1); 
 
    var focus2 = Focus(focuss.concept); 
    focuss.add(focus2); 
 
    var focus3 = Focus(focuss.concept); 
    focuss.add(focus3); 
 
  } 
 
  void initTasks() { 
    var task1 = Task(tasks.concept); 
    tasks.add(task1); 
 
    var task2 = Task(tasks.concept); 
    tasks.add(task2); 
 
    var task3 = Task(tasks.concept); 
    tasks.add(task3); 
 
  } 
 
  void initProjects() { 
    var project1 = Project(projects.concept); 
    projects.add(project1); 
 
    var project2 = Project(projects.concept); 
    projects.add(project2); 
 
    var project3 = Project(projects.concept); 
    projects.add(project3); 
 
  } 
 
  void initUsers() { 
    var user1 = User(users.concept); 
    users.add(user1); 
 
    var user2 = User(users.concept); 
    users.add(user2); 
 
    var user3 = User(users.concept); 
    users.add(user3); 
 
  } 
 
  void initDueDates() { 
    var dueDate1 = DueDate(dueDates.concept); 
    dueDates.add(dueDate1); 
 
    var dueDate2 = DueDate(dueDates.concept); 
    dueDates.add(dueDate2); 
 
    var dueDate3 = DueDate(dueDates.concept); 
    dueDates.add(dueDate3); 
 
  } 
 
  void initPriorities() { 
    var priority1 = Priority(priorities.concept); 
    priorities.add(priority1); 
 
    var priority2 = Priority(priorities.concept); 
    priorities.add(priority2); 
 
    var priority3 = Priority(priorities.concept); 
    priorities.add(priority3); 
 
  } 
 
  void initDueDateChangeComments() { 
    var dueDateChangeComment1 = DueDateChangeComment(dueDateChangeComments.concept); 
    dueDateChangeComments.add(dueDateChangeComment1); 
 
    var dueDateChangeComment2 = DueDateChangeComment(dueDateChangeComments.concept); 
    dueDateChangeComments.add(dueDateChangeComment2); 
 
    var dueDateChangeComment3 = DueDateChangeComment(dueDateChangeComments.concept); 
    dueDateChangeComments.add(dueDateChangeComment3); 
 
  } 
 
  void initUrgencies() { 
    var urgency1 = Urgency(urgencies.concept); 
    urgencies.add(urgency1); 
 
    var urgency2 = Urgency(urgencies.concept); 
    urgencies.add(urgency2); 
 
    var urgency3 = Urgency(urgencies.concept); 
    urgencies.add(urgency3); 
 
  } 
 
  void initPriorityChangeComments() { 
    var priorityChangeComment1 = PriorityChangeComment(priorityChangeComments.concept); 
    priorityChangeComments.add(priorityChangeComment1); 
 
    var priorityChangeComment2 = PriorityChangeComment(priorityChangeComments.concept); 
    priorityChangeComments.add(priorityChangeComment2); 
 
    var priorityChangeComment3 = PriorityChangeComment(priorityChangeComments.concept); 
    priorityChangeComments.add(priorityChangeComment3); 
 
  } 
 
  void initDescisionEngines() { 
    var descisionEngine1 = DescisionEngine(descisionEngines.concept); 
    descisionEngines.add(descisionEngine1); 
 
    var descisionEngine2 = DescisionEngine(descisionEngines.concept); 
    descisionEngines.add(descisionEngine2); 
 
    var descisionEngine3 = DescisionEngine(descisionEngines.concept); 
    descisionEngines.add(descisionEngine3); 
 
  } 
 
  void initUrgencyEstimations() { 
    var urgencyEstimation1 = UrgencyEstimation(urgencyEstimations.concept); 
    urgencyEstimations.add(urgencyEstimation1); 
 
    var urgencyEstimation2 = UrgencyEstimation(urgencyEstimations.concept); 
    urgencyEstimations.add(urgencyEstimation2); 
 
    var urgencyEstimation3 = UrgencyEstimation(urgencyEstimations.concept); 
    urgencyEstimations.add(urgencyEstimation3); 
 
  } 
 
  void initCommitmentTypes() { 
    var commitmentType1 = CommitmentType(commitmentTypes.concept); 
    commitmentTypes.add(commitmentType1); 
 
    var commitmentType2 = CommitmentType(commitmentTypes.concept); 
    commitmentTypes.add(commitmentType2); 
 
    var commitmentType3 = CommitmentType(commitmentTypes.concept); 
    commitmentTypes.add(commitmentType3); 
 
  } 
 
  void initGovernmentCommitments() { 
    var governmentCommitment1 = GovernmentCommitment(governmentCommitments.concept); 
    governmentCommitments.add(governmentCommitment1); 
 
    var governmentCommitment2 = GovernmentCommitment(governmentCommitments.concept); 
    governmentCommitments.add(governmentCommitment2); 
 
    var governmentCommitment3 = GovernmentCommitment(governmentCommitments.concept); 
    governmentCommitments.add(governmentCommitment3); 
 
  } 
 
  void initProffesionalCommitments() { 
    var proffesionalCommitment1 = ProffesionalCommitment(proffesionalCommitments.concept); 
    proffesionalCommitments.add(proffesionalCommitment1); 
 
    var proffesionalCommitment2 = ProffesionalCommitment(proffesionalCommitments.concept); 
    proffesionalCommitments.add(proffesionalCommitment2); 
 
    var proffesionalCommitment3 = ProffesionalCommitment(proffesionalCommitments.concept); 
    proffesionalCommitments.add(proffesionalCommitment3); 
 
  } 
 
  void initPrivateCommitments() { 
    var privateCommitment1 = PrivateCommitment(privateCommitments.concept); 
    privateCommitments.add(privateCommitment1); 
 
    var privateCommitment2 = PrivateCommitment(privateCommitments.concept); 
    privateCommitments.add(privateCommitment2); 
 
    var privateCommitment3 = PrivateCommitment(privateCommitments.concept); 
    privateCommitments.add(privateCommitment3); 
 
  } 
 
  void initSelfCommitments() { 
    var selfCommitment1 = SelfCommitment(selfCommitments.concept); 
    selfCommitments.add(selfCommitment1); 
 
    var selfCommitment2 = SelfCommitment(selfCommitments.concept); 
    selfCommitments.add(selfCommitment2); 
 
    var selfCommitment3 = SelfCommitment(selfCommitments.concept); 
    selfCommitments.add(selfCommitment3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
