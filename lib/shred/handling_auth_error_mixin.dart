import 'package:espitalia/providers/loading_and_response_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'alerts_class.dart';



abstract class HandlingAuthErrors with Alerts{
  bool isLoadingShow = false;

  handleException(BuildContext context) async {
    var watch = context.watch<LoadingAndErrorProvider>();

    print(watch.error);

    switch (watch.state) {
      case LoadingErrorState.ERROR:
        if(isLoadingShow) {
          print('this loading dialog is shown');

          Navigator.pop(context);
          isLoadingShow = false;
        }
        if (watch.error != null) {
          await Future.delayed(Duration.zero, () async {
            this.errorDialog(context, title: 'Error', content: watch.error!);
          });
          watch.setErrorWithoutNotify(null, LoadingErrorState.NONE);
        }

        break;
      case LoadingErrorState.NONE:
        print('is the null');
        if(isLoadingShow) {
          Navigator.pop(context);
          print('poped');
          isLoadingShow = false;
        }
        break;
      case LoadingErrorState.LOADING:
        if(!isLoadingShow) {
          Future.delayed(Duration.zero, () async {
            isLoadingShow = true;
            await loadingDialog(context);
            isLoadingShow = false;

          });
        }
        break;

      case LoadingErrorState.DONE:
        print('Done');
        context.read<LoadingAndErrorProvider>()..setErrorWithoutNotify(null, LoadingErrorState.NONE);

        break;

      default:
    }
  }


}