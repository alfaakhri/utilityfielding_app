import 'package:hive/hive.dart';

class HiveService {
  openAndGetDataFromHiveBox(String boxName, String dataByKey) async {
    final openedBox = await Hive.openBox(boxName);
    final dataFromBox = openedBox.get(dataByKey);
    return dataFromBox;
  }

  saveDataToBox(String boxName, String dataByKey, dynamic content) async {
    final openedBox = await Hive.openBox(boxName);
    await openedBox.put(dataByKey, content);
  }

  deleteDataFromBox(String boxName, String dataByKey) async {
    print(dataByKey + "DataKey");

    final openedBox = await Hive.openBox(boxName);
    print(openedBox.length);
    openedBox.delete(dataByKey);

    // await openedBox.delete(dataByKey) ;
  }

  deleteDataFromBoxWithIndex(String boxName, int index) async {
    final openedBox = await Hive.openBox(boxName);
    await openedBox.deleteAt(index);
    print("Delted");
  }
}
