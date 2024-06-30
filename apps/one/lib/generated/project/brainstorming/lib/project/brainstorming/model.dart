 
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
    mindMap1.name = 'sailing'; 
    mindMap1.description = 'message'; 
    mindMaps.add(mindMap1); 
 
    var mindMap2 = MindMap(mindMaps.concept); 
    mindMap2.name = 'redo'; 
    mindMap2.description = 'heaven'; 
    mindMaps.add(mindMap2); 
 
    var mindMap3 = MindMap(mindMaps.concept); 
    mindMap3.name = 'body'; 
    mindMap3.description = 'job'; 
    mindMaps.add(mindMap3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
