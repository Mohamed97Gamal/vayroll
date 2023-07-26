import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';

import '../widgets.dart';

void showContactsRequestBottomSheet({
  required BuildContext context,
  required Employee? employee,
  required List<EmergencyContact?>? emergencyContacts,
  MyRequestsResponseDTO? profileRequestInfo,
  GlobalKey<RefreshableState>? refreshableKey,
  bool resubmit = false,
}) {
  var _refreshKey = GlobalKey<RefreshableState>();
  var _formKey = GlobalKey<FormState>();

  Employee? _emp = employee;
  String? jsonContacts = emergencyContacts != null ? jsonEncode(emergencyContacts) : null;
  List<EmergencyContact>? _contacts = jsonContacts != null
      ? (jsonDecode(jsonContacts) as List?)
          ?.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
          .toList()
      : List.empty(growable: true);
  List<EmergencyContact> _deletedEmergencyContacts = List.empty(growable: true);
  String? _contactNumber = _emp?.contactNumber;
  String? _email = _emp?.email;
  String? _address = _emp?.address;
  List<Country>? _countries;

  bool _personalInfoChanged() {
    return (_contactNumber != employee!.contactNumber || _email != employee.email || _address != employee.address);
  }

  void _onSubmit({bool resubmit = false}) async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    BaseResponse<String>? personalInfoResponse;
    if (_personalInfoChanged()) {
      var emp = _emp!.copyWith(
        action: RequestAction.update,
        contactNumber: _contactNumber,
        // email: _email,
        address: _address,
        photoBase64: "",
      );

      var empPhoto = (_emp.photo != null)
          ? Attachment(
              id: _emp?.photo?.id,
              name: _emp?.photo?.name,
              extension: _emp?.photo?.extension,
            )
          : null;
      personalInfoResponse = await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => ApiRepo().sendProfileInfoRequest(emp, empPhoto),
      );
      if (!personalInfoResponse!.status!) {
        await showCustomModalBottomSheet(
          context: context,
          desc: personalInfoResponse?.message ?? context.appStrings!.failedToSubmitRequest,
          icon: VPayIcons.blockUser,
        );
        return;
      }
    }

    var finalContacts = List<EmergencyContact>.empty(growable: true);
    for (int i = 0; i < _contacts!.length; i++) {
      if (_contacts[i].action == RequestAction.add || _contacts[i].action == RequestAction.update) {
        _contacts[i].personName = _contacts[i].personName!.trim();
        _contacts[i].address = _contacts[i].address!.trim();
        finalContacts.add(_contacts[i]);
      }
    }
    finalContacts.addAll(_deletedEmergencyContacts);

    if (finalContacts.isEmpty && !_personalInfoChanged()) {
      await showCustomModalBottomSheet(
        context: context,
        desc: context.appStrings!.weCannotProceedWithYourRequestAsYouDidNotChangeAnythingInYourContacts,
        icon: VPayIcons.blockUser,
      );
      return;
    }

    if (finalContacts.isEmpty && personalInfoResponse != null && personalInfoResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc:
            "${context.appStrings!.yourRequestHasBeenSubmittedSuccessfullyWithNumber}: ${personalInfoResponse.message}",
      );
      Navigator.of(context).popUntil((route) => route.isFirst);

      return;
    }

    var response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => resubmit
          ? ApiRepo().resubmitEmergencyContacts(_emp?.id, finalContacts, profileRequestInfo?.requestStateId)
          : ApiRepo().sendEmergencyContactsRequest(_emp!.id, finalContacts),
    ))!;
    if (!response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: (personalInfoResponse != null && personalInfoResponse.status!)
            ? "${context.appStrings!.yourRequestHasBeenSubmittedSuccessfullyWithNumber}: ${personalInfoResponse.message} ${response.errors?.join('\n') ?? response.message ?? context.appStrings!.failedToSubmitRequest}"
            : response.errors?.join('\n') ?? response.message ?? context.appStrings!.failedToSubmitRequest,
        icon: VPayIcons.blockUser,
      );
      Navigator.pop(context);
      if (resubmit) refreshableKey!.currentState!.refresh();
      return;
    }
    await showCustomModalBottomSheet(
      context: context,
      isDismissible: false,
      desc: (personalInfoResponse != null && personalInfoResponse.status!)
          ? resubmit
              ? " ${personalInfoResponse.message}, ${response.message} "
              : "${context.appStrings!.yourRequestHasBeenSubmittedSuccessfullyWithNumber}: ${personalInfoResponse.message}"
          : resubmit
              ? " ${response.message} "
              : "${context.appStrings!.yourRequestHasBeenSubmittedSuccessfullyWithNumber}/'s: ${response.message}",
    );
    if (resubmit) {
      Navigator.pop(context);
      if (resubmit) refreshableKey!.currentState!.refresh();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      if (resubmit) refreshableKey!.currentState!.refresh();
    }
  }

  Future<BaseResponse<List<Country>>> _getCountries() async {
    if (_countries != null)
      return Future.value(
        BaseResponse<List<Country>>(
          status: true,
          result: _countries,
        ),
      );
    var res = await ApiRepo().getCountries();
    if (res.result != null) res.result!.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    _countries = res.result;
    return res;
  }

  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.76),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.appStrings!.requestToUpdateContacts,
                          style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: 32),
                        InnerTextFormField(
                          label: context.appStrings!.contactNumber,
                          keyboardType: TextInputType.phone,
                          initialValue: _contactNumber,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s|-|\.|,|#|\*|N| |;|/|\(|\)"))],
                          onSaved: (value) => _contactNumber = value,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return context.appStrings!.requiredField;
                            if (value!.length < 5 || value!.length > 20) return context.appStrings!.numberValidation;
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        InnerTextFormField(
                          textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel),
                          readOnly: true,
                          label: context.appStrings!.email,
                          inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                          keyboardType: TextInputType.emailAddress,
                          initialValue: _email,
                          // onSaved: (value) => _email = value,
                          //validator: (value) => Validation().checkEmail(value, context),
                        ),
                        const SizedBox(height: 24),
                        InnerTextFormField(
                          label: context.appStrings!.address,
                          initialValue: _address,
                          maxLines: 3,
                          onSaved: (value) => _address = value?.trim() ?? "",
                          validator: (value) {
                            if (value!.trim().isEmpty) return context.appStrings!.requiredField;
                            if (value.trim().length > 200) return context.appStrings!.addressValidation;
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(context.appStrings!.emergencyContacts,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                        const SizedBox(height: 8),
                        _contacts == null || _contacts.isEmpty
                            ? Text(context.appStrings!.noEmergencyContactsData)
                            : Refreshable(
                                key: _refreshKey,
                                child: CustomFutureBuilder<BaseResponse<List<Country>>>(
                                  initFuture: () => _getCountries(),
                                  onSuccess: (context, countriesSnapshot) {
                                    return ListView.builder(
                                      itemCount: _contacts.length,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        return EmergencyContactRequestListTile(
                                          name: _contacts[i].personName,
                                          onNameChanged: (value) {
                                            _contacts[i].personName = value;
                                            if (_contacts[i].action == null) _contacts[i].action = RequestAction.update;
                                          },
                                          // onNameSaved: (value) => setState(() => _contacts[i].personName = value),
                                          number: _contacts[i].phoneNumber,
                                          onNumberChanged: (value) {
                                            _contacts[i].phoneNumber = value;
                                            if (_contacts[i].action == null) _contacts[i].action = RequestAction.update;
                                          },
                                          // onNumberSaved: (value) => setState(() => _contacts[i].phoneNumber = value),
                                          country: _contacts[i].country,
                                          onCountryChanged: (value) {
                                            setState(() => _contacts[i].country = value);
                                            if (_contacts[i].action == null) _contacts[i].action = RequestAction.update;
                                          },
                                          address: _contacts[i].address,
                                          onAddressChanged: (value) {
                                            _contacts[i].address = value;
                                            if (_contacts[i].action == null) _contacts[i].action = RequestAction.update;
                                          },
                                          // onAddressSaved: (value) => setState(() => _contacts[i].address = value),
                                          countries: _countries,
                                          onDelete: () async {
                                            if (_contacts.length == 1) {
                                              await showCustomModalBottomSheet(
                                                context: context,
                                                desc: context.appStrings!.youShouldHaveAtLeastOneEmergencyContact,
                                              );
                                              return;
                                            }
                                            showConfirmationBottomSheet(
                                              context: context,
                                              desc: context.appStrings!.areYouSureYouWantToDeleteThisEmergencyContact,
                                              isDismissible: false,
                                              onConfirm: () {
                                                if ((_contacts[i].id ?? "").isNotEmpty) {
                                                  _contacts[i].action = RequestAction.delete;
                                                  _deletedEmergencyContacts.add(_contacts[i]);
                                                }
                                                _contacts.remove(_contacts[i]);

                                                _refreshKey.currentState!.refresh();

                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(height: 12),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Divider(thickness: 2, height: 2, color: DefaultThemeColors.whiteSmoke1),
                            ),
                            Center(
                              child: FloatingActionButton(
                                elevation: 0,
                                mini: true,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                child: Icon(Icons.add, size: 20, color: Colors.white),
                                onPressed: () =>
                                    setState(() => _contacts!.add(EmergencyContact(action: RequestAction.add))),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: CustomElevatedButton(
                              text: resubmit
                                  ? context.appStrings!.resubmit.toUpperCase()
                                  : context.appStrings!.submit.toUpperCase(),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                _onSubmit(resubmit: resubmit);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
