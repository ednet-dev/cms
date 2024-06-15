 
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
    mindMap1.name = 'up'; 
    mindMap1.description = 'nothingness'; 
    mindMaps.add(mindMap1); 
 
    var mindMap2 = MindMap(mindMaps.concept); 
    mindMap2.name = 'coffee'; 
    mindMap2.description = 'vessel'; 
    mindMaps.add(mindMap2); 
 
    var mindMap3 = MindMap(mindMaps.concept); 
    mindMap3.name = 'coffee'; 
    mindMap3.description = 'celebration'; 
    mindMaps.add(mindMap3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
