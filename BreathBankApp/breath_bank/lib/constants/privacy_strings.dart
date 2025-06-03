import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/widgets.dart';

class PrivacyStrings {
  static const String privacyPolicy = 'Política de Privacidad';
  static const String introductionTitle = '1. Introducción';
  static const String introductionDescription =
      'Esta Política de Privacidad describe cómo recopilamos, utilizamos y protegemos su información personal cuando utiliza la aplicación BreathBank. Al utilizar la app, usted acepta las prácticas descritas en esta política.';
  static const String informationWeCollectTitle =
      '2. Información que recopilamos';
  static const String informationWeCollectDescription =
      '''Recopilamos la siguiente información personal para poder ofrecerle una experiencia personalizada y mejorar el funcionamiento de la aplicación:

\t- Nombre de usuario: Para identificarle dentro de la app.

\t- Correo electrónico: Para la autenticación, recuperación de cuenta y comunicaciones importantes.

\t- Datos de salud relacionados con la respiración: Incluyendo resultados de inversiones y evaluaciones, número de respiraciones, duración de ejercicios y estadísticas de progreso.

\t- Historial de uso: Información sobre las inversiones y evaluaciones realizadas, fechas y resultados.

\t- Datos técnicos: Información sobre el dispositivo, sistema operativo y registros de acceso para mejorar la seguridad y el rendimiento de la app.''';

  static const String useOfInformationTitle = '3. Uso de la información';
  static const String howWeUseYourInformationDescription =
      '''La información recopilada se utiliza para:

\t- Permitir el acceso y uso de la app.

\t- Personalizar la experiencia del usuario.

\t- Realizar un seguimiento del progreso y mostrar estadísticas.

\t- Mejorar y mantener la seguridad de la aplicación.

\t- Enviar notificaciones importantes relacionadas con el uso de la app.''';
  static const String dataProtectionTitle = '4. Protección de datos';
  static const String dataProtectionDescription =
      '''La información personal se almacena de forma segura y solo es accesible por el usuario y el equipo responsable del desarrollo de la app. No compartimos sus datos personales con terceros, salvo obligación legal.''';

  static const String userRightsTitle = '5. Derechos del usuario';
  static const String userRightsDescription =
      '''Usted tiene derecho a acceder, corregir o eliminar su información personal en cualquier momento. También puede solicitar la restricción del procesamiento de sus datos o presentar una queja ante la autoridad competente si considera que sus derechos han sido violados.''';

  static const String changesToPolicyTitle = '6. Cambios a esta política';
  static const String changesToPolicyDescription =
      '''Nos reservamos el derecho de modificar esta Política de Privacidad en cualquier momento. Cualquier cambio será publicado en esta página y se notificará a los usuarios mediante un aviso dentro de la aplicación.''';

  static const String date = 'Fecha: {0}';

  static const String acceptance =
      'Habiendo leído y comprendido esta Política de Privacidad, usted afirma que:';

  static const String acceptanceStatement =
      'He leído y acepto la Política de Privacidad';
  static const String futureUseConsentStatement =
      'Doy mi consentimiento para el futuro uso de mis datos';

  static const TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 14,
    color: kPrimaryColor,
  );
}
