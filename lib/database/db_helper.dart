import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //veriables
  static const dbName = "MyDatabase";
  static const dbVersion = 2;
  static const dbTable = "UserData";
  static const coloumid = 'id';
  static const coloumname = 'name';
  static const coloumemail = "email";
  static const coloumPhone = "phone";
  static const coloumpassword = "password";
  static const coloumImages = "imagePath";
  static const coloumIsLogin = "IsLogin";

  static const dbTripTable = "TripData";
  static const columDestination = "Destination";
  static const ColumStarting = "StartingPoint";
  static const ColumDateStart = "StartingDate";
  static const ColumDateEnding = "EndingDate";
  static const ColumtripId = 'id';
  static const ColumnTripUsreId = 'TripUserId';

  static const ColumTripBudget = 'Ammount';
  static const ColumCoverPhoto = 'CoverPhoto';
  static const ColomTransportion = "Transportion";
  static const ColomPurpose = "Purpose";
  static const ColomNote = "TripNotes";
  static const ColoumOnGoing = 'ongoing';

  static const dbCompanionTable = 'Companion';
  static const CompanionId = 'id';
  static const CompanionTripId = 'TripId';
  static const CompanionName = "CompanionName";
  static const CompanionNumber = "CompanionNumber";

  static const dbImagesTable = 'Memmories';
  static const imageTripId = 'id';
  static const imageLocation = 'ImagePath';

  static const dbDestination = 'DreamDestination';
  static const userId = 'id';
  static const ammount = 'ammount';
  static const savings = 'savings';
  static const destinationImg = "DestinationImage";
  static const destination = 'Location';

  static const dbexpenseTable = "expensetable";
  static const expTripId = 'Tripid';
  static const travelexpense = 'TravelExp';
  static const shopingexpense = 'ShopingExp';
  static const foodexpense = "FoodExp";
  static const otherexpense = 'OtherExp';
  static const totalExp = 'totalExp';

//constructor
  static final DatabaseHelper instance = DatabaseHelper();

  //database initialize

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: Oncreate,
      onConfigure: (db) {
        db.execute('PRAGMA foreign_keys =ON;');
      },
    );
  }

  Future Oncreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $dbTable(
  $coloumid INTEGER PRIMARY KEY,
  $coloumname TEXT NOT NULL,
  $coloumPhone TEXT NOT NULL,
  $coloumemail TEXT NOT NULL,
  $coloumpassword TEXT NOT NULL,
  $coloumImages TEXT NOT NULL,
  $coloumIsLogin INTEGER
)''');
    await db.execute('''
CREATE TABLE $dbDestination(
  $userId INTEGER,
  $destinationImg TEXT,
  $ammount INTEGER,
  $destination TEXT,
  $savings INTEGER,
  FOREIGN KEY ($userId) REFERENCES $dbTable($coloumid) ON DELETE CASCADE
)
''');
    await db.execute('''
CREATE TABLE $dbTripTable(
  $ColumtripId INTEGER PRIMARY KEY,
  $ColumnTripUsreId INTEGER,
  $columDestination TEXT NOT NULL,
  $ColumStarting TEXT NOT NULL,
  $ColumDateEnding TEXT NOT NULL,
  $ColumDateStart TEXT NOT NULL,
  $ColomTransportion TEXT NOT NULL,
  $ColumCoverPhoto TEXT NOT NULL,
  $ColumTripBudget TEXT NOT NULL,
  $ColomPurpose TEXT NOT NULL,
  $ColomNote TEXT NOT NULL,
  $ColoumOnGoing DEFAULT 0,
  FOREIGN KEY ($ColumnTripUsreId) REFERENCES $dbTable($coloumid) ON DELETE CASCADE
)''');
    await db.execute('''
CREATE TABLE $dbexpenseTable(
  id INTEGER PRIMARY KEY,
  $expTripId INTEGER,
  $travelexpense INTEGER,
  $foodexpense INTEGER,
  $shopingexpense INTEGER,
  $otherexpense INTEGER,
  $totalExp INTEGER,
  FOREIGN KEY ($expTripId) REFERENCES $dbTripTable($ColumtripId) ON DELETE CASCADE
)
''');
    await db.execute('''
CREATE TABLE $dbCompanionTable(
  $CompanionId INTEGER PRIMARY KEY,
  $CompanionTripId INTEGER,
  $CompanionName TEXT,
  $CompanionNumber TEXT,
  FOREIGN KEY ($CompanionTripId) REFERENCES $dbTripTable($ColumtripId) ON DELETE CASCADE
)''');
    await db.execute('''
