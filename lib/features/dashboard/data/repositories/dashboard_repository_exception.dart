class   DashboardRepositoryException implements Exception {
  final String message;
  DashboardRepositoryException(this.message);

  @override
  String toString() => 'DashboardRepositoryException: $message';
}