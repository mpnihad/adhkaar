
final String tableSection = 'tbl_section';
final String columnId = 'sec_id';
final String columnName = 'sec_name';
final String columnTag = 'eng_tags';
final String columnParentId = 'parent_id';
final String columnSecColor = 'sec_color';
final String columnSecImage = 'sec_image';

class Section {
  int id;
  String name;
  String tag;
  int parentId;
  int color;
  String image;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnTag: tag,
      columnParentId: parentId,
      columnSecColor: color.toString(),
      columnSecImage: image
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Section();

  Section.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    tag = map[columnTag];
    parentId = map[columnParentId];
    color = int.parse(map[columnSecColor]==null?"0xFF567DF4":map[columnSecColor]);
    image = map[columnSecImage];

  }
}