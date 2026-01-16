String? numberValidator(String? value, {bool required = false}) {
  if (value == null || value.isEmpty) {
    return required ? 'กรุณากรอกข้อมูล' : null;
  }

  final normalized = value.replaceAll(',', '');
  final number = double.tryParse(normalized);

  if (number == null) {
    return 'กรุณากรอกเป็นตัวเลข';
  }

  if (required && number <= 0) {
    return 'ค่าต้องมากกว่า 0';
  }

  return null;
}
