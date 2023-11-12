import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _database;
  static const String dbName = 'your_database.db';

  // Table names
  static const String tablePerson = 'person';
  static const String tableWound = 'wound';
  static const String tableSession = 'session';
  static const String tableMessage = 'message';

  // Define columns for the 'person' table
  final String idNo = 'id_no';
  final String email = 'e_mail';
  final String firstName = 'first_name';
  final String lastName = 'last_name';
  final String teleNo = 'Tele_no';
  final String password = 'password';
  final String dob = 'DOB';
  final String address = 'Address';
  final String medicalRgstrNo = 'Medical_rgstr_no';
  final String medicalQualification = 'Medical_qualification';
  final String currentMedication = 'Current_medication';

  // Define columns for the 'wound' table
  final String woundId = 'Wound_id';
  final String patientId = 'Patient_id';
  final String woundDate = 'Date';
  final String classificationType = 'Classification_type';
  final String woundArea = 'Wound_area';
  final String woundImage = 'Wound_image';

  // Define columns for the 'session' table
  final String docId = 'Doc_id';
  final String roomId = 'Room_id';
  final String sessionDate = 'Date';
  final String sessionPassword = 'Passwords';
  final String sessionTime = 'Time';
  final String sessionPatientId = 'Patient_id';

  // Define columns for the 'message' table
  final String messageId = 'Message_id';
  final String messageContent = 'Content';
  final String messageType = 'Message_type';
  final String receivedId = 'Reseived_id';
  final String senderId = 'Sender_id';
  final String sentTime = 'Sent_time';

  DbHelper._createInstance();

  factory DbHelper() {
    return _dbHelper;
  }

  static final DbHelper _dbHelper = DbHelper._createInstance();

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePerson (
        $idNo TEXT PRIMARY KEY,
        $email TEXT NOT NULL UNIQUE,
        $firstName TEXT DEFAULT NULL,
        $lastName TEXT DEFAULT NULL,
        $teleNo TEXT DEFAULT NULL,
        $password TEXT NOT NULL UNIQUE,
        $dob DATE DEFAULT NULL,
        $address TEXT DEFAULT NULL,
        $medicalRgstrNo TEXT DEFAULT NULL UNIQUE,
        $medicalQualification TEXT DEFAULT NULL,
        $currentMedication TEXT DEFAULT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableWound (
        $woundId TEXT NOT NULL,
        $patientId TEXT NOT NULL,
        $woundDate TEXT DEFAULT NULL,
        $classificationType TEXT NOT NULL,
        $woundArea REAL NOT NULL,
        $woundImage BLOB NOT NULL,
        PRIMARY KEY ($woundId, $patientId)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSession (
        $docId TEXT NOT NULL,
        $roomId TEXT NOT NULL,
        $sessionDate DATE DEFAULT NULL,
        $sessionPassword TEXT NOT NULL,
        $sessionTime TIME DEFAULT NULL,
        $sessionPatientId TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMessage (
        $messageId TEXT NOT NULL,
        $messageContent TEXT DEFAULT NULL,
        $messageType CHAR(10) DEFAULT NULL,
        $receivedId TEXT NOT NULL,
        $senderId TEXT NOT NULL,
        $sentTime DATETIME NOT NULL
      )
    ''');
  }

  Future<int> insertPerson(person) async {
    final db = await database;
    return await db!.insert(tablePerson, person.toMap());
  }

  Future<int> insertWound(wound) async {
    final db = await database;
    return await db!.insert(tableWound, wound.toMap());
  }

  Future<int> insertSession(session) async {
    final db = await database;
    return await db!.insert(tableSession, session.toMap());
  }

  Future<int> insertMessage(message) async {
    final db = await database;
    return await db!.insert(tableMessage, message.toMap());
  }
}
