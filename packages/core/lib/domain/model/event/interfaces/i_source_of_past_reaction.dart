part of ednet_core;

abstract class ISourceOfPastReaction {

  void startPastReaction(IPastCommand reaction);
  void cancelPastReaction(IPastCommand reaction);

  void notifyCannotUndo();
  void notifyCanUndo();
  void notifyCanRedo();
  void notifyCannotRedo();

}