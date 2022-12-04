import 'package:carsfilter/data.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _sk = GlobalKey<ScaffoldState>();

  final allChecked = CheckBoxModel(title: 'Todas as categorias');
  final checkBoxList = [
    CheckBoxModel(title: 'SUV'),
    CheckBoxModel(title: 'Compacto'),
    CheckBoxModel(title: 'Sedã'),
  ];

  late List<Car> filterCars;

  String query = '';

  @override
  void initState() {
    filterCars = cars;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _sk,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _sk.currentState!.openEndDrawer(),
          child: const Icon(Icons.filter_alt_rounded),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pesquise por ID ou nome do veículo',
                  ),
                  onChanged: searchCar,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filterCars.length,
                  itemBuilder: (context, index) {
                    var item = filterCars[index];

                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.type),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        endDrawer: _drawer(),
      ),
    );
  }

  Widget _drawer() {
    final size = MediaQuery.of(context).size;

    return Drawer(
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 90,
                child: DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filtro'),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //checa todas as opções
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(allChecked.title),
                value: allChecked.value,
                onChanged: (value) => _onAllChecked(),
              ),
              const Divider(),
              //checa as opções individualmente
              ...checkBoxList.map(buildCheckBoxItems).toList(),
            ],
          ),
          SizedBox(
            height: size.height > 440 ? size.height * 0.1 : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _clearFilter,
                  child: const Text('Clear filter'),
                ),
                ElevatedButton(
                  onPressed: _applyFilter,
                  child: const Text('Apply filter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckBoxItems(CheckBoxModel item) => CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(item.title),
        value: item.value,
        onChanged: (value) => _onItemChecked(item),
      );

  void searchCar(String query) {
    final filterList = cars.where((item) {
      final id = item.id.toString();
      final name = item.name.toLowerCase();
      final queryLower = query.toLowerCase();

      return id.contains(queryLower) || name.contains(queryLower);
    }).toList();

    setState(() {
      this.query = query;
      filterCars = filterList;
    });
  }

  void _onAllChecked() {
    final newValue = !allChecked.value;

    setState(() {
      allChecked.value = newValue;

      for (var element in checkBoxList) {
        element.value = newValue;
      }
    });
  }

  void _onItemChecked(CheckBoxModel item) {
    final newValue = !item.value;

    final filterList = cars.where((element) {
      final category = element.type.toLowerCase();

      if (newValue) {
        return category.contains(item.title.toLowerCase());
      }

      return true;
    }).toList();

    setState(() {
      item.value = newValue;
      filterCars = filterList;

      if (!newValue) {
        allChecked.value = false;
      } else {
        final allChecked = checkBoxList.every((element) => element.value);
        this.allChecked.value = allChecked;
      }
    });
  }

  void _clearFilter() {
    setState(() {
      allChecked.value = false;
      for (var element in checkBoxList) {
        element.value = false;
      }
    });

    Navigator.pop(context);
  }

  void _applyFilter() => Navigator.pop(context);
}

class CheckBoxModel {
  String title;
  bool value;

  CheckBoxModel({required this.title, this.value = false});
}
