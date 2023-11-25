import 'dart:async';
import 'package:rxdart/rxdart.dart';

Stream<int> numbers(int a, int b) async* {
  for (int i = a; i <= b; i++) {
    yield i;
  }
}

Stream<int> dummynumbers(int c, int d) async* {
  for (int i = c; i <= d; i++) {
    yield i;
  }
}

Stream<int> duplicate() {
  List<int> b = [2, 6, 8, 10];
  return Stream.fromIterable(b);
  //Stream.fromIterable Creates a stream that gets its data from elements
}

void main() {
  //function calling of stream
  _filterStream(numbers(1, 5)).listen((event) {
    print('filter $event');
  });

  _mapStream(numbers(1, 5)).listen((event) {
    print('map $event');
  });

  _combineStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('combine $event');
  });

  _reduceStream(numbers(1, 5)).then((value) => print('reduce $value'));

  _concatStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('concat $event');
  });

  _zipStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('zip $event');
  });

  _flatMap(numbers(1, 5).asBroadcastStream(),
          dummynumbers(1, 5).asBroadcastStream())
      .listen((event) {
    print('flat $event');
  });
  _scanStream(numbers(1, 5)).listen((event) {
    print('scan $event');
  });
  _debounceStream(numbers(1, 5)).listen((event) {
    print('debounce $event');
  });
  _distinctStream(duplicate()).listen((event) {
    print('distinct $event');
  });
  _takeUntilStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('take until $event');
  });
  _defaultEmpty().listen((event) {
    print('empty $event');
  });
  _concatMapStream(numbers(1, 5).asBroadcastStream(),
          dummynumbers(1, 5).asBroadcastStream())
      .listen((event) {
    print('concatMap $event');
  });
  _distintUntilChanged(duplicate()).listen((event) {
    if (event != null) print('DisUnCh $event');
  });

  _concatEagerStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('concatEager $event');
  });

  _mergeStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('merge $event');
  });
  _neverStream().listen((event) {
    print('never $event');
  });
  _raceStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('race $event');
  });

  _sequenceEqualsStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('equals $event');
  });
  _forkJoinStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('fork $event');
  });
  _switchLatestStream(numbers(1, 5), dummynumbers(1, 5)).listen((event) {
    print('switchLatest $event');
  });
}


//function declaration
Stream _filterStream(Stream<int> a) {
  return a => a>10;

}


Stream<int> _mapStream(Stream<int> a) {
  return a.map((event) => event * 8);
}

Stream<Object?> _combineStream(Stream<int> a, Stream<int> b) {
  return CombineLatestStream.list<int>([
    a,
    b,
  ]);
}

Future _reduceStream(Stream<int> c) {
  return c.reduce((previous, element) => previous + element);
}

Stream<dynamic> _concatStream(Stream<int> c, Stream<int> d) {
  return c.concatWith([d]);
}

//Constructs a Stream which merges the specified streams into a sequence using the given zipper Function
Stream<int> _zipStream(Stream<int> a, Stream<int> b) {
  return a.zipWith(b, (int a, int b) => a + b);
}

Stream<int> _flatMap(Stream<int> a, Stream<int> b) {
  return a.flatMap((element) => b.map((event) => element + event));
}

Stream<int> _scanStream(Stream<int> a) {
  return a.scan((int acc, int curr, int i) => acc + curr, 0.toString() as int);
}

Stream _debounceStream(Stream<int> c) {
  return c.debounce((_) => TimerStream(true, Duration(seconds: 1)));
}

Stream _distinctStream(Stream<int> a) {
  return a.distinctUnique();
}

Stream _takeUntilStream(Stream<int> a, Stream<int> b) {
  return a.takeUntil(TimerStream(
    b,
    Duration(microseconds: 50),
  ));
}

Stream _defaultEmpty() {
  return Stream.empty().defaultIfEmpty(10);
}

Stream _concatMapStream(Stream<int> c, Stream<int> d) {
  return c.asyncExpand((event) => d.map((events) => event + events));
}

Stream _distintUntilChanged(Stream<int> a) {
  return a.distinct();
}

Stream<int> _concatEagerStream(Stream<int> a, Stream<int> b) {
  return ConcatEagerStream([a,b]);
}

Stream<int> _mergeStream(Stream<int> a, Stream<int> b) {
  return MergeStream([a, b]);
}

//Constructs a stream that never emit an event and remainsn opened until the developer closes it.
Stream _neverStream() {
  return NeverStream();
}

Stream<int> _raceStream(Stream<int> a, Stream<int> b) {
  return RaceStream([a, b]);
}

Stream<bool> _sequenceEqualsStream(Stream<int> a, Stream<int> b) {
  return Rx.sequenceEqual(a, b);
}

Stream _forkJoinStream(Stream<int> a, Stream<int> b) {
  return ForkJoinStream.list<int>([a, b]);
}

Stream _switchLatestStream(Stream<int> c, Stream<int> d) {
  return SwitchLatestStream<int>(
    Stream.fromIterable([
      Rx.timer(123, Duration(microseconds: 10)),
      c,
      Stream.value(8910),
      d,
    ]),
  );
}
