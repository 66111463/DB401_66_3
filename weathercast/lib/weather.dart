class Weather { // ชื่อ class ในทาง Practicular ที่ถูก จะขึ้นต้องตัวอักษรเป็น Uppercase
  final dynamic _weather; // '_' = Private จะใช้งานได้ภายใน Class นี้เท่านั้น
  final double temp; // final เป็น Static Property ประเภทหนึ่ง หากใส่มาด้านหน้าจะเป็นการกำหนดค่าตัวแปรเป็นแบบ Static // 'double?' = กำหนดให้ตัวแปรเริ่มจากค่าว่าง 'null' ได้
  final String place;

  Weather(this._weather, this.temp, this.place); 
  // Weather(this._weather, this.temp, this.place) { // this._weather เป็นการส่งค่าเป็นแบบ Argument
  // Weather([1,2,3], 35.0, 'aaa') // Pass by position
  // Weather(_weather: [1,2,3], temp: 35.0, place: 'aaa') // Pass by name (เป็น optional ได้)
  // Weather({required this._weather, required this.temp, required this.place) // required = จำเป็นต้องมี
  
  String get condition => _weather['description']; // get เป็นการเรียกใช้ ส่วน set เป็นการกำหนดค่า
  // String get condition {
  //  return _weather['description'];
  // } //การทำ Function แบบส่งค่าเป็น return
  String get symbol => 'https://openweathermap.org/img/wn/${_weather["icon"]}@2x.png'; // get รูปภาพจาก url
} 
