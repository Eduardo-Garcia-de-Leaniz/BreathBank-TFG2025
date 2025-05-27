class Strings {
  // General
  static const String appTitle = 'BreathBank';
  static const String welcome = '¡Bienvenido a BreathBank!';

  // Login & Register
  static const String login = 'Iniciar sesión';
  static const String register = 'Registrarse';
  static const String email = 'Correo electrónico';
  static const String password = 'Contraseña';
  static const String confirmPassword = 'Confirmar contraseña';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String alreadyHaveAccount = '¿Ya tienes una cuenta? ';
  static const String dontHaveAccount = '¿No tienes una cuenta? ';
  static const String errorLogin = 'Las credenciales son incorrectas';
  static const String hintEmail = 'Ingrese su correo electrónico';
  static const String hintPassword = 'Ingrese su contraseña';
  static const String hintConfirmPassword = 'Confirme su contraseña';
  static const String passwordMismatch = 'Las contraseñas no coinciden';
  static const String passwordTooShort =
      'La contraseña debe tener al menos 6 caracteres';
  static const String invalidEmail = 'Correo electrónico inválido';
  static const String emptyEmail = 'Introduce un correo electrónico';
  static const String emptyPassword = 'Introduce una contraseña';
  static const String emptyConfirmPassword = 'Confirme su contraseña';
  static const String emptyName = 'Introduce un nombre de usuario';
  static const String registerTitle = 'Registro';
  static const String name = 'Nombre de usuario';
  static const String registerButton = 'Registrarse';
  static const String loginButton = 'Iniciar sesión';
  static const String errorRegister = 'Error al registrar el usuario';
  static const String hintName = 'Ingrese su nombre de usuario';

  // Evaluation
  static const String evaluationTitle = 'Evaluación';
  static const String pluralEvaluation = 'Evaluaciones';
  static const String newEvaluation = 'Nueva evaluación';
  static const String completedTests = 'Has completado {0} de 3 pruebas';
  static const String startTest1 = 'Iniciar Prueba 1';
  static const String startTest2 = 'Iniciar Prueba 2';
  static const String startTest3 = 'Iniciar Prueba 3';
  static const String continueButton = 'Continuar';
  static const String testResultError = 'Por favor, ingrese un número válido.';
  static const String evaluationResultTitle = 'Resultados de pruebas:';
  static const String noResults = 'Sin resultados disponibles.';
  static const String evaluationCompleted = '¡Evaluación completada!';
  static const String test1 = 'Respiraciones en reposo';
  static const String test2 = 'Tiempo de 3 respiraciones';
  static const String test3 = 'Nº respiraciones guiadas';
  static const String breathUnits = 'respiraciones';
  static const String secondsUnits = 'segundos';
  static const String newLevel = 'Nuevo nivel de inversor';
  static const String updateEvaluationData =
      'Se ha actualizado el nivel de inversor y el saldo se ha restablecido.';

  // Investment
  static const String investmentTitle = 'Inversión';
  static const String pluralInvestment = 'Inversiones';
  static const String newInvestment = 'Nueva inversión';
  static const String investmentCompleted = '¡Inversión completada!';
  static const String investmentSuccess =
      '¡Has superado con éxito la inversión!';
  static const String investmentFail =
      'No has superado el objetivo. ¡Sigue practicando!';
  static const String investmentResults =
      'Aquí están los resultados de tu ejercicio de inversión:';
  static const String deleteInvestmentsTitle = 'Borrar inversiones';
  static const String deleteInvestmentsMessage =
      '¿Seguro que quieres borrar todas tus inversiones? Esta acción no se puede deshacer.';
  static const String cancel = 'Cancelar';
  static const String confirm = 'Confirmar';

  // Account Settings
  static const String consultDataTitle = 'Consultar Datos';
  static const String editName =
      'Puedes editar tu nombre de usuario y consultar tus datos';
  static const String updateSuccess = 'Datos actualizados correctamente';
  static const String updateError = 'Error al actualizar los datos';
  static const String loadDataError = 'Error al cargar los datos: {0}';

  // Others
  static const String yes = 'Sí';
  static const String no = 'No';
  static const String seconds = 'segundos';
  static const String delete = 'Borrar';
  static const String save = 'Guardar';
  static const String next = 'Siguiente';
  static const String back = 'Atrás';
  static const String testError = 'Por favor, ingrese un número válido.';
  static const String noData = 'Sin datos disponibles';
  static const String seeMore = 'Ver más';
  static const String seeLess = 'Ver menos';

  // Pruebas
  static const String description = 'Descripción de la prueba';
  static const String instructions = 'Instrucciones paso a paso';
  static const String swipeToStart = '¡Desliza para comenzar la prueba!';

  // Test 1
  static const String test1Title = 'Nº respiraciones en reposo';
  static const String test1Description =
      'Se contabilizará el número de respiraciones en reposo que realice el usuario durante 60 segundos. ';
  static const String test1Instructions =
      '1. Siéntate en un lugar tranquilo y cómodo. Cuando estés listo, pulsa en el icono azul para comenzar la prueba\n'
      '\n'
      '2. A continuación, saltará una cuenta atrás. Justo cuando finalice, comienza tu primera inspiración.\n'
      '\n'
      '3. Durante la prueba respira normalmente. Cada vez que termines de inspirar, pulsa en la pantalla y comienza a expirar, y viceversa (cada vez que completes una respiración se actualizará el contador).\n'
      '\n'
      '4. Cuando haya finalizado el tiempo, se registrará el número de respiraciones que has realizado. Si lo deseas puedes editar el resultado para que se ajuste al resultado real.\n'
      '\n'
      '5. Finalmente, pulsa en el botón "Siguiente" para guardar el resultado.';
  static const String breathCountText = 'Llevas {0} {1}';
  static const String breathPhaseText = 'Pulsa cuando termines de {0}';
  static const String test1Label = 'Ingresa el número de respiraciones';
  static const String test1Hint = 'Número de respiraciones';

  // Test 2
  static const String test2Title = 'Tiempo de 3 respiraciones';
  static const String test2Description =
      'Se contabilizará el tiempo máximo que tarda el usuario en realizar 3 respiraciones completas.';
  static const String test2Instructions =
      '1. Siéntate en un lugar tranquilo y cómodo. Cuando estés listo, pulsa en el icono azul para comenzar la prueba\n'
      '\n'
      '2. A continuación, saltará una cuenta atrás. Justo cuando finalice, comienza tu primera inspiración.\n'
      '\n'
      '3. Durante la prueba respira lo más lentamente posible, sin hacer pausa entre inspiración y expiración.\n'
      '\n'
      '4. Cuando hayas completado 3 respiraciones, pulsa en el icono azul de nuevo para detener la prueba. Se registrará el tiempo que has tardado, si lo deseas puedes editar el resultado para que se ajuste al resultado real.\n'
      '\n'
      '5. Finalmente, pulsa en el botón "Siguiente" para guardar el resultado.';

  static const String test2Label = 'Ingresa el número de segundos';
  static const String test2Hint = 'Número de segundos';

  // Test 3
  static const String test3Title = 'Prueba de respiración guiada';
  static const String test3Description =
      'Se contabilizará el número de la última respiración que el usuario sea capaz de completar al ritmo marcado por la prueba.';
  static const String test3Instructions =
      '1. Siéntate en un lugar tranquilo y cómodo. Cuando estés listo, pulsa en el icono azul para comenzar la prueba\n'
      '\n'
      '2. A continuación, saltará una cuenta atrás. Justo cuando finalice, comienza tu primera inspiración.\n'
      '\n'
      '3. Durante la prueba respira al ritmo marcado por la animación, sin hacer pausa entre inspiración y expiración.\n'
      '\n'
      '4. Cuando no hayas podido realizar la respiración correspondiente de forma completa, pulsa en el icono azul de nuevo para detener la prueba. Se registrará el número de la última respiración que has realizado, si lo deseas puedes editar el resultado para que se ajuste al resultado real.\n'
      '\n'
      '5. Finalmente, pulsa en el botón "Siguiente" para guardar el resultado.';

  static const String test3Label = 'Ingresa el número de la última respiración';
  static const String test3Hint = 'Número de la última respiración completada';

  // Dashboard
  static const String buttonToDashboard = 'Ir a mi Dashboard';
  static const String dashboardTitle = 'Dashboard';
  static const String dashboardWelcome = 'Bienvenid@, {0}';
  static const String inversorLevel = 'Nivel de inversor';
  static const String saldo = 'Saldo';
  static const String lastInvestments = 'Últimas inversiones';
  static const String seeInvestments = 'Ver inversiones';
  static const String lastEvaluations = 'Últimas evaluaciones';
  static const String seeEvaluations = 'Ver evaluaciones';
}
