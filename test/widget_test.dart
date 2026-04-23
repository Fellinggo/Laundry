import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wushlaundry/main.dart';

void main() {
  testWidgets('WushLaundryApp builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const WushLaundryApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}