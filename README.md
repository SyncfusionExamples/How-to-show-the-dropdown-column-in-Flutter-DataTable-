# How-to-show-the-dropdown-column-in-Flutter-DataTable-

The Syncfusion [Flutter DataGrid](https://www.syncfusion.com/flutter-widgets/flutter-datagrid) supports loading any widget in the cells. In this article, you can learn how to load the [DropdownButton](https://api.flutter.dev/flutter/material/DropdownButton-class.html) widget for a specific column and update the cell value by selecting the value from the drop-down.

## STEP 1: 
Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the required properties. 

```dart
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

```
## STEP 2: 
Create a data source class by extending [DataGridSource](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource-class.html) for mapping data to the SfDataGrid. In the [buildRow](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/buildRow.html) method, you can load the DropdownButton widget based on the condition. In the onChanged event of the DropdownButton, update the cell value by calling the [DataGridSource.notifyListeners](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSourceChangeNotifier/notifyListeners.html) method.

```dart
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

```
Note:

If you want to load the DropdownButton only on the editing, you can load it from the buildEditWidget method. Please refer to [this](https://help.syncfusion.com/flutter/datagrid/editing) UG documentation, to learn more about the editing feature in DataGrid.
