 
part of project_brainstorming; 
 
// lib/project/brainstorming/model.dart 
 
class BrainstormingModel extends BrainstormingEntries { 
 
  BrainstormingModel(Model model) : super(model); 
 
  void fromJsonToMindMapEntry() { 
    fromJsonToEntry(projectBrainstormingMindMapEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(projectBrainstormingModel); 
  } 
 
  void init() { 
    initMindMaps(); 
  } 
 
  void initMindMaps() { 
    var mindMap1 = MindMap(mindMaps.concept); 
    mindMap1.name = 'down'; 
    mindMap1.description = 'algorithm'; 
    mindMaps.add(mindMap1); 
 
    var mindMap2 = MindMap(mindMaps.concept); 
    mindMap2.name = 'call'; 
    mindMap2.description = 'sun'; 
    mindMaps.add(mindMap2); 
 
    var mindMap3 = MindMap(mindMaps.concept); 
    mindMap3.name = 'girl'; 
    mindMap3.description = 'table'; 
    mindMaps.add(mindMap3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
