import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

abstract class IDomainLayout {
  // have domain, model
  Domain get domain;

  Model get model;

  // have left sidebar, right sidebar, main content, footer
  Widget get focus;

  Widget get secondary;

  Widget get auxiliary;

  //build layout
  Widget build(BuildContext context);

  // have onDomainSelected, onModelSelected, onEntitySelected
  void onDomainSelected(Domain domain);

  void onModelSelected(Model model);

  void onEntitySelected(Entity entity);
}
