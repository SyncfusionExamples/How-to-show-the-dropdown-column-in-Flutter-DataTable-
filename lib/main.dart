import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MaterialApp(home: SfDataGridDemo()));
}

class SfDataGridDemo extends StatefulWidget {
  const SfDataGridDemo({Key? key}) : super(key: key);

  @override
  SfDataGridDemoState createState() => SfDataGridDemoState();
}

class SfDataGridDemoState extends State<SfDataGridDemo> {
  List<Employee> _employees = <Employee>[];
  late EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    super.initState();
    _employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid')),
      body: SfDataGrid(
        source: _employeeDataSource,
        columnWidthMode: ColumnWidthMode.auto,
        columns: <GridColumn>[
          GridColumn(
              columnName: 'id',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text('ID'))),
          GridColumn(
              columnName: 'name',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text('Name'))),
          GridColumn(
              columnName: 'designation',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text('Designation'))),
          GridColumn(
              columnName: 'salary',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: const Text('Salary'))),
        ],
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(this.employees) {
    dataGridRows = employees
        .map<DataGridRow>((Employee e) => DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  List<Employee> employees = [];

  List<DataGridRow> dataGridRows = [];

  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black87);

  @override
  List<DataGridRow> get rows => dataGridRows;

  List<String> dropDownMenuItems = [
    'Manager',
    'Project Lead',
    'Developer',
    'Support',
    'QA Testing',
    'UI Designer',
    'Sales Representative',
    'Sales Associate',
    'Administrator',
  ];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: dataGridCell.columnName == 'designation'
              ? DropdownButton<String>(
                  value: dataGridCell.value,
                  autofocus: true,
                  focusColor: Colors.transparent,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  isExpanded: true,
                  style: textStyle,
                  onChanged: (String? value) {
                    final dynamic oldValue = row
                            .getCells()
                            .firstWhereOrNull((DataGridCell dataCell) =>
                                dataCell.columnName == dataGridCell.columnName)
                            ?.value ??
                        '';
                    if (oldValue == value || value == null) {
                      return;
                    }

                    final int dataRowIndex = dataGridRows.indexOf(row);
                    dataGridRows[dataRowIndex].getCells()[2] =
                        DataGridCell<String>(
                            columnName: 'designation', value: value);
                    employees[dataRowIndex].designation = value.toString();
                    notifyListeners();
                  },
                  items: dropDownMenuItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList())
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
    }).toList());
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  int? id;
  String? name;
  String? designation;
  int? salary;
}

List<Employee> getEmployeeData() {
  return [
    Employee(10001, 'Jack', 'Manager', 90000),
    Employee(10002, 'Perry', 'Project Lead', 77000),
    Employee(10003, 'Stark', 'Developer', 43500),
    Employee(10004, 'Edwards', 'Developer', 40000),
    Employee(10005, 'Martin', 'QA Testing', 37000),
    Employee(10006, 'Ellis', 'UI Designer', 35000),
    Employee(10007, 'Lara', 'Support', 34000),
    Employee(10008, 'Jefferson', 'Administrator', 33000),
    Employee(10009, 'Williams', 'Sales Representative', 32000),
    Employee(10010, 'Crowley', 'Sales Associate', 32000)
  ];
}
