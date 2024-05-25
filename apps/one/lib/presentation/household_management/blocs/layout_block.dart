import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_event.dart';
import 'layout_initial.dart';
import 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(LayoutInitial()) {
    on<LayoutEvent>((event, emit) {
      // Handle layout events here
    });
  }
}