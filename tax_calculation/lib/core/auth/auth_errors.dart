abstract class AuthError {}

class UserNotFoundError extends AuthError {}

class InvalidPasswordError extends AuthError {}

class EmailAlreadyExistsError extends AuthError {}

class UnknownAuthError extends AuthError {}
