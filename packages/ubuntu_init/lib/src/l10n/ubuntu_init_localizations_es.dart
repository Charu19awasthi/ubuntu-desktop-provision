import 'ubuntu_init_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class UbuntuInitLocalizationsEs extends UbuntuInitLocalizations {
  UbuntuInitLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomePageTitle => 'Le damos la bienvenida';

  @override
  String welcomePageHeader(Object distro) {
    return 'Le damos la bienvenida a $distro';
  }

  @override
  String get welcomeWhatsNew => '¿QUÉ HAY DE NUEVO?';

  @override
  String get welcomeStartTitle => 'Un comienzo simplificado';

  @override
  String get welcomeStartSubtitle => 'A favor de una experiencia de puesta en marcha más prolija.';

  @override
  String get welcomeStoreTitle => 'Un nuevo aspecto para la Tienda de Aplicaciones';

  @override
  String get welcomeStoreSubtitle => 'Nunca ha sido tan fácil encontrar sus programas favoritos.';

  @override
  String get welcomeSecurityTitle => 'Mayor seguridad';

  @override
  String get welcomeSecuritySubtitle => 'Nuevas opciones de cifrado por hardware o ZFS.';

  @override
  String welcomeChangelogLabel(Object url) {
    return '<a href=\"$url\">Ver registro de cambios</a>';
  }

  @override
  String get telemetryPageTitle => 'Telemetría';

  @override
  String telemetryHeader(Object distro) {
    return 'Ayude a mejorar $distro';
  }

  @override
  String telemetryDescription(Object distro) {
    return 'Comparta datos de forma anónima con $distro para que podamos mejorar su experiencia.';
  }

  @override
  String telemetryLabelOn(Object distro) {
    return 'Sí, compartir datos del sistema con el equipo de $distro';
  }

  @override
  String get telemetryLabelOff => 'No, no compartir datos del sistema';

  @override
  String get telemetryReportLabel => 'Detalles del informe';

  @override
  String get telemetryReportTitle => 'Detalles del informe';

  @override
  String get telemetryLegalLabel => 'Información legal';

  @override
  String get privacyPageTitle => 'Servicios de ubicación';

  @override
  String get privacyLocationTitle => '¿Quiere activar los servicios de ubicación?';

  @override
  String get privacyLocationSubtitle => 'Permita que las aplicaciones conozcan su ubicación geográfica.\nPuede cambiar esto en cualquier momento en la Configuración del sistema.';

  @override
  String get privacyLocationEnable => 'Servicios de ubicación';

  @override
  String get privacyPolicyLink => 'Protección de los datos';

  @override
  String ubuntuProMagicAttachInstructions(Object url) {
    return 'Magic attach with this code at <a href=\"https://$url\">$url</a>';
  }

  @override
  String get ubuntuProPageTitle => 'Ubuntu Pro';

  @override
  String get ubuntuProHeader => 'Attach this machine';

  @override
  String get ubuntuProOrAddTokenManually => 'or add a token manually';

  @override
  String get ubuntuProTokenTextfieldHint => 'Token';

  @override
  String get ubuntuProSubscriptionDescription => 'Get the most comprehensive subscription for open-source software security';

  @override
  String ubuntuProSubscriptionFreeForPersonalUse(Object url) {
    return 'Always free for personal use. 30-days trial for enterprises. <a href=\"https://$url\">Learn more</a>';
  }

  @override
  String get ubuntuProTokenAttachButton => 'Attach';

  @override
  String get ubuntuProTokenAttachError => 'Invalid token';

  @override
  String get ubuntuProTokenAttachSucess => 'Valid token';

  @override
  String get ubuntuProTokenAttachErrorVariant => 'Invalid token, retry';

  @override
  String get ubuntuProOnBoardingSkipForNow => 'Skip for now';

  @override
  String get ubuntuProOnBoardingSkipForNowDescription => 'You can always enable Ubuntu Pro later via the Software & Updates application.';

  @override
  String get ubuntuProOnBoardingEnableUbuntuPro => 'Enable Ubuntu Pro';

  @override
  String get ubuntuProOnBoardingEnableUbuntuProDescription => 'Attach this machine to an Ubuntu Pro subscription for security updates on a wider range of packages, until 2032.';

  @override
  String get ubuntuProSucessAttachHeader => 'Ubuntu Pro is now enabled in this machine';

  @override
  String get ubuntuProSucessAttachDescription => 'You can manage your Pro services in the Software & Updates application.';
}
