class DropDownListItem {
  int id;
  String name;
 
  DropDownListItem(this.id, this.name);
 
  static List<DropDownListItem> getTaskTypes() {
    return <DropDownListItem>[
      DropDownListItem(1, 'Physician'),
      DropDownListItem(2, 'Pharmacy'),
      DropDownListItem(3, 'Hospital'),
      DropDownListItem(4, 'Coaching'),
      DropDownListItem(5, 'Other Task'),
      DropDownListItem(6, 'Vacation'),

    ];
  }
}