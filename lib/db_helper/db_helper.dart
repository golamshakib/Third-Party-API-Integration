import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/current_weather_model.dart';
import '../utils/texts/db_tbl_col_name.dart';

class DBHelper {
  final createTableWeather = '''CREATE TABLE $tableWeather(
  $tblWeatherColId INTEGER PRIMARY KEY AUTOINCREMENT,
  $tblWeatherColLon REAL,
  $tblWeatherColLat REAL,
  $tblWeatherColWeatherId INTEGER,
  $tblWeatherColWeatherMain TEXT,
  $tblWeatherColWeatherDescription TEXT,
  $tblWeatherColWeatherIcon TEXT,
  $tblWeatherColBase TEXT,
  $tblWeatherColTemp REAL,
  $tblWeatherColFeelsLike REAL,
  $tblWeatherColTempMin REAL,
  $tblWeatherColTempMax REAL,
  $tblWeatherColPressure INTEGER,
  $tblWeatherColHumidity INTEGER,
  $tblWeatherColSeaLevel REAL,
  $tblWeatherColGrndLevel REAL,
  $tblWeatherColWindSpeed REAL,
  $tblWeatherColWindDeg INTEGER,
  $tblWeatherColWindGust REAL,
  $tblWeatherColCloudAll INTEGER,
  $tblWeatherColDt INTEGER,
  $tblWeatherColSysType INTEGER,
  $tblWeatherColSysId INTEGER,
  $tblWeatherColSysCountry TEXT,
  $tblWeatherColSysSunrise INTEGER,
  $tblWeatherColSysSunset INTEGER,
  $tblWeatherColTimezone INTEGER,
  $tblWeatherColName TEXT,
  $tblWeatherColCod INTEGER)''';

  Future<Database> _open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, 'weather_db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(createTableWeather);
      },
    );
  }


  /// - Insert weather data
  Future<void> insertWeather(CurrentWeatherModel weather) async {
    final db = await _open();
    await db.insert(
      tableWeather,
      weather.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// - Get cached weather data
  Future<List<CurrentWeatherModel>> getWeatherData() async {
    final db = await _open();
    final List<Map<String, dynamic>> maps = await db.query(tableWeather);
    return List.generate(maps.length, (i) {
      return CurrentWeatherModel.fromMap(maps[i]);
    });
  }

  /// - Delete weather data
  Future<void> deleteWeather() async {
    final db = await _open();
    await db.delete(tableWeather);
  }
}
