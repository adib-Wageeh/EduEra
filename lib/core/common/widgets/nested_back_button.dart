import 'package:education_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class NestedBackButton extends StatefulWidget {
  const NestedBackButton({super.key});

  @override
  State<NestedBackButton> createState() => _NestedBackButtonState();
}

class _NestedBackButtonState extends State<NestedBackButton> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: ()async{
      try{
        context.popTab();
        return false;
      }catch(_){
        return true;
      }
    }
    ,child: IconButton(onPressed: (){
        try{
          context.popTab();
        }catch(_){
          Navigator.pop(context);
        }
      }
          , icon: (
          Theme.of(context).platform == TargetPlatform.android ?
              const Icon(Icons.arrow_back):
              const Icon(Icons.arrow_back_ios_new)
          ),
      ),
    );
  }
}
