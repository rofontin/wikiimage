import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String wikiImageTable = "wikiImageTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String descriptionColumn = "descriptionColumn";
final String imgColumn = "imgColumn";

class WikiImageDB {

  static final WikiImageDB _instance = WikiImageDB.internal();

  factory WikiImageDB() => _instance;

  WikiImageDB.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();

      return _db;
    }
  }

  Future<Database> initDb() async {
    final dataBasesPath = await getDatabasesPath();
    final path = join(dataBasesPath, "wikiimages.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $wikiImageTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,"
        " $descriptionColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<WikiImage> saveWikiImage(WikiImage wikiImage) async {
    Database dbWikiImage = await db;
    wikiImage.idWikiImage = await dbWikiImage.insert(wikiImageTable, wikiImage.toMap());
    return wikiImage;
  }

  Future<WikiImage> getWikiImage(int idWikiImage) async {
    Database dbWikiImage = await db;
    List<Map> maps = await dbWikiImage.query(wikiImageTable, 
      columns: [idColumn, nameColumn, descriptionColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [idWikiImage]);
    if(maps.length > 0){
      return WikiImage.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteWikiImage(int idWikiImage) async {
    Database dbWikiImage = await db;
    return await dbWikiImage.delete(wikiImageTable, where: "$idColumn = ?", whereArgs: [idWikiImage]);
  }

  Future<int> updateWikiImage(WikiImage wikiImage) async {
    Database dbWikiImage = await db;
    return await dbWikiImage.update(wikiImageTable, wikiImage.toMap(), where: "$idColumn = ?", whereArgs: [wikiImage.idWikiImage]);
  }

  Future<List> getAllWikiImage() async {
    Database dbWikiImage = await db;
    List listMap = await dbWikiImage.rawQuery("SELECT * FROM $wikiImageTable");
    List<WikiImage> listWikiImage = List();

    for(Map map in listMap){
      listWikiImage.add(WikiImage.fromMap(map));
    }

    return listWikiImage;
  }

  Future<int> getNumber() async {
    Database dbWikiImage = await db;
    return Sqflite.firstIntValue(await dbWikiImage.rawQuery("SELECT COUNT(*) FROM $wikiImageTable"));
  }

  Future close() async {
    Database dbWikiImage = await db;
    dbWikiImage.close();
  }

}

class WikiImage {

  int idWikiImage;
  String nome;
  String description;
  String img;

  WikiImage();

  WikiImage.fromMap(Map map){
    idWikiImage = map[idColumn];
    nome = map[nameColumn];
    description = map[descriptionColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: nome,
      descriptionColumn: description,
      imgColumn: img
    };

    if(idWikiImage != null){
      map[idColumn] = idWikiImage;
    }

    return map;
  }

  @override
  String toString() {
    return "WikiImage(idWikiImage: $idWikiImage, nome: $nome, description: $description, img: $img)";
  }

}