import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../uicomponents.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String dropdownValue = "Panjab";
  var items = [
    "Panjab",
    "Mumbai",
    "Odisha",
    "Chhatisgarh",
    "Gujrat",
    "Karnatka"
  ];

  String state = "", city = " ", descprition = " ", cityPic = "";
  TextEditingController stateCount = TextEditingController();
  TextEditingController cityCount = TextEditingController();
  TextEditingController desCount = TextEditingController();

  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      state = prefs.getString("state") ?? "";
      city = prefs.getString("city") ?? "";
      descprition = prefs.getString("desc") ?? "";
    });
    stateCount = TextEditingController(text: state);
    cityCount = TextEditingController(text: city);
    desCount = TextEditingController(text: descprition);
  }

  File? _image;
  final imagePick = ImagePicker();
  String? downloadURL;

  setProfilePic() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    "Choose existing photo",
                    style: TextStyle(fontSize: 16),
                  ),
                  minVerticalPadding: 0,
                  dense: true,
                  onTap: () {
                    Navigator.pop(context);
                    imagePickerGallery();
                  },
                ),
                ListTile(
                  title:
                      const Text("Take photo", style: TextStyle(fontSize: 16)),
                  minVerticalPadding: 0,
                  dense: true,
                  onTap: () {
                    Navigator.pop(context);
                    imagePickerCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future imagePickerGallery() async {
    final pick = await imagePick.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        print("VINOD: " + pick.path);
      } else {
        UIComponents.showSnackBar(
            context, "No file selected", const Duration(seconds: 2));
      }
    });
  }

  Future imagePickerCamera() async {
    final pick = await imagePick.pickImage(source: ImageSource.camera);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        print("VINOD: " + pick.path);
      } else {
        UIComponents.showSnackBar(
            context, "No file selected", const Duration(seconds: 2));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => setProfilePic(),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.shade100,
                  ),
                  child: ClipOval(
                    child: _image == null
                        ? cityPic == ""
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: cityPic,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Container(),
                                ),
                              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_image!, fit: BoxFit.cover)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "State",
                      border: InputBorder.none,
                    ),
                    value: dropdownValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        dropdownValue = newVal!;
                      });
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // controller: nameCont,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Add City"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: TextFormField(
                      // controller: nameCont,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add Description"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  UIComponents.showSnackBar(context,
                      "City added successfully!!", Duration(seconds: 3));
                  Navigator.pop(context);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.indigo,
                  ),
                  child: Center(
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
