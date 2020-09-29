import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

class BaseModel extends Model {
  ViewStatus _status;

  ViewStatus get status => _status;

  void setState(ViewStatus newState) {
    _status = newState;

    notifyListeners();
  }
}
