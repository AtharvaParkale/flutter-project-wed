import 'package:flutter_project/features/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Counter Class - ", () {
    test(
      "given to us is a counter class when it is instantiated then value should be 0",
      () {
        final Counter counter = Counter();
        final val = counter.count;
        expect(val, 0);
      },
    );

    test("Test 2", () {
      final Counter counter = Counter();
      counter.incrementCounter();

      final val = counter.count;

      expect(val, 1);
    });

    test("Test 3", () {
      final Counter counter = Counter();
      counter.decrementCounter();

      final val = counter.count;

      expect(val, -1);
    });
  });
}
