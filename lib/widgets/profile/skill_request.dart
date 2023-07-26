import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

void showSkillRequestBottomSheet({
  required BuildContext context,
  Employee? employee,
  SkillsResponseDTO? skillInfo,
  MyRequestsResponseDTO? profileRequestInfo,
  GlobalKey<RefreshableState>? refreshableKey,
  bool resubmit = false,
}) {
  String? _skillName;
  String? _proficiency;
  bool _profFlag = false;
  SkillsResponseDTO skill = SkillsResponseDTO();
  final formKey = GlobalKey<FormState>();

  Future _addOrUpdateSkill(StateSetter setState,
      {bool update = false, bool resubmit = false}) async {
    if (_proficiency == null) {
      setState(() {
        _profFlag = true;
      });
    } else {
      setState(() {
        _profFlag = false;
      });
    }

    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_proficiency == null) return;

      skill.action = resubmit
          ? skillInfo?.action
          : (update ? RequestAction.update : RequestAction.add);
      skill.id = update ? skillInfo!.id : null;
      skill.skillName = _skillName;
      skill.proficiency = _proficiency;

      final addOrUpdateSkillResponse =
          (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => resubmit
            ? ApiRepo().resubmitSkills(
                employee!.id, skill, profileRequestInfo?.requestStateId)
            : ApiRepo().addUpdateDeleteSkill(employee!.id, skill),
      ))!;
      Navigator.pop(context);
      if (addOrUpdateSkillResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          isDismissible: false,
          desc: addOrUpdateSkillResponse?.message ?? " ",
        );
        if (resubmit) refreshableKey!.currentState!.refresh();
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: addOrUpdateSkillResponse.errors != null
              ? addOrUpdateSkillResponse.message! +
                  " " +
              (addOrUpdateSkillResponse.errors?.join('\n') ?? "")
              : addOrUpdateSkillResponse.message,
        );
        if (resubmit) refreshableKey!.currentState!.refresh();

        return;
      }
    }
  }

  Widget _proficiencyDropdown(StateSetter setState) =>
      CustomFutureBuilder<BaseResponse<List<dynamic>>>(
        initFuture: () => ApiRepo().getSkillProficiencies(),
        onSuccess: (context, snapshot) {
          var proficiencies = snapshot.data!.result;
          _proficiency = _proficiency ??
              (skillInfo?.proficiency?.isNotEmpty == true
                  ? skillInfo?.proficiency
                  : null);
          return InnerDropdownFormField<String>(
            value: _proficiency,
            items: proficiencies != null
                ? proficiencies
                    .map((proficiency) => DropdownMenuItem<String>(
                        value: proficiency, child: Text(proficiency)))
                    .toList()
                : null,
            onChanged: (proficiency) =>
                setState(() => _proficiency = proficiency),
          );
        },
      );

  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.76),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillInfo?.skillName?.isNotEmpty == true
                        ? context.appStrings!.editSkills
                        : context.appStrings!.addSkills,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 24),
                  Text(context.appStrings!.skillName,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: DefaultThemeColors.nepal)),
                  const SizedBox(height: 8),
                  InnerTextFormField(
                    hintText: context.appStrings!.typeHere,
                    readOnly: skillInfo?.skillName?.isNotEmpty == true,
                    textStyle: skillInfo?.skillName?.isNotEmpty == true
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: DefaultThemeColors.nobel)
                        : Theme.of(context).textTheme.bodyText2,
                    initialValue: skillInfo?.skillName?.isNotEmpty == true
                        ? skillInfo?.skillName
                        : null,
                    validator: (value) => value?.isEmpty ?? true
                        ? context.appStrings!.requiredField
                        : value!.trim().length > 100
                            ? context.appStrings!.skillValidation
                            : null,
                    onSaved: (String? value) => _skillName = value?.trim() ?? "",
                  ),
                  const SizedBox(height: 24),
                  Text(context.appStrings!.proficiency,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: DefaultThemeColors.nepal)),
                  const SizedBox(height: 8),
                  _proficiencyDropdown(setState),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: _profFlag,
                    child: Text(
                      context.appStrings!.pleaseSelectYourSkillProficiency,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(height: 1.20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: CustomElevatedButton(
                        text: resubmit
                            ? context.appStrings!.resubmit.toUpperCase()
                            : context.appStrings!.submit.toUpperCase(),
                        onPressed: () async => await _addOrUpdateSkill(
                          setState,
                          update: skillInfo?.skillName?.isNotEmpty == true
                              ? true
                              : false,
                          resubmit: resubmit,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
