class CurrentWeatherModel {
  final double? lon;
  final double? lat;
  final int? weatherId;
  final String? weatherMain;
  final String? weatherDescription;
  final String? weatherIcon;
  final String? base;
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final double? seaLevel;
  final double? grndLevel;
  final double? windSpeed;
  final int? windDeg;
  final double? windGust;
  final int? cloudAll;
  final int? dt;
  final int? sysType;
  final int? sysId;
  final String? sysCountry;
  final int? sysSunrise;
  final int? sysSunset;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  CurrentWeatherModel({
    this.lon,
    this.lat,
    this.weatherId,
    this.weatherMain,
    this.weatherDescription,
    this.weatherIcon,
    this.base,
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.cloudAll,
    this.dt,
    this.sysType,
    this.sysId,
    this.sysCountry,
    this.sysSunrise,
    this.sysSunset,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  // Convert JSON to model
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      lon: json['coord']?['lon']?.toDouble(),
      lat: json['coord']?['lat']?.toDouble(),
      weatherId: json['weather']?[0]?['id'],
      weatherMain: json['weather']?[0]?['main'],
      weatherDescription: json['weather']?[0]?['description'],
      weatherIcon: json['weather']?[0]?['icon'],
      base: json['base'],
      temp: json['main']?['temp']?.toDouble(),
      feelsLike: json['main']?['feels_like']?.toDouble(),
      tempMin: json['main']?['temp_min']?.toDouble(),
      tempMax: json['main']?['temp_max']?.toDouble(),
      pressure: json['main']?['pressure'],
      humidity: json['main']?['humidity'],
      seaLevel: json['main']?['sea_level']?.toDouble(),
      grndLevel: json['main']?['grnd_level']?.toDouble(),
      windSpeed: json['wind']?['speed']?.toDouble(),
      windDeg: json['wind']?['deg'],
      windGust: json['wind']?['gust']?.toDouble(),
      cloudAll: json['clouds']?['all'],
      dt: json['dt'],
      sysType: json['sys']?['type'],
      sysId: json['sys']?['id'],
      sysCountry: json['sys']?['country'],
      sysSunrise: json['sys']?['sunrise'],
      sysSunset: json['sys']?['sunset'],
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }

  // Convert model to SQLite-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'lon': lon,
      'lat': lat,
      'weatherId': weatherId,
      'weatherMain': weatherMain,
      'weatherDescription': weatherDescription,
      'weatherIcon': weatherIcon,
      'base': base,
      'temp': temp,
      'feelsLike': feelsLike,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'pressure': pressure,
      'humidity': humidity,
      'seaLevel': seaLevel,
      'grndLevel': grndLevel,
      'windSpeed': windSpeed,
      'windDeg': windDeg,
      'windGust': windGust,
      'cloudAll': cloudAll,
      'dt': dt,
      'sysType': sysType,
      'sysId': sysId,
      'sysCountry': sysCountry,
      'sysSunrise': sysSunrise,
      'sysSunset': sysSunset,
      'timezone': timezone,
      'id': id,
      'name': name,
      'cod': cod,
    };
  }

  // Convert Map to model
  factory CurrentWeatherModel.fromMap(Map<String, dynamic> map) {
    return CurrentWeatherModel(
      lon: map['lon'],
      lat: map['lat'],
      weatherId: map['weatherId'],
      weatherMain: map['weatherMain'],
      weatherDescription: map['weatherDescription'],
      weatherIcon: map['weatherIcon'],
      base: map['base'],
      temp: map['temp'],
      feelsLike: map['feelsLike'],
      tempMin: map['tempMin'],
      tempMax: map['tempMax'],
      pressure: map['pressure'],
      humidity: map['humidity'],
      seaLevel: map['seaLevel'],
      grndLevel: map['grndLevel'],
      windSpeed: map['windSpeed'],
      windDeg: map['windDeg'],
      windGust: map['windGust'],
      cloudAll: map['cloudAll'],
      dt: map['dt'],
      sysType: map['sysType'],
      sysId: map['sysId'],
      sysCountry: map['sysCountry'],
      sysSunrise: map['sysSunrise'],
      sysSunset: map['sysSunset'],
      timezone: map['timezone'],
      id: map['id'],
      name: map['name'],
      cod: map['cod'],
    );
  }
}
