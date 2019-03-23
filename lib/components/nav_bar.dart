import 'package:flutter/material.dart';
import 'package:eco_connect/model/data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:eco_connect/model/designtemplate.dart';

class NavBarComponet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DesignTemplate _template = DesignTemplate(context);
    DataModel _model = new DataModel(context);
    return ScopedModel<DataModel>(
        model: _model,
        child: Drawer(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: ScopedModelDescendant<DataModel>(
                  builder: (context, child, model) {
                    return model.userProfile != null
                        ? Text(
                            '${model.userProfile.lastName} ${model.userProfile.firstName}')
                        : Text('');
                  },
                ),
                accountEmail: ScopedModelDescendant<DataModel>(
                    builder: (context, child, model) {
                  return Text(
                      model.userProfile != null ? model.userProfile.email : "");
                }),
                currentAccountPicture: ScopedModelDescendant<DataModel>(
                    builder: (context, child, model) {
                  return _template.getAvatar(model.userProfile);
                }),
              )
            ],
          ),
          elevation: 1,
        ));
  }
}
