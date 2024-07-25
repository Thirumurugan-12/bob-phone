import 'package:bob_phone/screens/document.dart';
import 'package:bob_phone/screens/invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('TrackRiz')),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvoicePage()),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.inventory),
                  title: Text('Invoice Management'),
                  subtitle: Text('Manage your invoices and Track here'),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DocumentVerificationPage()),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.document_scanner),
                  title: Text('Document Verification'),
                  subtitle: Text('Verify your documents here'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.document_scanner),
                title: Text('Credit Score'),
                subtitle: Text('Check your credit score here'),
              ),
            ),
            // Add more cards here
          ],
        ),
      ),
    );
  }
}
