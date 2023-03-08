part of ednet_core;

abstract class ISourceOfCommandReaction {

  void startCommandReaction(ICommandReaction reaction);
  void cancelCommandReaction(ICommandReaction reaction);

  void notifyCommandReactions(ICommand action);

}
