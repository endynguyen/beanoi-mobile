import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Enums/index.dart';

class BaseModel extends Model {
  ViewStatus _status = ViewStatus.Completed;
  String _msg;
  ViewStatus get status => _status;
  String get msg => _msg;

  void setState(ViewStatus newState, [String msg]) {
    _status = newState;
    _msg = msg;
    notifyListeners();
  }
}
