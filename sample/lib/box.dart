import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Box extends StatefulWidget {
  const Box({super.key});

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  //variables

  final TextEditingController origin = TextEditingController();
  List<String> suggestions = [];
  bool origincheck = false;
  bool destinationcheck = false;
  String? commodity;
  String? dimensions;
  String? datestring = "Cutt Off Date";
  var datecontroller = TextEditingController();
  String? shipping = 'opt1';

  List<Map<String, String>> measures = [
    {
      'name': '20` Standard',
      'length': '19.35 ft',
      'width': '7.71 ft',
      'height': '7.87 ft'
    },
    {
      'name': '40` Standard',
      'length': '39.46 ft',
      'width': '7.70 ft',
      'height': '7.84 ft'
    },
    {
      'name': '40` High Cube',
      'length': '39.46 ft',
      'width': '7.70 ft',
      'height': '8.86 ft'
    },
    {
      'name': '45` High Cube',
      'length': '44.60 ft',
      'width': '7.70 ft',
      'height': '8.86 ft'
    },
  ];

  String length = '39.46 ft';
  String width = '7.70 ft';
  String height = '7.84 ft';

  void date() {
    showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
            initialDate: DateTime.now())
        .then((value) {
      setState(() {
        datestring = value.toString();
      });
    });
  }

  Future<void> fetchSuggestions(String query) async {
    final url =
        Uri.parse("http://universities.hipolabs.com/search?name=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        suggestions = data
            .where((user) =>
                user['name'].toLowerCase().contains(query.toLowerCase()))
            .map<String>((user) => user['name'] + ", " + user['country'])
            .toList();
      });
    } else {
      setState(() {
        suggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //first row

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return suggestions.where((option) => option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (value) {
                            print("Selected: $value");
                          },
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: TextField(
                                onChanged: (text) {
                                  fetchSuggestions(text);
                                },
                                focusNode: focusNode,
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                  labelText: "Origin",
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return suggestions.where((option) => option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (value) {
                            print("Selected: $value");
                          },
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: TextField(
                                onChanged: (text) {
                                  fetchSuggestions(text);
                                },
                                focusNode: focusNode,
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                  labelText: "Destination",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //Second row

                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: origincheck,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  origincheck = newValue!;
                                });
                              },
                            ),
                            Text("Include nearby origin ports"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: destinationcheck,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  destinationcheck = newValue!;
                                });
                              },
                            ),
                            Text("Include nearby destination ports"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //third row

                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 0, 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: "Commodity",
                                border: OutlineInputBorder()),
                            value: commodity,
                            items: [
                              'Electronics',
                              'Machinery',
                              'Furniture',
                              'Clothing',
                              'Chemicals',
                              'Automotive Parts',
                              'Raw Materials',
                              'Pharmaceuticals',
                              'Others'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (String? newval) {
                              setState(() {
                                commodity = newval!;
                              });
                            }),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TextField(
                          controller: datecontroller,
                          onTap: date,
                          decoration: InputDecoration(
                            labelText: "Cut Off Date",
                            hintText: datestring ?? "cut Off Dtae",
                            suffixIcon: Icon(Icons.calendar_month),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),

                //fourt row

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Shipment Type:",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 0, 10),
                  child: Row(
                    children: [
                      Radio<String>(
                          value: 'opt1',
                          groupValue: shipping,
                          onChanged: (String? value) {
                            setState(() {
                              shipping = value;
                            });
                          }),
                      Text("FCL"),
                      Radio<String>(
                          value: 'opt2',
                          groupValue: shipping,
                          onChanged: (String? value) {
                            setState(() {
                              shipping = value;
                            });
                          }),
                      Text("LCL"),
                    ],
                  ),
                ),

                //fifth row

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: "Container Size",
                                border: OutlineInputBorder()),
                            hint: Text("40` Standard"),
                            value: dimensions,
                            items: measures.map((value) {
                              return DropdownMenuItem<String>(
                                  value: value['name'],
                                  child: Text(value['name']!));
                            }).toList(),
                            onChanged: (String? newval) {
                              setState(() {
                                final selectedmeasure = measures.firstWhere(
                                    (measure) => measure['name'] == newval);
                                length = selectedmeasure['length']!;
                                width = selectedmeasure['width']!;
                                height = selectedmeasure['height']!;
                                dimensions = newval!;
                              });
                            }),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "No Of Boxes",
                              border: OutlineInputBorder()),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Weight (kg)",
                              border: OutlineInputBorder()),
                        ),
                      )),
                    ],
                  ),
                ),

                //sixth row
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 17,
                      ),
                      Text(
                          " To obtain accurate rate for spot with guarantee space and booking, please ensure your container count and weight per container is accurate."),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Container Internal Dimensions :',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Align(
                      // alignment: Alignment(0,-1),
                      child: Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(' Length '),
                              Text(
                                length,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Width '),
                              Text(
                                width,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(' Height '),
                              Text(
                                height,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                        width: 50,
                      ),
                      Container(
                        height: 80,
                        child: Image.asset('containerimg.png'),
                      )
                    ],
                  )),
                ),

                Align(
                  alignment: Alignment(1, 1),
                  child: Container(
                    height: 40,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(230, 234, 248, 1),
                        iconColor: Colors.indigo,
                        foregroundColor: Colors.indigo,
                        side: BorderSide(color: Colors.indigo, width: 1),
                      ),
                      onPressed: () {},
                      label: Text(
                        "Search",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      icon: Icon(Icons.search),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
