import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:l6/cloud/cloud_database.dart';
import 'package:l6/cloud/cloud_path.dart';
import 'package:provider/provider.dart';

import 'item_provider.dart';

class ItemForm extends StatefulWidget {
  final Document? item;
  const ItemForm({super.key, this.item});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double cost = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 500,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildNameField(),
            const SizedBox(
              height: 16,
            ),
            _buildCostField(),
            const SizedBox(
              height: 16,
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: (null != widget.item
          ? widget.item!.data[CloudPath.dbKeyItemName]
          : ''),
      decoration: const InputDecoration(
        hintText: 'Item Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.shopping_cart_outlined),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Item Name';
        }
        return null;
      },
      onSaved: (value) => name = value!.trim(),
    );
  }

  Widget _buildCostField() {
    return TextFormField(
      initialValue: (null != widget.item
          ? widget.item!.data[CloudPath.dbKeyItemCost].toString()
          : ''),
      decoration: const InputDecoration(
        hintText: 'Item Cost',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Item Cost';
        }
        return null;
      },
      onSaved: (value) => cost = double.parse(value!.trim()),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        // After validating the form, save it.
        _formKey.currentState!.save();
        CloudDatabase cloudDatabase = CloudDatabase();
        Map<String, dynamic> itemMap = {};
        itemMap[CloudPath.dbKeyItemName] = name;
        itemMap[CloudPath.dbKeyItemCost] = cost;
        Document? document;

        if (null == widget.item) {
          String id = cloudDatabase.firestore
              .collection(CloudPath.itemCollection)
              .doc()
              .id;
          document = Document(docId: id, data: itemMap);
          cloudDatabase.firestore
              .collection(CloudPath.itemCollection)
              .doc(id)
              .set(itemMap);
        } else {
          String docPath = CloudPath.getItemDocumentPath(widget.item!.docId);
          document = Document(docId: widget.item!.docId, data: itemMap);
          cloudDatabase.updateDocument(docPath, itemMap);
        }
        Navigator.pop(context, document);
      },
      child: const Text('SUBMIT'),
    );
  }
}
