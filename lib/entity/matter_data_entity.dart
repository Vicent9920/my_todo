class MatterData {
	int date;
	String dateStr;
	int id;
	int priority;
	String title;
	int type;
	int userId;
	String completeDateStr;
	String content;
	dynamic completeDate;
	int status;

	MatterData({this.date, this.dateStr, this.id, this.priority, this.title, this.type, this.userId, this.completeDateStr, this.content, this.completeDate, this.status});

	MatterData.fromJson(Map<String, dynamic> json) {
		date = json['date'];
		dateStr = json['dateStr'];
		id = json['id'];
		priority = json['priority'];
		title = json['title'];
		type = json['type'];
		userId = json['userId'];
		completeDateStr = json['completeDateStr'];
		content = json['content'];
		completeDate = json['completeDate'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = this.date;
		data['dateStr'] = this.dateStr;
		data['id'] = this.id;
		data['priority'] = this.priority;
		data['title'] = this.title;
		data['type'] = this.type;
		data['userId'] = this.userId;
		data['completeDateStr'] = this.completeDateStr;
		data['content'] = this.content;
		data['completeDate'] = this.completeDate;
		data['status'] = this.status;
		return data;
	}
}
