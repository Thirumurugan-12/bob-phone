import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  File? _image;
  String? _response;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://0384-117-254-38-213.ngrok-free.app/api/recognize_receipts'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print(response.body);
    setState(() {
      _response =
          'Response status: ${response.statusCode}\nResponse body: ${response.body}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Page'),
      ),
      body: Center( 
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
                    _image!,
                    fit: BoxFit.values[1],
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
            Text(_response ?? ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: uploadImage,
          child: Text('Upload'),
        ),
      ),
    );
  }
}
