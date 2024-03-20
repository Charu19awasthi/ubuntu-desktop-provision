import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_bootstrap/pages/source/source_model.dart';
import 'package:ubuntu_bootstrap/pages/source/source_x.dart';
import 'package:ubuntu_bootstrap/services.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_utils/ubuntu_utils.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

/// A page where the user can decide whether they want to do a full installation
/// with all selected applications or a minimal installation.
///
/// This uses the `source` API of the Subiquity client to get the available
/// sources, and to set the selected source.
class SourceSelectionPage extends ConsumerWidget with ProvisioningPage {
  SourceSelectionPage({super.key});

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) {
    return ref.read(sourceModelProvider).init().then((_) => true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(sourceModelProvider);
    final lang = UbuntuBootstrapLocalizations.of(context);

    return HorizontalPage(
      windowTitle: lang.updatesOtherSoftwarePageTitle,
      title: lang.updatesOtherSoftwarePageDescription,
      contentFlex: 2,
      snackBar: model.onBattery
          ? SnackBar(
              width: 500,
              dismissDirection: DismissDirection.none,
              behavior: SnackBarBehavior.floating,
              content: Html(
                style: {
                  'body': Style(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    margin: Margins.zero,
                  ),
                },
                data: lang.onBatteryWarning(
                    Theme.of(context).colorScheme.error.toHex()),
              ),
              duration: const Duration(days: 1),
              showCloseIcon: true,
            )
          : null,
      isNextEnabled: model.sourceId != null,
      onNext: () async {
        final telemetry = tryGetService<TelemetryService>();
        await telemetry?.addMetrics({
          'Minimal': model.sourceId?.contains('minimal') ?? false,
        });
      },
      children: [
        ...model.sources
            .map(_SourceSelectionListTile.new)
            .withSpacing(kWizardSpacing / 2),
      ],
    );
  }
}

class _SourceSelectionListTile extends ConsumerWidget {
  const _SourceSelectionListTile(this.source);

  final SourceSelection source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final model = ref.watch(sourceModelProvider);
    final isSelected = source.id == model.sourceId;
    final lang = UbuntuBootstrapLocalizations.of(context);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: YaruBorderContainer(
        color: isSelected
            ? colorScheme.primary.withOpacity(0.2)
            : colorScheme.primaryContainer,
        border: Border.all(
          color: isSelected ? colorScheme.primary : theme.dividerColor,
        ),
        borderRadius: kWizardBorderRadius,
        child: YaruRadioListTile(
          title: Text(
            source.localizedTitle(lang),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(source.localizedSubtitle(lang)),
          contentPadding: kWizardTilePadding,
          isThreeLine: true,
          value: source.id,
          groupValue: model.sourceId,
          onChanged: model.setSourceId,
        ),
      ),
    );
  }
}
