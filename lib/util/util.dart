

///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
/// 此方法中前三位格式有：
/// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
 bool isChinaPhoneLegal(String phone) {
return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(phone);
}

/// 检测邮箱地址是否合法
/// 正则表达式来自 https://www.cnblogs.com/chengdabelief/p/6683237.html
bool isEmailValid(String email){
  return new RegExp('^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+\$').hasMatch(email);
}