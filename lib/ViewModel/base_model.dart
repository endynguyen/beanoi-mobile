import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Enums/index.dart';

class BaseModel extends Model {
  ViewStatus _status = ViewStatus.Completed;
  ViewStatus get status => _status;

  void setState(ViewStatus newState) {
    _status = newState;

    notifyListeners();
  }
}
