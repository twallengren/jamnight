import 'package:jamnight/performermanager/performermanagermodel.dart';

import '../model/performer/performer.dart';

class PerformerManagerService {
  final PerformerManagerModel _performerManagerModel;

  PerformerManagerService(this._performerManagerModel);

  void selectSavedPerformer(Performer performer) {
    _performerManagerModel.selectSavedPerformer(performer);
  }
}
