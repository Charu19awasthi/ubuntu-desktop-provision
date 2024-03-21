import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_bootstrap/pages/source/on_battery_snackbar.dart';
import 'package:ubuntu_bootstrap/pages/source/source_model.dart';
import 'package:ubuntu_bootstrap/pages/source/source_selection_page.dart';
import 'package:ubuntu_test/ubuntu_test.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_test/yaru_test.dart';

import 'test_source.dart';

void main() {
  testWidgets('source id', (tester) async {
    final model = buildSourceModel(sourceId: kFullSourceId);
    await tester.pumpApp((_) => buildSourceSelectionPage(model));

    expect(find.radio<String?>(kFullSourceId), isChecked);
    expect(find.radio<String?>(kMinimalSourceId), isNotChecked);

    when(model.sourceId).thenReturn('ubuntu-desktop-minimal');

    await tester.tap(find.radio<String?>(kMinimalSourceId));

    verify(model.setSourceId('ubuntu-desktop-minimal')).called(1);
  });

  testWidgets('on battery', (tester) async {
    final model = buildSourceModel(onBattery: true);
    await tester.pumpApp((_) => buildSourceSelectionPage(model));
    await tester.pumpAndSettle();

    // TODO: Should either find a OnBatterySnackBar or find the text when it is
    // possible.
    // https: //github.com/flutter/flutter/issues/124859
    final warningSnackBar = find.byType(SnackBar);
    expect(warningSnackBar, findsOneWidget);
  });

  testWidgets('not on battery', (tester) async {
    final model = buildSourceModel(onBattery: false);
    await tester.pumpApp((_) => buildSourceSelectionPage(model));

    expect(find.byType(Html), findsNothing);
  });

  testWidgets('continue on the next page', (tester) async {
    final model = buildSourceModel(sourceId: kFullSourceId);
    await tester.pumpApp((_) => buildSourceSelectionPage(model));

    await tester.tapNext();
    await tester.pumpAndSettle();

    expect(find.text('Next page'), findsOneWidget);
  });
}
