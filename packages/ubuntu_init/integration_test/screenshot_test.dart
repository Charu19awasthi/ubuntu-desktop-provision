import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ubuntu_init/src/init_step.dart';
import 'package:ubuntu_init/ubuntu_init.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_provision_test/ubuntu_provision_test.dart';
import 'package:ubuntu_test/ubuntu_test.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => autoUpdateGoldenFiles = true);

  setUp(registerFakeInitServices);

  tearDown(rootBundle.clear);

  testWidgets('00.welcome', (tester) async {
    await tester.runApp(() => runInitApp(['--welcome'], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.testWelcomeInitPage(
      screenshot: '$currentThemeName/00.welcome',
    );
  }, variant: themeVariant);

  testWidgets('01.locale', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.testLocalePage(
      screenshot: '$currentThemeName/01.locale',
    );
  }, variant: themeVariant);

  testWidgets('02.keyboard', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.keyboard.route);
    await tester.pumpAndSettle();

    await tester.testKeyboardPage(
      screenshot: '$currentThemeName/02.keyboard',
    );
  }, variant: themeVariant);

  testWidgets('03.network', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.network.route);
    await tester.pumpAndSettle();

    await tester.testNetworkPage(
      mode: ConnectMode.none,
      screenshot: '$currentThemeName/03.network',
    );
  }, variant: themeVariant);

  testWidgets('04.timezone', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.timezone.route);
    await tester.pumpAndSettle();

    await tester.testTimezonePage(
      screenshot: '$currentThemeName/04.timezone',
    );
  }, variant: themeVariant);

  testWidgets('05.identity', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.identity.route);
    await tester.pumpAndSettle();

    await tester.testIdentityPage(
      identity: const Identity(
        realname: 'Ubuntu User',
        hostname: 'ubuntu',
        username: 'user',
      ),
      password: 'password',
      screenshot: '$currentThemeName/05.identity',
    );
  }, variant: themeVariant);

  testWidgets('06.ubuntu-pro-onboarding', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.ubuntuProOnboarding.route);
    await tester.pumpAndSettle();

    await tester.testUbunutuProOnboardingPage(
      screenshot: '$currentThemeName/06.ubuntu-pro-onboarding',
    );
  }, variant: themeVariant);

  testWidgets('07.ubuntu-pro', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.ubuntuProOnboarding.route);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(UbuntuProOnboardingPage));
    final l10n = UbuntuProLocalizations.of(context);

    final option = find.text(l10n.ubuntuProOnBoardingEnableUbuntuPro);
    await tester.tap(option);
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.ubuntuPro.route);
    await tester.pumpAndSettle();

    await tester.testUbuntuProPage(
      screenshot: '$currentThemeName/07.ubuntu-pro',
    );
  }, variant: themeVariant);

  testWidgets('08.ubuntu-pro-success', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.ubuntuProOnboarding.route);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(UbuntuProOnboardingPage));
    final l10n = UbuntuProLocalizations.of(context);

    final option = find.text(l10n.ubuntuProOnBoardingEnableUbuntuPro);
    await tester.tap(option);
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.ubuntuProSuccess.route);
    await tester.pumpAndSettle();

    await tester.testUbuntuProSuccessAttachProPage(
      screenshot: '$currentThemeName/08.ubuntu-pro-success',
    );
  }, variant: themeVariant);

  testWidgets('09.telemetry', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.telemetry.route);
    await tester.pumpAndSettle();

    await tester.testTelemetryPage(
      screenshot: '$currentThemeName/09.telemetry',
    );
  }, variant: themeVariant);

  testWidgets('10.privacy', (tester) async {
    await tester.runApp(() => runInitApp([], theme: currentTheme));
    await tester.pumpAndSettle();

    await tester.jumpToPage(InitStep.privacy.route);
    await tester.pumpAndSettle();

    await tester.testPrivacyPage(
      screenshot: '$currentThemeName/10.privacy',
    );
  }, variant: themeVariant);
}

ThemeData get currentTheme => themeVariant.currentValue!;
String get currentThemeName => themeVariant.currentName;

final themeVariant = YaruThemeVariant();
