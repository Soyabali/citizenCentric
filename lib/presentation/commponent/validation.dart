bool _isMobileNumberValid(String mobile) {
  final trimmed = mobile.trim();

  // 1️⃣ Must be exactly 10 digits
  if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
    return false;
  }

  // 2️⃣ First digit must be between 6–9
  if (!RegExp(r'^[6-9]').hasMatch(trimmed)) {
    return false;
  }

  // 3️⃣ Reject numbers where all digits are same (e.g. 0000000000)
  if (RegExp(r'^(\d)\1{9}$').hasMatch(trimmed)) {
    return false;
  }

  return true;
}