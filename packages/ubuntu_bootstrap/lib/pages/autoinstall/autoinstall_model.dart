import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:subiquity_client/subiquity_server.dart';
import 'package:ubuntu_bootstrap/installer/installer_model.dart';
import 'package:ubuntu_bootstrap/pages/loading/loading_provider.dart';
import 'package:ubuntu_bootstrap/ubuntu_bootstrap.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:yaml/yaml.dart';

final _log = Logger('autoinstall_model');

final autoinstallModelProvider = ChangeNotifierProvider(
  (ref) => AutoinstallModel(
    getService<SubiquityClient>(),
    getService<SubiquityServer>(),
    () {
      ref.read(restartProvider.notifier).state++;
      ref.invalidate(loadingProvider);
    },
    dryRun: getService<ArgResults>()['dry-run'] == true,
  ),
);

class AutoinstallModel extends SafeChangeNotifier {
  AutoinstallModel(
    this._subiquity,
    this._subiquityServer,
    this.resetUi, {
    @visibleForTesting FileSystem? fs,
    @visibleForTesting HttpClient? httpClient,
    @visibleForTesting bool dryRun = false,
  })  : _fs = fs ?? const LocalFileSystem(),
        _httpClient = httpClient ?? HttpClient(),
        _dryRun = dryRun {
    Listenable.merge([_url, _state]).addListener(notifyListeners);
  }

  static const filename = 'autoinstall.yaml';
  static const targetDir = '/';

  final SubiquityClient _subiquity;
  final SubiquityServer _subiquityServer;
  final VoidCallback resetUi;
  final FileSystem _fs;
  final HttpClient _httpClient;
  final bool _dryRun;

  final _url = ValueNotifier('');
  String get url => _url.value;
  set url(String value) {
    state = const AsyncValue<void>.data(null);
    _url.value = value;
  }

  final _state = ValueNotifier(const AsyncValue<void>.data(null));
  AsyncValue<void> get state => _state.value;
  set state(AsyncValue<void> value) => _state.value = value;

  Future<void> _fetch() async {
    final uri = Uri.parse(url);

    final response = await _httpClient
        .getUrl(uri)
        .then((request) => request.close())
        .then((httpResponse) => httpResponse.transform(utf8.decoder).join());

    loadYaml(response);

    final file = _fs.file(p.join(
      _fs.systemTempDirectory.absolute.path,
      filename,
    ));
    await file.writeAsString(response);
    _log.debug('Downloaded $uri to ${file.absolute.path}');

    if (_dryRun) {
      final dir = _fs.directory(p.join(await getSubiquityPath(), '.subiquity'));
      if (dir.existsSync()) {
        file.renameSync(p.join(dir.absolute.path, filename));
      }
      return;
    }

    final result =
        await Process.run('sudo', ['mv', file.absolute.path, targetDir]);
    if (result.exitCode != 0) {
      _log.error(
          'Failed to move ${file.absolute.path} to $targetDir: ${result.stderr}');
      return;
    }
    _log.debug('Moved ${file.absolute.path} to $targetDir');
  }

  Future<void> _restart() async {
    _log.debug('Restarting subiquity');
    await _subiquity.restart();
    await _subiquityServer.waitSubiquity();
    resetUi();
  }

  Future<void> apply() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _fetch();
      await _restart();
    });
  }
}
