import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentVerificationPage extends StatefulWidget {
  @override
  _DocumentVerificationPageState createState() => _DocumentVerificationPageState();
}

class _DocumentVerificationPageState extends State<DocumentVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String? _name;
  String? _address;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Handle the picked image file
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Verification'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) => _name = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              onSaved: (value) => _address = value,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Certificate'),
            ),
          ],
        ),
      ),
    );
  }
}