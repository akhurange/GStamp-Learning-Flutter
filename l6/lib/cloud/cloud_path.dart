class CloudPath {
  //**** CLOUD FIRESTORE DB PATHS ****//

  // Db collections
  static const String endUserCollection = 'end_user';
  static const String oemCollection = 'oem';
  static const String projectCollection = 'project';
  static const String subProjectCollection = 'subproject';
  static const String itemCollection = 'item';

  static String getEndUserCollectionPath() {
    return endUserCollection;
  }

  static String getOemCollectionPath() {
    return oemCollection;
  }

  static String getProjectCollectionPath() {
    return projectCollection;
  }

  static String getSubProjectCollectionPath(String projectId) {
    return '$projectCollection/$projectId/$subProjectCollection';
  }

  static String getSubProjectDocumentPath(
      String projectId, String subProjectId) {
    return '$projectCollection/$projectId/$subProjectCollection/$subProjectId';
  }

  static String getItemCollectionPath(String projectId, String subProjectId) {
    return '$projectCollection/$projectId/$subProjectCollection/$subProjectId/$itemCollection';
  }
}
