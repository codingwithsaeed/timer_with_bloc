import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer_with_bloc/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 10;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
  }

  FutureOr<void> _onStarted(event, emit) {
    emit(TimerInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration)));
  }

  FutureOr<void> _onTicked(event, emit) {
    emit(
      event.duration > 0
          ? TimerInProgress(event.duration)
          : const TimerComplete(),
    );
  }

  FutureOr<void> _onPaused(event, emit) {
    if (state is TimerInProgress) {
      _tickerSubscription?.pause();
      emit(TimerPause(state.duration));
    }
  }

  FutureOr<void> _onResumed(event, emit) {
    if (state is TimerPause) {
      _tickerSubscription?.resume();
      emit(TimerPause(state.duration));
    }
  }

  FutureOr<void> _onReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
