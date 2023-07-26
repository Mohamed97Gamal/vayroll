import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/employee.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final formKey = GlobalKey<FormState>();
  Employee? _employee;
  String? _feedback;

  void _sendFeedback() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    FocusScope.of(context).unfocus();

    final response = (await showFutureProgressDialog<BaseResponse<EmployeeFeedback>>(
      context: context,
      initFuture: () => ApiRepo().sendFeedback(EmployeeFeedback(employeeId: _employee!.id, feedbackContent: _feedback)),
    ))!;

    if (response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: response.message ?? context.appStrings!.feedbackSubmittedSuccessfully,
      );
      Navigator.of(context).popUntil((route) => route.isFirst == true);
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.message ?? context.appStrings!.feedbackSubmissionFailed,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [_header(context), _form(context)],
      ),
    );
  }

  Widget _header(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: TitleStacked(context.appStrings!.feedback, DefaultThemeColors.prussianBlue),
      );

  Widget _form(BuildContext context) => Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              children: [
                Text(
                  context.appStrings!.weAllNeedPeopleWhoWillGiveUsFeedbackThatIsHowWeImprove,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 25),
                InnerTextFormField(
                  hintText: context.appStrings!.startWritingYourFeedback,
                  maxLines: 5,
                  validator: (value2) {
                    final value = value2!;
                    if (value.trim().isEmpty) return context.appStrings!.requiredField;
                    if (value.trim().length > 500) return context.appStrings!.feedbackValidation;
                    return null;
                  },
                  onSaved: (value) => _feedback = value?.trim() ?? "",
                ),
                const SizedBox(height: 30),
                CustomElevatedButton(
                  text: context.appStrings!.submit,
                  onPressed: _sendFeedback,
                ),
              ],
            ),
          ),
        ),
      );
}
