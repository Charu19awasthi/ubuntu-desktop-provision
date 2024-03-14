import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:ubuntu_init/ubuntu_init.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:ubuntu_utils/ubuntu_utils.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

Future<void> runInitApp(
  List<String> args, {
  String package = 'ubuntu_init',
  ThemeData? theme,
  ThemeData? darkTheme,
  GenerateAppTitle? onGenerateTitle,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  FutureOr<void> Function()? onDone,
}) async {
  final exe = p.basename(Platform.resolvedExecutable);
  final log = Logger.setup(path: '/var/log/installer/$exe.log');

  return runZonedGuarded(() async {
    FlutterError.onError = (error) {
      log.error('Unhandled exception', error.exception, error.stack);
    };

    log.debug('Initializing YaruWindowTitleBar');
    await YaruWindowTitleBar.ensureInitialized();

    log.debug('Initializing services');
    await registerInitServices(args);

    log.debug('Loading theme config');
    final themeVariantService = getService<ThemeVariantService>();
    await themeVariantService.load();
    final themeVariant = themeVariantService.themeVariant;

    final windowTitle =
        await getService<ConfigService>().get<String>('app-name');

    log.debug('Loading page config');
    await getService<PageConfigService>().load();

    final welcome = tryGetService<ArgResults>()?['welcome'] as bool? ?? false;

    final flavor = await loadFlavor();

    runApp(ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(flavorProvider.notifier).state = flavor;
          });
          return WizardApp(
            flavor: flavor,
            theme: theme ?? themeVariant?.theme,
            darkTheme: darkTheme ?? themeVariant?.darkTheme,
            onGenerateTitle: onGenerateTitle ?? (_) => windowTitle ?? '',
            locale: ref.watch(localeProvider),
            localizationsDelegates: [
              ...?localizationsDelegates,
              ...GlobalUbuntuInitLocalizations.delegates,
            ],
            supportedLocales: supportedLocales,
            home: DefaultAssetBundle(
              bundle: ProxyAssetBundle(rootBundle, package: package),
              child: welcome
                  ? WelcomeWizard(onDone: onDone)
                  : InitWizard(onDone: onDone),
            ),
          );
        },
      ),
    ));
  }, (error, stack) => log.error('Unhandled exception', error, stack));
}