CREATE TABLE $dbImagesTable(
  $imageTripId INTEGER,
  $imageLocation TEXT,
   FOREIGN KEY ($imageTripId) REFERENCES $dbTripTable($ColumtripId) ON DELETE CASCADE
)
''');
  }

//insert
  insertRecords(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

//read
  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database? db = await instance.database;
    return db!.query(dbTable);
  }

  //update
  Future<int> updateRecords(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[coloumid];
    return await db!
        .update(dbTable, row, where: '$coloumid=?', whereArgs: [id]);
  }

  //delete

  Future<int> deleteRecords(int id) async {
    Database? db = await instance.database;
    return await db!.delete(dbTable, where: '$coloumid=?', whereArgs: [id]);
  }

//Login with Username and Password----------------------------------------------------------------------------
  Future<Map<String, dynamic>> login(String name, String password) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(dbTable,
        where: '$coloumname=? AND $coloumpassword=?',
        whereArgs: [name, password],
        limit: 1);
    if (result.isNotEmpty) {
      int id = result.first['$coloumid'];
      db.update(dbTable, {"IsLogin": 1}, where: '$coloumid=?', whereArgs: [id]);
      return result.first;
    } else {
      return {};
    }
  }

  //Update UserName, Mail Image--------------------------------------------------------------------------------------------------------
  UpdateUserData(Map<String, dynamic> userData, int UserId) async {
    Database? db = await instance.database;
    db!.update(
        dbTable,
        {
          'name': userData[DatabaseHelper.coloumname],
          "email": userData[DatabaseHelper.coloumemail],
          "imagePath": userData[DatabaseHelper.coloumImages]
        },
        where: 'id=?',
        whereArgs: [UserId]);
  }

//Completed Trips----------------------------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> CompletedTripData() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> TripDatas =
        await db!.query(dbTripTable, where: '$ColoumOnGoing=1', limit: 1);
    if (TripDatas.isEmpty) {
      return [];
    } else {
      return TripDatas;
    }
  }
  //Ongoing Trip data Updating---------------------------

  UpdateOngoingTrip(int TripId, int status) async {
    Database? db = await instance.database;
    print('Update trip Function');
    db!.update(dbTripTable, {'ongoing': status},
        where: '$ColumtripId=?', whereArgs: [TripId]);
  }

  //ongoing Trip Data Getting------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> OngoingTripData() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> TripDatas =
        await db!.query(dbTripTable, where: '$ColoumOnGoing=1', limit: 1);
    if (TripDatas.length == 0) {
      return {};
    } else {
      return TripDatas.first;
    }
  }

  intExpense(int Tripid) async {
    Database? db = await instance.database;
    final row = {
      'Tripid': Tripid,
      otherexpense: '0',
      foodexpense: '0',
      shopingexpense: '0',
      travelexpense: '0',
      totalExp: '0',
    };
    db!.insert(dbexpenseTable, row);
  }

  //Expense adding in ongoing-----------------------------------------------------------------------------------------------
  addExpense(Map row, int TripId) async {
    Database? db = await instance.database;

    db!.update(
        dbexpenseTable,
        {
          'Tripid': row[DatabaseHelper.expTripId],
          otherexpense: row[DatabaseHelper.otherexpense],
          foodexpense: row[DatabaseHelper.foodexpense],
          shopingexpense: row[DatabaseHelper.shopingexpense],
          travelexpense: row[DatabaseHelper.travelexpense],
          totalExp: row[DatabaseHelper.totalExp]
        },
        where: '$expTripId=?',
        whereArgs: [TripId]);
    print('Updated Row= $row');
  }

  //Get Expense Deatails----------------------------------------------------------------------------------------------------
  Future<Map<dynamic, dynamic>> getExpenseInfo(int TripId) async {
    print('got in');

    Database? db = await instance.database;
    final result = await db!.query(dbexpenseTable,
        where: '$expTripId=?', whereArgs: [TripId], limit: 1);
    print('res $result');
    if (result.isEmpty) {
      print('empty');
      return {};
    }
    print('not empty');
    return result.first;
  }

//Login Check------------------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>?> getuserLoged() async {
    Database? db = await instance.database;
    final UserDetails =
        await db!.query(dbTable, where: '$coloumIsLogin=1', limit: 1);
    if (UserDetails.length == 0) {
      return null;
    } else {
      return UserDetails.first;
    }
  }

//Log Out User----------------------------------------------------------------------------------------------------------------------------------
  LogOutUser() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!
        .query(dbTable, where: '$coloumIsLogin=?', whereArgs: [1], limit: 1);
    if (result.isNotEmpty) {
      int id = result.first['$coloumid'];
      db.update(dbTable, {"IsLogin": 0}, where: '$coloumid=?', whereArgs: [id]);
    }
  }

//trip database Table------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> readTripRecord(int UserId) async {
    Database? db = await instance.database;
    final data = await db!
        .query(dbTripTable, where: '$ColumnTripUsreId=?', whereArgs: [UserId]);
    return data;
  }

//Trips details Upcoming geting by user id-------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> readUpcomingTrips(int UserId) async {
    Database? db = await instance.database;
    return await db!.query(dbTripTable,
        where: '$ColumnTripUsreId=? AND $ColoumOnGoing=0',
        whereArgs: [UserId],
        orderBy: '$ColumDateStart ASC');
  }

  //Completed Trip datas---------------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> readCompledTrips(int UserId) async {
    Database? db = await instance.database;
    return await db!.query(dbTripTable,
        where: '$ColumnTripUsreId=? AND $ColoumOnGoing=2',
        whereArgs: [UserId],
        orderBy: '$ColumDateEnding ASC');
  }

//trip data aadding and companion adding-----------------------------------------------------------------------
  addTripData(Map<String, dynamic> row, List companion) async {
    Database? db = await instance.database;
    int tripId = await db!.insert(dbTripTable, row);

    if (companion.isNotEmpty) {
      for (var row in companion) {
        row['TripId'] = tripId;
        print(row);
        await db.insert(dbCompanionTable, row);
      }
    }

    intExpense(tripId);
    final comp = await db
        .query(dbCompanionTable, where: 'TripId = ?', whereArgs: [tripId]);
    print('comoa $comp');
  }

//Images adding-------------------------------------------------------------------------------------------------------------
  addImages(int TripId, Map<String, dynamic> Images) async {
    Database? db = await instance.database;
    if (Images.isNotEmpty) {
      await db!.insert(dbImagesTable, Images);
    }
  }

//get Images--------------------------------------------------------------------------------------------------------------------------
  Future<List<Map<String, Object?>>> getImages(int TripId) async {
    Database? db = await instance.database;
    return await db!
        .query(dbImagesTable, where: '$imageTripId=?', whereArgs: [TripId]);
  }

  //delete trip data------------------------------------------------------------------------------------------------------
  Future<int> deleteTripData(int tripId) async {
    Database? db = await instance.database;
    return await db!
        .delete(dbTripTable, where: '$ColumtripId=?', whereArgs: [tripId]);
  }

  //Update dates-----------------------------------------------------------------------------------------------------------------
  UpdateTripDates(String StrtDate, String EndDate, int tripid) async {
    Database? db = await instance.database;

    return db!.update(
        dbTripTable, {"StartingDate": StrtDate, "EndingDate": EndDate},
        where: '$ColumtripId=?', whereArgs: [tripid]);
  }

  //Update Trip Note-------------------------------------------------------------------------------------------------------
  UpdateTripNotes(String Notes, int tripId) async {
    Database? db = await instance.database;
    // print('${tripId}==${Notes}');
    return await db!.update(dbTripTable, {"TripNotes": Notes},
        where: '$ColumtripId=?', whereArgs: [tripId]);
  }

  //Update Trip CoverPhoto----------------------------------------------------------------------------------------------------------------------------------
  UpdateCoverPhoto(String Image, int TripId) async {
    Database? db = await instance.database;
    return await db!.update(dbTripTable, {'CoverPhoto': Image},
        where: '$ColumtripId=?', whereArgs: [TripId]);
  }

  //update trip budget-------------------------------------------------------------------------------------------------------
  UpdateBudget(String Budget, int TripId) async {
    Database? db = await instance.database;
    return await db!.update(dbTripTable, {'Ammount': Budget},
        where: '$ColumtripId=?', whereArgs: [TripId]);
  }

//Companion deteails---------------------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> companionTable(int TripId) async {
    Database? db = await instance.database;
    return await db!.query(dbCompanionTable,
        where: '$CompanionTripId=?', whereArgs: [TripId]);
  }

  //delete Companion----------------------------------------------------------------------------------------------------------
  deleteComapanion(int CompanionID) async {
    Database? db = await instance.database;
    db!.delete(dbCompanionTable,
        where: '$CompanionId=?', whereArgs: [CompanionID]);
  }

//dream destination Add---------------------------------------------------------------------------------------------------
  dreamDestinationAdd(Map<String, dynamic> dreamTrip) async {
    Database? db = await instance.database;
    db!.insert(dbDestination, dreamTrip);
  }

//dream destination getting---------------------------------------------------------------------------------------------------------------
  Future<Map<String, Object?>> dreamDestinationGet(int UserId) async {
    Database? db = await instance.database;
    final result =
        await db!.query(dbDestination, where: '$userId=?', whereArgs: [UserId]);
    if (result.isEmpty) {
      return {};
    } else {
      return result.first;
    }
  }

  //Update Dream trip--------------------------------------------------------------------------------------------------------
  UpdateDreamTrip(int UserId, int savings) async {
    Database? db = await instance.database;
    await db!.update(dbDestination, {'savings': savings},
        where: '$userId=?', whereArgs: [UserId]);
    print('db Updated');
  }
}
