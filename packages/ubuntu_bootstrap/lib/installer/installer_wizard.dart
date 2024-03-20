import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_bootstrap/installer/installation_step.dart';
import 'package:ubuntu_bootstrap/installer/installer_model.dart';
import 'package:ubuntu_bootstrap/pages.dart';
import 'package:ubuntu_bootstrap/services.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';

class InstallerWizard extends ConsumerStatefulWidget {
  const InstallerWizard({super.key});

  @override
  ConsumerState<InstallerWizard> createState() => _InstallerWizardState();
}

class _InstallerWizardState extends ConsumerState<InstallerWizard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final model = ref.read(installerModelProvider);
    model.init();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = MediaQuery.platformBrightnessOf(context);
    ref.read(brightnessProvider.notifier).state = brightness;
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(installerModelProvider.select((m) => m.status));
    if (status?.state == ApplicationState.ERROR) {
      return const _ErrorWizard();
    }
    return status?.interactive == false
        ? _AutoinstallWizard(status: status)
        : const _InstallWizard();
  }
}

class _InstallWizard extends ConsumerWidget {
  const _InstallWizard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preInstallRoutes = <String, WizardRoute>{
      for (final step in InstallationStep.wizardSteps)
        step.route: step.toRoute(context, ref)
    };
    final totalSteps =
        InstallationStep.values.where((value) => value.discreteStep).length;

    return WizardBuilder(
      initialRoute: InstallationStep.loading.route,
      userData: WizardData(totalSteps: totalSteps),
      routes: {
        InstallationStep.loading.route: WizardRoute(
          builder: (_) => const LoadingPage(),
          userData: const WizardRouteData(
            hasPrevious: false,
            hasNext: false,
          ),
          onReplace: (_) =>
              const LoadingPage().load(context, ref).then((_) => null),
        ),
        ...preInstallRoutes,
        InstallationStep.install.route: WizardRoute(
          builder: (_) => const InstallPage(),
          onLoad: (_) => const InstallPage().load(context, ref),
        ),
      },
      predicate: (route) {
        if ([
          InstallationStep.loading.route,
          InstallationStep.confirm.route,
          InstallationStep.install.route,
        ].contains(route)) {
          return true;
        } else {
          return ref.read(installerModelProvider).hasRoute(route);
        }
      },
      observers: [_InstallerObserver(getService<TelemetryService>())],
    );
  }
}

class _InstallerObserver extends NavigatorObserver {
  _InstallerObserver(this._telemetry);

  final TelemetryService _telemetry;

  @override
  void didPush(Route<Object?> route, Route<Object?>? previousRoute) {
    if (route.settings.name != null) {
      _telemetry.addStage(route.settings.name!.replaceFirst('/', ''));
    }
  }
}

class _AutoinstallWizard extends ConsumerWidget {
  const _AutoinstallWizard({this.status});

  final ApplicationStatus? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WizardBuilder(
      routes: <String, WizardRoute>{
        InstallationStep.loading.route: WizardRoute(
          builder: (_) => const LoadingPage(),
          userData: const WizardRouteData(
            hasPrevious: false,
            hasNext: false,
          ),
          onReplace: (_) =>
              const LoadingPage().load(context, ref).then((_) => null),
        ),
        InstallationStep.confirm.route: WizardRoute(
          builder: (_) => const ConfirmPage(),
          onLoad: (_) => status?.isInstalling != true,
        ),
        InstallationStep.install.route: WizardRoute(
          builder: (_) => const InstallPage(),
          onLoad: (_) => const InstallPage().load(context, ref),
        ),
      },
    );
  }
}

class _ErrorWizard extends StatelessWidget {
  const _ErrorWizard();

  @override
  Widget build(BuildContext context) {
    return Wizard(
      routes: <String, WizardRoute>{
        InstallationStep.install.route: WizardRoute(
          builder: (_) => const InstallPage(),
        ),
      },
    );
  }
}
