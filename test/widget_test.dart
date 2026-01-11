import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/widgets/text_form_fields/labeled_time_form_field.dart';

void main() {
  testWidgets('LabeledTimeFormField validates input', (WidgetTester tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Form(
            key: formKey,
            child: LabeledTimeFormField(
              controller: controller,
              label: '睡眠時間',
              icon: Icons.av_timer,
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('入力してください。'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '25:99');
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('正しい時間形式(hh:mm)で入力してください。'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '7:30');
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text('正しい時間形式(hh:mm)で入力してください。'), findsNothing);
  });
}
