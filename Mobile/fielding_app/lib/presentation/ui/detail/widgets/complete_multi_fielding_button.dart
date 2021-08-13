import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CompleteMultiPoleButton extends StatelessWidget {
  final String? token;
  final String? layerId;

  const CompleteMultiPoleButton({Key? key, this.token, this.layerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: () {
          context.read<FieldingBloc>().add(CompleteMultiPole(token!, layerId!,
              context.read<FieldingProvider>().allPolesByLayer));
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: ColorHelpers.colorGreen2,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "Complete Fielding Request",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ));
  }
}
