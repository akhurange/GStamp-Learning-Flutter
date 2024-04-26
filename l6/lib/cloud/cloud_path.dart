class CloudPath {
  //**** CLOUD FIRESTORE DB PATHS ****//

  // Db collections
  static const String itemCollection = 'items';

  // Item db Keys
  static const String dbKeyItemName = 'name';
  static const String dbKeyItemCost = 'cost';

  static getItemDocumentPath(String itemId) {
    return '$itemCollection/$itemId';
  }
}
