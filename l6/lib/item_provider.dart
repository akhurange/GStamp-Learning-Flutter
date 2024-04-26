import 'package:flutter/foundation.dart';

import 'cloud/cloud_database.dart';
import 'cloud/cloud_path.dart';

class ItemProvider extends ChangeNotifier {
  List<Document>? _itemList;
  CloudDatabase _cloudDatabase = CloudDatabase();

  List<Document>? get itemList {
    if (null == _itemList) {
      _fetchItemList();
    }
    return _itemList;
  }

  void _fetchItemList() async {
    print('fetching item list from cloud db');
    _itemList = await _cloudDatabase.readCollection(CloudPath.itemCollection);
    notifyListeners();
  }

  void deleteItem(Document item) {
    _itemList!.remove(item);
    notifyListeners();
    String itemDocPath = CloudPath.getItemDocumentPath(item.docId);
    _cloudDatabase.deleteDocument(itemDocPath);
  }

  void addItem(Document item) {
    _itemList!.add(item);
    notifyListeners();
  }

  void updateItem(Document item) {
    for (Document i in _itemList!) {
      if (item.docId == i.docId) {
        i.data = item.data;
      }
    }
    notifyListeners();
  }
}
