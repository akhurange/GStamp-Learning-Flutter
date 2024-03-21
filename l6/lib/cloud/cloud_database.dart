import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  String docId;
  Map<String, dynamic> data;

  Document({required this.docId, required this.data});
}

class CloudDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  static const String operationEqualTo = 'eq';
  static const String operationNotEqualTo = 'ne';
  static const String operationLessThan = 'lt';
  static const String operationLessThanEqualTo = 'lte';
  static const String operationGreaterThan = 'gt';
  static const String operationGreaterThanEqualTo = 'gte';
  static const String operationWhereIn = 'whereIn';

  static Future<void> refreshConnectivity() async {
    await FirebaseFirestore.instance.enableNetwork();
    return;
  }

  static FieldValue deleteFieldValue() {
    return FieldValue.delete();
  }

  Future<Map<String, dynamic>?> readDocument(String documentPath) async {
    try {
      DocumentReference documentReference = _firestore.doc(documentPath);
      DocumentSnapshot? documentSnapshot = await documentReference.get();
      return documentSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<List<Document>> readCollection(
    String collectionPath,
  ) async {
    List<Document> listDocument = [];
    CollectionReference collectionReference =
        _firestore.collection(collectionPath);
    QuerySnapshot collectionSnapshot = await collectionReference.get();
    for (var document in collectionSnapshot.docs) {
      listDocument.add(Document(
        docId: document.id,
        data: document.data() as Map<String, dynamic>,
      ));
    }
    return listDocument;
  }

  Future<List<Document>> readCollectionRef(
    CollectionReference collectionReference,
  ) async {
    List<Document> listDocument = [];
    QuerySnapshot collectionSnapshot = await collectionReference.get();
    for (var document in collectionSnapshot.docs) {
      listDocument.add(Document(
        docId: document.id,
        data: document.data() as Map<String, dynamic>,
      ));
    }
    return listDocument;
  }

  Future<List<Document>> queryIsEqualTo(
    String collectionPath,
    List<String> lvalue,
    List<dynamic> rvalue,
  ) async {
    List<Document> listDocument = [];
    Query query = _firestore.collection(collectionPath).where(
          lvalue[0],
          isEqualTo: rvalue[0],
        );
    for (int i = 1; i < lvalue.length; i++) {
      query = query.where(lvalue[i], isEqualTo: rvalue[i]);
    }
    QuerySnapshot querySnapshot = await query.get();
    for (var document in querySnapshot.docs) {
      listDocument.add(
        Document(
          docId: document.id,
          data: document.data() as Map<String, dynamic>,
        ),
      );
    }
    return listDocument;
  }

  Future<List<Document>> queryGeneral(
    String collectionPath,
    List<String> lvalue,
    List<String> operation,
    List<dynamic> rvalue, {
    String? orderBy,
    bool? descending,
  }) async {
    List<Document> listDocument = [];
    Query query = _firestore.collection(collectionPath);
    for (int i = 0; i < lvalue.length; i++) {
      switch (operation[i]) {
        case operationEqualTo:
          query = query.where(lvalue[i], isEqualTo: rvalue[i]);
          break;
        case operationNotEqualTo:
          query = query.where(lvalue[i], isNotEqualTo: rvalue[i]);
          break;
        case operationLessThan:
          query = query.where(lvalue[i], isLessThan: rvalue[i]);
          break;
        case operationLessThanEqualTo:
          query = query.where(lvalue[i], isLessThanOrEqualTo: rvalue[i]);
          break;
        case operationGreaterThan:
          query = query.where(lvalue[i], isGreaterThan: rvalue[i]);
          break;
        case operationGreaterThanEqualTo:
          query = query.where(lvalue[i], isGreaterThanOrEqualTo: rvalue[i]);
          break;
        case operationWhereIn:
          query = query.where(lvalue[i], whereIn: rvalue[i]);
          break;
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending ?? false);
    }

    QuerySnapshot querySnapshot = await query.get();
    for (var document in querySnapshot.docs) {
      listDocument.add(
        Document(
          docId: document.id,
          data: document.data() as Map<String, dynamic>,
        ),
      );
    }
    return listDocument;
  }

  Future<List<QueryDocumentSnapshot>> queryGeneralPaginate(
    String collectionPath,
    List<String> lvalue,
    List<String> operation,
    List<dynamic> rvalue,
    String? orderBy,
    DocumentSnapshot? lastDocument,
    int limit,
    bool? descending,
  ) async {
    Query query = _firestore.collection(collectionPath);
    for (int i = 0; i < lvalue.length; i++) {
      switch (operation[i]) {
        case operationEqualTo:
          query = query.where(lvalue[i], isEqualTo: rvalue[i]);
          break;
        case operationNotEqualTo:
          query = query.where(lvalue[i], isNotEqualTo: rvalue[i]);
          break;
        case operationLessThan:
          query = query.where(lvalue[i], isLessThan: rvalue[i]);
          break;
        case operationLessThanEqualTo:
          query = query.where(lvalue[i], isLessThanOrEqualTo: rvalue[i]);
          break;
        case operationGreaterThan:
          query = query.where(lvalue[i], isGreaterThan: rvalue[i]);
          break;
        case operationGreaterThanEqualTo:
          query = query.where(lvalue[i], isGreaterThanOrEqualTo: rvalue[i]);
          break;
        case operationWhereIn:
          query = query.where(lvalue[i], whereIn: rvalue[i]);
          break;
      }
    }
    if (null != orderBy) {
      query = query.orderBy(orderBy, descending: descending ?? false);
    }
    QuerySnapshot querySnapshot;
    if (null == lastDocument) {
      querySnapshot = await query.limit(limit).get();
    } else {
      querySnapshot =
          await query.startAfterDocument(lastDocument).limit(limit).get();
    }
    return querySnapshot.docs;
  }

  void insertDocument(String documentPath, Map<String, dynamic> content) {
    DocumentReference documentReference = _firestore.doc(documentPath);
    documentReference.set(content);
  }

  Future<DocumentReference> autoInsertDocument(
    String collectionPath,
    Map<String, dynamic> content,
  ) {
    CollectionReference collectionReference =
        _firestore.collection(collectionPath);
    return collectionReference.add(content);
  }

  Future<String> autoInsertDocumentSync(
    String collectionPath,
    Map<String, dynamic> content,
  ) async {
    CollectionReference collectionReference =
        _firestore.collection(collectionPath);
    DocumentReference docRef = await collectionReference.add(content);
    return docRef.id;
  }

  void updateDocument(
    String documentPath,
    Map<String, dynamic> content,
  ) async {
    DocumentReference documentReference = _firestore.doc(documentPath);
    documentReference.update(content);
  }

  void deleteDocument(
    String documentPath,
  ) async {
    DocumentReference documentReference = _firestore.doc(documentPath);
    documentReference.delete();
  }

  Future<bool> createOrUpdateDocument(
    String documentPath,
    Map<String, dynamic> createContent,
    Map<String, dynamic> updateContent,
  ) async {
    try {
      DocumentReference documentReference = _firestore.doc(documentPath);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        documentReference.update(updateContent);
      } else {
        documentReference.set(createContent);
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<int> transactionalCounter(
    String documentPath,
    String fieldKey,
    int delta,
  ) async {
    DocumentReference documentReference = _firestore.doc(documentPath);
    return _firestore.runTransaction((transaction) async {
      int fieldValue = 0;
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (snapshot.exists) {
        if (null != (snapshot.data() as Map<String, dynamic>)[fieldKey]) {
          fieldValue = (snapshot.data() as Map<String, dynamic>)[fieldKey];
        }
        fieldValue += delta;
        transaction.update(documentReference, {fieldKey: fieldValue});
      } else {
        fieldValue += delta;
        transaction.set(documentReference, {fieldKey: fieldValue});
      }
      return fieldValue;
    }).catchError((error) {
      return -1;
    });
  }

  Future<void> fieldValueCounter(
    String documentPath,
    String fieldKey,
    int delta,
  ) async {
    DocumentReference documentReference = _firestore.doc(documentPath);
    documentReference.update({fieldKey: FieldValue.increment(delta)});
  }

  Future<List<DocumentSnapshot>> paginateRead(String collectionPath,
      String field, int limit, DocumentSnapshot? lastDocument,
      {bool descending = false}) async {
    if (null == lastDocument) {
      QuerySnapshot qsFirstPage = await _firestore
          .collection(collectionPath)
          .orderBy(field, descending: descending)
          .limit(limit)
          .get();
      return qsFirstPage.docs;
    } else {
      QuerySnapshot qsNextPage = await _firestore
          .collection(collectionPath)
          .orderBy(field, descending: descending)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get();
      return qsNextPage.docs;
    }
  }

  Future<List<DocumentSnapshot>> paginateQueryIsEqualTo(
    String collectionPath,
    String lvalue,
    dynamic rvalue,
    int limit,
    DocumentSnapshot? lastDocument,
  ) async {
    Query query =
        _firestore.collection(collectionPath).where(lvalue, isEqualTo: rvalue);
    if (null == lastDocument) {
      QuerySnapshot queryFirstPage = await query.limit(limit).get();
      return queryFirstPage.docs;
    } else {
      QuerySnapshot queryNextPage =
          await query.startAfterDocument(lastDocument).limit(limit).get();
      return queryNextPage.docs;
    }
  }
}

class CloudDatabasePaginateGeneralQuery {
  final String collectionPath;
  final int limit;
  final List<String> lvalue;
  final List<String> operation;
  final List<dynamic> rvalue;
  // Any query can have range operator on only one field.
  // You must order your query on that field.
  final String? orderBy;
  final bool? descending;
  late bool _isEndOfPagination;
  DocumentSnapshot? _lastDocument;
  late CloudDatabase _cloudDatabase;

  CloudDatabasePaginateGeneralQuery({
    required this.collectionPath,
    required this.limit,
    required this.lvalue,
    required this.rvalue,
    required this.operation,
    this.orderBy,
    this.descending,
  }) {
    _isEndOfPagination = false;
    _lastDocument = null;
    _cloudDatabase = CloudDatabase();
  }

  void resetPagination() {
    _lastDocument = null;
    _isEndOfPagination = false;
  }

  bool isEndOfPagination() {
    return _isEndOfPagination;
  }

  Future<List<Document>> getNextPage() async {
    if (_isEndOfPagination) {
      return [];
    }
    List<DocumentSnapshot> result = await _cloudDatabase.queryGeneralPaginate(
      collectionPath,
      lvalue,
      operation,
      rvalue,
      orderBy,
      _lastDocument,
      limit,
      descending,
    );
    if (result.isNotEmpty) {
      _lastDocument = result[result.length - 1];
    }
    _isEndOfPagination = result.length < limit;
    return result
        .map((e) =>
            Document(docId: e.id, data: e.data() as Map<String, dynamic>))
        .toList();
  }
}
