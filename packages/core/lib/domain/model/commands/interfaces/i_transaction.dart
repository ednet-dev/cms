part of ednet_core;

abstract class ITransaction extends ICommand {
  void add(ICommand command);

  IPast get past;
}
