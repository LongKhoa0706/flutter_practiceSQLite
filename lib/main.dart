import 'package:flutter/material.dart';
import 'package:flutter_app1/database.dart';
import 'package:flutter_app1/model/person.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showPassword = true;
  DbManager _dbManager = DbManager();
  Person person;
  List<Person> arrPerson;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person"),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: _dbManager.getPersonList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                arrPerson = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: arrPerson.length,
                  itemBuilder: (_, index) {
                    Person personn = arrPerson[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      elevation: 2.0,
                      child: ListTile(
                        onTap: (){

                        },
                        leading: Icon(
                          Icons.account_circle,
                          size: 30,
                          color: Colors.blue,
                        ),
                        title: Text(personn.name),
                        subtitle: Text(personn.password),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),

                      ),
                    );
                  },
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          createDialog(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<String> createDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,//similar cancelOnTouch in Android
      //Use StatefulBuilder to use setState inside Dialog and update Widgets only inside of it
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Center(child: Text("Add Person")),
            elevation: 2.0,
            titlePadding: EdgeInsets.only(top: 10),
            contentPadding:
                EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      width: double.infinity,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                        ),
                        validator: (val) =>
                            val.isNotEmpty ? null : "Name should not be empty",
                        controller: _nameController,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      width: double.infinity,
                      child: TextFormField(
                        controller: _passController,
                        obscureText: showPassword,
                        validator: (val) => val.isNotEmpty
                            ? null
                            : "Password should not be empty ",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: showPassword
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text("Clear",style: TextStyle(color: Colors.blue),),
                            onPressed: () {
                              setState(() {
                                _nameController.clear();
                                _passController.clear();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text("Add",style: TextStyle(color: Colors.white),),
                              onPressed: _addPerson),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _addPerson() {
    if (formKey.currentState.validate()) {
      if (person == null) {
        Person personn =
            Person(name: _nameController.text, password: _passController.text);
        setState(() {
          _dbManager.insertPerson(personn);
          _nameController.clear();
          _passController.clear();
          Navigator.of(context).pop();
        });
      }
    }
  }
}
