import 'package:core_platform/core_platform.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const required = PlatformStatus(
  update: UpdateNeed.required,
  updateMessage: 'حدّث',
  maintenance: false,
);
const suggested = PlatformStatus(
  update: UpdateNeed.suggested,
  maintenance: false,
);

void main() {
  late List<Object> answers;
  late int reads;
  late PlatformCheck check;

  // Each read takes the next answer: a status, or an error to throw.
  Future<PlatformStatus> read() async {
    reads++;
    final answer = answers.removeAt(0);
    if (answer is PlatformStatus) return answer;
    throw answer;
  }

  setUp(() {
    reads = 0;
    check = PlatformCheck(read);
  });

  tearDown(() => check.dispose());

  testWidgets('blocks nothing until the first answer', (tester) async {
    answers = [required];
    expect(check.status, PlatformStatus.clear);
    expect(check.status.blocks, isFalse);
    check.start();
    await tester.pump();
    expect(check.status, required);
    expect(check.status.blocks, isTrue);
  });

  testWidgets('reads again when the app resumes', (tester) async {
    answers = [PlatformStatus.clear, required];
    check.start();
    await tester.pump();
    expect(check.status, PlatformStatus.clear);
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();
    expect(reads, 2);
    expect(check.status, required);
  });

  testWidgets('retries a failed read, 5 s doubling', (tester) async {
    answers = [Exception('offline'), Exception('offline'), required];
    check.start();
    await tester.pump();
    expect(reads, 1);
    await tester.pump(const Duration(seconds: 5));
    expect(reads, 2);
    await tester.pump(const Duration(seconds: 9));
    expect(reads, 2);
    await tester.pump(const Duration(seconds: 1));
    expect(reads, 3);
    expect(check.status, required);
  });

  testWidgets('keeps the banner dismissed for the run', (tester) async {
    answers = [suggested, suggested];
    check.start();
    await tester.pump();
    expect(check.showsBanner, isTrue);
    check.dismissBanner();
    expect(check.showsBanner, isFalse);
    await check.check();
    expect(check.showsBanner, isFalse);
  });

  test('maintenance and a required update block; a suggested one does not', () {
    expect(
      const PlatformStatus(update: UpdateNeed.none, maintenance: true).blocks,
      isTrue,
    );
    expect(required.blocks, isTrue);
    expect(suggested.blocks, isFalse);
  });
}
