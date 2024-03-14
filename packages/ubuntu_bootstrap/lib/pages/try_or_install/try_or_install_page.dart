import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_bootstrap/pages/try_or_install/try_or_install_model.dart';
import 'package:ubuntu_bootstrap/widgets.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

export 'try_or_install_model.dart' show TryOrInstallOption;

class TryOrInstallPage extends ConsumerWidget with ProvisioningPage {
  const TryOrInstallPage({super.key});

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) {
    return Future.wait([
      ref.read(tryOrInstallModelProvider).init(),
      MascotAvatar.precacheAsset(context),
    ]).then((_) => true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(tryOrInstallModelProvider);
    final lang = UbuntuBootstrapLocalizations.of(context);
    final flavor = ref.watch(flavorProvider);

    return HorizontalPage(
      windowTitle: lang.tryOrInstallTitle(flavor.displayName),
      title: lang.tryOrInstallHeader(flavor.displayName),
      content: Column(
        children: [
          OptionButton(
            value: TryOrInstallOption.installUbuntu,
            groupValue: model.option,
            title: Text(lang.installOption(flavor.displayName)),
            subtitle: Text(lang.installDescription(flavor.displayName)),
            onChanged: (value) => model.selectOption(value!),
          ),
          const SizedBox(height: kWizardSpacing / 2),
          OptionButton(
            value: TryOrInstallOption.tryUbuntu,
            groupValue: model.option,
            title: Text(lang.tryOption(flavor.displayName)),
            subtitle: Text(lang.tryDescription(flavor.displayName)),
            onChanged: (value) => model.selectOption(value!),
          ),
          const SizedBox(height: kWizardSpacing / 2),
          // const SizedBox(height: kContentSpacing / 2),
          // OptionButton(
          //   value: Option.repairUbuntu,
          //   groupValue: model.option,
          //   title: Text(lang.welcomeRepairOption),
          //   subtitle: Text(lang.welcomeRepairDescription),
          //   onChanged: (value) => model.selectOption(value!),
          // ),
        ],
      ),
      bottomBar: WizardBar(
        leading: const BackWizardButton(),
        trailing: [
          WizardButton(
            label: UbuntuLocalizations.of(context).nextLabel,
            visible: model.option == TryOrInstallOption.tryUbuntu,
            execute: YaruWindow.of(context).close,
          ),
          NextWizardButton(
            visible: model.option != TryOrInstallOption.tryUbuntu,
            enabled: model.option != TryOrInstallOption.none,
            arguments: model.option,
          ),
        ],
      ),
    );
  }
}
