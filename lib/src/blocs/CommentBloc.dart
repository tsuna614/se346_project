import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CommentEvent {}

class AddComment extends CommentEvent {
  final String comment;

  AddComment(this.comment);
}

class RemoveComment extends CommentEvent {
  final int index;

  RemoveComment(this.index);
}

// Define states
abstract class CommentState {}

class CommentsLoaded extends CommentState {
  final List<dynamic> comments;

  CommentsLoaded(this.comments);
}

// Define BLoC
abstract class CommentBlocInterface extends StateStreamableSource<Object?> {}

class CommentBloc implements CommentBlocInterface {
  List<dynamic> _comments = [];

  final _commentStateController = StreamController<CommentState>();
  Stream<CommentState> get commentStateStream => _commentStateController.stream;
  Sink<CommentEvent> get commentEventSink => _commentEventController.sink;

  final _commentEventController = StreamController<CommentEvent>();

  CommentBloc() {
    _commentEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CommentEvent event) {
    if (event is AddComment) {
      //Todo: Add comment to the list. Sample implementation to add id, name, text. Current adding will remove the list due to json sample file. Fix later
      String text = event.comment;

      _comments.add({
        'id': _comments.length,
        'name': 'Anonymous',
        'text': text,
      });
    } else if (event is RemoveComment) {
      _comments.removeAt(event.index);
    }

    _commentStateController.add(CommentsLoaded(_comments));
  }

  void dispose() {
    _commentStateController.close();
    _commentEventController.close();
  }

  //Implement of interface: Closable.close , getter StateStreamableSource<Object?>.stateStream ,  getter Closeable.closed

  @override
  bool get isClosed => _commentStateController.isClosed;

  @override
  Object? get state => _commentStateController.stream;

  @override
  Stream<Object?> get stream => _commentStateController.stream;

  @override
  FutureOr<void> close() {
    return _commentStateController.close();
  }
}
