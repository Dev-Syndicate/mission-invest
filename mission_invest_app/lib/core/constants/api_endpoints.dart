class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.16.41.115:8000',
  );

  static const String health = '/health';
  static const String nudge = '/ai/nudge';
  static const String adapt = '/ai/adapt';
  static const String predict = '/ai/predict';
  static const String message = '/ai/message';
}
