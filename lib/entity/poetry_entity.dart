class PoetryEntity {
	PoetryData data;
	String status;

	PoetryEntity({this.data, this.status});

	PoetryEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new PoetryData.fromJson(json['data']) : null;
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['status'] = this.status;
		return data;
	}
}

class PoetryData {
	String content;

	PoetryData({this.content});

	PoetryData.fromJson(Map<String, dynamic> json) {
		content = json['content'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['content'] = this.content;
		return data;
	}
}
