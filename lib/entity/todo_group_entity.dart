import 'package:my_todo/entity/matter_data_entity.dart';

class TodoGroupEntity {
	bool over;
	int pageCount;
	int total;
	int curPage;
	int offset;
	int size;
	List<MatterData> datas;

	TodoGroupEntity({this.over, this.pageCount, this.total, this.curPage, this.offset, this.size, this.datas});

	TodoGroupEntity.fromJson(Map<String, dynamic> json) {
		over = json['over'];
		pageCount = json['pageCount'];
		total = json['total'];
		curPage = json['curPage'];
		offset = json['offset'];
		size = json['size'];
		if (json['datas'] != null) {
			datas = new List<MatterData>();(json['datas'] as List).forEach((v) { datas.add(new MatterData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['over'] = this.over;
		data['pageCount'] = this.pageCount;
		data['total'] = this.total;
		data['curPage'] = this.curPage;
		data['offset'] = this.offset;
		data['size'] = this.size;
		if (this.datas != null) {
      data['datas'] =  this.datas.map((v) => v.toJson()).toList();
    }
		return data;
	}
}


