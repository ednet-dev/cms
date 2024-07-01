 
part of project_gtd; 
 
// lib/project/gtd/model.dart 
 
class GtdModel extends GtdEntries { 
 
  GtdModel(Model model) : super(model); 
 
  void fromJsonToInboxEntry() { 
    fromJsonToEntry(projectGtdInboxEntry); 
  } 
 
  void fromJsonToClarifiedItemEntry() { 
    fromJsonToEntry(projectGtdClarifiedItemEntry); 
  } 
 
  void fromJsonToTaskEntry() { 
    fromJsonToEntry(projectGtdTaskEntry); 
  } 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(projectGtdProjectEntry); 
  } 
 
  void fromJsonToCalendarEntry() { 
    fromJsonToEntry(projectGtdCalendarEntry); 
  } 
 
  void fromJsonToContextListEntry() { 
    fromJsonToEntry(projectGtdContextListEntry); 
  } 
 
  void fromJsonToReviewEntry() { 
    fromJsonToEntry(projectGtdReviewEntry); 
  } 
 
  void fromJsonToNextActionEntry() { 
    fromJsonToEntry(projectGtdNextActionEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(projectGtdModel); 
  } 
 
  void init() { 
    initInboxes(); 
    initReviews(); 
    initNextActions(); 
    initClarifiedItems(); 
    initTasks();
    initProjects();
    initCalendars();
    initContextLists();
  }
 
  void initInboxes() { 
    var inbox1 = Inbox(inboxes.concept); 
    inbox1.items = 'ocean'; 
    inboxes.add(inbox1); 
 
    var inbox2 = Inbox(inboxes.concept); 
    inbox2.items = 'concern'; 
    inboxes.add(inbox2); 
 
    var inbox3 = Inbox(inboxes.concept); 
    inbox3.items = 'circle'; 
    inboxes.add(inbox3); 
 
  } 
 
  void initClarifiedItems() { 
    var clarifiedItem1 = ClarifiedItem(clarifiedItems.concept); 
    clarifiedItem1.nextAction = 'tag'; 
    var clarifiedItem1Inbox = inboxes.random(); 
    clarifiedItem1.inbox = clarifiedItem1Inbox; 
    clarifiedItems.add(clarifiedItem1); 
    clarifiedItem1Inbox.clarifiedItems.add(clarifiedItem1); 
 
    var clarifiedItem2 = ClarifiedItem(clarifiedItems.concept); 
    clarifiedItem2.nextAction = 'season'; 
    var clarifiedItem2Inbox = inboxes.random(); 
    clarifiedItem2.inbox = clarifiedItem2Inbox; 
    clarifiedItems.add(clarifiedItem2); 
    clarifiedItem2Inbox.clarifiedItems.add(clarifiedItem2); 
 
    var clarifiedItem3 = ClarifiedItem(clarifiedItems.concept); 
    clarifiedItem3.nextAction = 'bird'; 
    var clarifiedItem3Inbox = inboxes.random(); 
    clarifiedItem3.inbox = clarifiedItem3Inbox; 
    clarifiedItems.add(clarifiedItem3); 
    clarifiedItem3Inbox.clarifiedItems.add(clarifiedItem3); 
 
  } 
 
  void initTasks() { 
    var task1 = Task(tasks.concept); 
    task1.description = 'feeling'; 
    var task1ClarifiedItem = clarifiedItems.random(); 
    task1.clarifiedItem = task1ClarifiedItem; 
    var task1Review = reviews.random(); 
    task1.review = task1Review; 
    var task1Action = nextActions.random(); 
    task1.action = task1Action; 
    tasks.add(task1); 
    task1ClarifiedItem.tasks.add(task1); 
    task1Review.tasks.add(task1); 
    task1Action.tasks.add(task1); 
 
    var task2 = Task(tasks.concept); 
    task2.description = 'time'; 
    var task2ClarifiedItem = clarifiedItems.random(); 
    task2.clarifiedItem = task2ClarifiedItem; 
    var task2Review = reviews.random(); 
    task2.review = task2Review; 
    var task2Action = nextActions.random(); 
    task2.action = task2Action; 
    tasks.add(task2); 
    task2ClarifiedItem.tasks.add(task2); 
    task2Review.tasks.add(task2); 
    task2Action.tasks.add(task2); 
 
    var task3 = Task(tasks.concept); 
    task3.description = 'computer'; 
    var task3ClarifiedItem = clarifiedItems.random(); 
    task3.clarifiedItem = task3ClarifiedItem; 
    var task3Review = reviews.random(); 
    task3.review = task3Review; 
    var task3Action = nextActions.random(); 
    task3.action = task3Action; 
    tasks.add(task3); 
    task3ClarifiedItem.tasks.add(task3); 
    task3Review.tasks.add(task3); 
    task3Action.tasks.add(task3); 
 
  } 
 
  void initProjects() { 
    var project1 = Project(projects.concept); 
    project1.tasks = 'lake'; 
    var project1Task = tasks.random(); 
    project1.task = project1Task; 
    projects.add(project1); 
    project1Task.projects.add(project1); 
 
    var project2 = Project(projects.concept); 
    project2.tasks = 'secretary'; 
    var project2Task = tasks.random(); 
    project2.task = project2Task; 
    projects.add(project2); 
    project2Task.projects.add(project2); 
 
    var project3 = Project(projects.concept); 
    project3.tasks = 'drink'; 
    var project3Task = tasks.random(); 
    project3.task = project3Task; 
    projects.add(project3); 
    project3Task.projects.add(project3); 
 
  } 
 
  void initCalendars() { 
    var calendar1 = Calendar(calendars.concept); 
    calendar1.events = 'cinema'; 
    var calendar1Task = tasks.random(); 
    calendar1.task = calendar1Task; 
    calendars.add(calendar1); 
    calendar1Task.calendar.add(calendar1); 
 
    var calendar2 = Calendar(calendars.concept); 
    calendar2.events = 'oil'; 
    var calendar2Task = tasks.random(); 
    calendar2.task = calendar2Task; 
    calendars.add(calendar2); 
    calendar2Task.calendar.add(calendar2); 
 
    var calendar3 = Calendar(calendars.concept); 
    calendar3.events = 'candy'; 
    var calendar3Task = tasks.random(); 
    calendar3.task = calendar3Task; 
    calendars.add(calendar3); 
    calendar3Task.calendar.add(calendar3); 
 
  } 
 
  void initContextLists() { 
    var contextList1 = ContextList(contextLists.concept); 
    contextList1.contexts = 'series'; 
    var contextList1Task = tasks.random(); 
    contextList1.task = contextList1Task; 
    contextLists.add(contextList1); 
    contextList1Task.contextLists.add(contextList1); 
 
    var contextList2 = ContextList(contextLists.concept); 
    contextList2.contexts = 'effort'; 
    var contextList2Task = tasks.random(); 
    contextList2.task = contextList2Task; 
    contextLists.add(contextList2); 
    contextList2Task.contextLists.add(contextList2); 
 
    var contextList3 = ContextList(contextLists.concept); 
    contextList3.contexts = 'cabinet'; 
    var contextList3Task = tasks.random(); 
    contextList3.task = contextList3Task; 
    contextLists.add(contextList3); 
    contextList3Task.contextLists.add(contextList3); 
 
  } 
 
  void initReviews() { 
    var review1 = Review(reviews.concept); 
    review1.assessments = 'ship'; 
    reviews.add(review1); 
 
    var review2 = Review(reviews.concept); 
    review2.assessments = 'computer'; 
    reviews.add(review2); 
 
    var review3 = Review(reviews.concept); 
    review3.assessments = 'nothingness'; 
    reviews.add(review3); 
 
  } 
 
  void initNextActions() { 
    var nextAction1 = NextAction(nextActions.concept); 
    nextAction1.work = 'notch'; 
    nextActions.add(nextAction1); 
 
    var nextAction2 = NextAction(nextActions.concept); 
    nextAction2.work = 'web'; 
    nextActions.add(nextAction2); 
 
    var nextAction3 = NextAction(nextActions.concept); 
    nextAction3.work = 'dinner'; 
    nextActions.add(nextAction3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
