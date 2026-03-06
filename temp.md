
The right JWT payload:
json// Owner token
{
  "sub": "uuid",
  "actor": "owner",
  "name": "Rahim Uddin",
  "email": "rahim@example.com",
  "iat": 1234567890,
  "exp": 1234567890,
  "jti": "uuid"
}
json// Employee token
{
  "sub": "uuid",
  "actor": "employee",
  "role": "MANAGER",
  "branch_id": "uuid",
  "restaurant_id": "uuid",
  "name": "Karim Hossain",
  "iat": 1234567890,
  "exp": 1234567890,
  "jti": "uuid"
}
json// Customer token
{
  "sub": "uuid",
  "actor": "customer",
  "phone": "+8801XXXXXXXXX",
  "iat": 1234567890,
  "exp": 1234567890,
  "jti": "uuid"
}
