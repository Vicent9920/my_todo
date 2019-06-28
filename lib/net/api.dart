///接口地址
class Api {
  //Base
  static String baseUrl = 'https://www.wanandroid.com/';


  //登录
  static String login = 'user/login';

  //注册
  static String register = 'user/register';

  //登出
  static String logout = 'user/logout/json';


  //TODO列表
  static String todoList = 'lg/todo/v2/list/1/json?status=0';

  //更新TODO状态
  static String updateTodoStatus = 'lg/todo/done/';

  //新增TODO
  static String addTodo = 'lg/todo/add/json';

  //删除TODO
  static String deleteTodo = 'lg/todo/delete/';

  //更新TODO
  static String updateTodo = 'lg/todo/update/';
}
