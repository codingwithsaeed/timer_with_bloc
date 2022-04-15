part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(int duration) : super(duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerPause extends TimerState {
  const TimerPause(int duration) : super(duration);

  @override
  String toString() => 'TimerPause { duration: $duration }';
}

class TimerInProgress extends TimerState {
  const TimerInProgress(int duration) : super(duration);

  @override
  String toString() => 'TimerInProgress { duration: $duration }';
}

class TimerComplete extends TimerState {
  const TimerComplete() : super(0);
}