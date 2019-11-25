//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:file_picker/file_picker.dart';
//
//
//class ExcelPicker extends StatefulWidget{
//  @override
//  _ExcelPickerState createState() => new _ExcelPickerState();
//}
//
//class _ExcelPickerState extends State<ExcelPicker>{
//  String filePath;
//  String fileName;
//
//  @override
//  void initState(){
//        super.initState();
//        filePath = 'Pick a file';
//        fileName = '';
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    var futureBuilder = new FutureBuilder(
////      future: _openFileExplorer(),
////      builder: (BuildContext context, AsyncSnapshot snapshot) {
////        switch (snapshot.connectionState) {
////          case ConnectionState.none:
////          case ConnectionState.waiting:
////            return new Text('loading...');
////          default:
////            if (snapshot.hasError)
////              return new Text('Error: ${snapshot.error}');
////            else
////              return createListView(context, snapshot);
////        }
////      },
////    );
//
//    return new MaterialApp(
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: const Text('Excel Picker app'),
//        ),
//        body: new Center(
//          child: Column(
//            children: <Widget>[
//              new Padding(
//                padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
//                child: new RaisedButton(
//                  onPressed: () => _openFileExplorer(),
//                  child: new Text("Open file picker"),
//                ),
//              ),
//            ],
//          )
//        ),
//      ),
//      debugShowCheckedModeBanner: false,
//    );
//  }
//
////  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
////    List<String> values = snapshot.data;
////    filePath = values[0];
////    fileName = values[1];
////
////    return new ListView.builder(
////      itemCount: values.length,
////      itemBuilder: (BuildContext context, int index) {
////        return new Column(
////          children: <Widget>[
////            new Text(values[0], textAlign: TextAlign.center,),
////            new Text(values[1], textAlign: TextAlign.center),
////          ],
////        );
////      },
////    );
////  }
//
//  /*
//  new Center(
//           child: new Column(
//             children: <Widget>[
//               new Padding(
//                 padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
//                 child: new RaisedButton(
//                   onPressed: () => _openFileExplorer(),
//                   child: new Text("Open file picker"),
//                 ),
//               ),
//               new Text(filePath, textAlign: TextAlign.center),
//               new Text(fileName, textAlign: TextAlign.center),
//             ],
//           )
//   */
//  void _openFileExplorer() async{
//    // will filter and only let you pick files with svg extension
//    filePath = await FilePicker.getFilePath(type: FileType.CUSTOM, fileExtension: 'xls');
//    fileName = filePath != null ? filePath.split('/').last : "Invalid File Picked" ;
//    _showDialog();
//  }
//
//  Future<void> _showDialog() async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text('Timetable Upload'),
//          content: new Text("Would you like to upload "+fileName),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Cancel'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//            FlatButton(
//              child: Text('Upload'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//}
//
//class FilePickerDemo extends StatefulWidget {
//  @override
//  _FilePickerDemoState createState() => new _FilePickerDemoState();
//}
//
//class _FilePickerDemoState extends State<FilePickerDemo> {
//  String _fileName;
//  String _path;
//  Map<String, String> _paths;
//  String _extension;
//  bool _loadingPath = false;
//  bool _multiPick = false;
//  bool _hasValidMime = false;
//  FileType _pickingType;
//  TextEditingController _controller = new TextEditingController();
//
//  @override
//  void initState() {
//    super.initState();
//    _controller.addListener(() => _extension = _controller.text);
//  }
//
//  void _openFileExplorer() async {
//    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
//      setState(() => _loadingPath = true);
//      try {
//        if (_multiPick) {
//          _path = null;
//          _paths = await FilePicker.getMultiFilePath(
//              type: _pickingType, fileExtension: _extension);
//        } else {
//          _paths = null;
//          _path = await FilePicker.getFilePath(
//              type: _pickingType, fileExtension: _extension);
//        }
//      } on PlatformException catch (e) {
//        print("Unsupported operation" + e.toString());
//      }
//      if (!mounted) return;
//      setState(() {
//        _loadingPath = false;
//        _fileName = _path != null ? _path.split('/').last : _paths != null ? _paths.keys.toString() : '...';
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: const Text('File Picker example app'),
//        ),
//        body: new Center(
//            child: new Padding(
//              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//              child: new SingleChildScrollView(
//                child: new Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    new Padding(
//                      padding: const EdgeInsets.only(top: 20.0),
//                      child: new DropdownButton(
//                          hint: new Text('LOAD PATH FROM'),
//                          value: _pickingType,
//                          items: <DropdownMenuItem>[
//                            new DropdownMenuItem(
//                              child: new Text('FROM AUDIO'),
//                              value: FileType.AUDIO,
//                            ),
//                            new DropdownMenuItem(
//                              child: new Text('FROM IMAGE'),
//                              value: FileType.IMAGE,
//                            ),
//                            new DropdownMenuItem(
//                              child: new Text('FROM VIDEO'),
//                              value: FileType.VIDEO,
//                            ),
//                            new DropdownMenuItem(
//                              child: new Text('FROM ANY'),
//                              value: FileType.ANY,
//                            ),
//                            new DropdownMenuItem(
//                              child: new Text('CUSTOM FORMAT'),
//                              value: FileType.CUSTOM,
//                            ),
//                          ],
//                          onChanged: (value) => setState(() {
//                            _pickingType = value;
//                            if (_pickingType != FileType.CUSTOM) {
//                              _controller.text = _extension = '';
//                            }
//                          })),
//                    ),
//                    new ConstrainedBox(
//                      constraints: BoxConstraints.tightFor(width: 100.0),
//                      child: _pickingType == FileType.CUSTOM
//                          ? new TextFormField(
//                        maxLength: 15,
//                        autovalidate: true,
//                        controller: _controller,
//                        decoration:
//                        InputDecoration(labelText: 'File extension'),
//                        keyboardType: TextInputType.text,
//                        textCapitalization: TextCapitalization.none,
//                        validator: (value) {
//                          RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
//                          if (reg.hasMatch(value)) {
//                            _hasValidMime = false;
//                            return 'Invalid format';
//                          }
//                          _hasValidMime = true;
//                          return null;
//                        },
//                      )
//                          : new Container(),
//                    ),
//                    new ConstrainedBox(
//                      constraints: BoxConstraints.tightFor(width: 200.0),
//                      child: new SwitchListTile.adaptive(
//                        title: new Text('Pick multiple files',
//                            textAlign: TextAlign.right),
//                        onChanged: (bool value) =>
//                            setState(() => _multiPick = value),
//                        value: _multiPick,
//                      ),
//                    ),
//                    new Padding(
//                      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
//                      child: new RaisedButton(
//                        onPressed: () => _openFileExplorer(),
//                        child: new Text("Open file picker"),
//                      ),
//                    ),
//                    new Builder(
//                      builder: (BuildContext context) => _loadingPath
//                          ? Padding(
//                          padding: const EdgeInsets.only(bottom: 10.0),
//                          child: const CircularProgressIndicator())
//                          : _path != null || _paths != null
//                          ? new Container(
//                        padding: const EdgeInsets.only(bottom: 30.0),
//                        height: MediaQuery.of(context).size.height * 0.50,
//                        child: new Scrollbar(
//                            child: new ListView.separated(
//                              itemCount: _paths != null && _paths.isNotEmpty
//                                  ? _paths.length
//                                  : 1,
//                              itemBuilder: (BuildContext context, int index) {
//                                final bool isMultiPath =
//                                    _paths != null && _paths.isNotEmpty;
//                                final String name = 'File $index: ' +
//                                    (isMultiPath
//                                        ? _paths.keys.toList()[index]
//                                        : _fileName ?? '...');
//                                final path = isMultiPath
//                                    ? _paths.values.toList()[index].toString()
//                                    : _path;
//
//                                return new ListTile(
//                                  title: new Text(
//                                    name,
//                                  ),
//                                  subtitle: new Text(path),
//                                );
//                              },
//                              separatorBuilder:
//                                  (BuildContext context, int index) =>
//                              new Divider(),
//                            )),
//                      )
//                          : new Container(),
//                    ),
//                  ],
//                ),
//              ),
//            )),
//      ),
//    );
//  }
//}