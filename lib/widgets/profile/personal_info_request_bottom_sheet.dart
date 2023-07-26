  import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/widgets.dart';

void showPersonalInfoRequestBottomSheet({
  required BuildContext context,
  required Employee? employee,
  MyRequestsResponseDTO? profileRequestInfo,
  GlobalKey<RefreshableState>? refreshableKey,
  bool resubmit = false,
}) {
  final _formKey = GlobalKey<FormState>();
  Employee? _employee = employee;
  Gender? _selectedGender = _employee?.gender == null
      ? null
      : Gender.values.firstWhere((gender) => gender.name == _employee?.gender);
  DateTime? _selectedBirthdate = _employee?.birthDate;
  Department? _selectedDepartment = _employee?.department;
  BaseModel? _selectedPosition = _employee?.position;
  // Currency _selectedCurrency = _employee?.currency;
  Employee? _selectedManager = _employee?.manager;
  String? _selectedReligion = _employee?.religion;
  var _selectedPhoto = (_employee?.photo != null)
      ? Attachment(
          id: _employee?.photo?.id,
          name: _employee?.photo?.name,
          extension: _employee?.photo?.extension,
          content: _employee?.photoBase64,
        )
      : null;

  bool _isSameInfo() {
    return resubmit
        ? false
        : (_employee?.photo?.id == _selectedPhoto?.id &&
            _employee?.photo?.name == _selectedPhoto?.name &&
            _selectedGender.name == _employee!.gender &&
            _selectedBirthdate == _employee.birthDate &&
            _selectedDepartment == _employee.department &&
            _selectedPosition == _employee.position &&
            _selectedManager == _employee.manager &&
            _selectedReligion == _employee.religion);
  }

  void _onSubmit({bool resubmit = false}) async {
    if (!_formKey.currentState!.validate()) return;

    if (_isSameInfo()) {
      await showCustomModalBottomSheet(
        context: context,
        desc: context.appStrings!
            .weCannotProceedWithYourRequestAsYouDidNotChangeAnythingInYourProfile,
        icon: VPayIcons.blockUser,
      );
      return;
    }

    if (resubmit) {
      var response = (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () async => await ApiRepo().getFile(employee?.photo?.id),
      ))!;
      if (response.status!) {
        _selectedPhoto?.content = response?.result;
      }
    }

    var emp = _employee!.copyWith(
      action: resubmit
          ? (employee?.action ?? RequestAction.update)
          : RequestAction.update,
      gender: _selectedGender.name,
      birthDate: _selectedBirthdate,
      department: _selectedDepartment,
      position: _selectedPosition,
      // currency: _selectedCurrency,
      manager: _selectedManager,
      religion: _selectedReligion,
      photo: resubmit ? employee?.photo : null,
      photoBase64: "",
    );

    //if (_selectedPhoto?.id != null) _selectedPhoto?.content = null;

    var response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => resubmit
          ? ApiRepo().resubmitProfileInfo(
              employee?.parent?.id,
              emp,
              profileRequestInfo?.requestStateId,
              attachment: (_selectedPhoto != null)
                  ? Attachment(
                      id: _selectedPhoto?.id,
                      name: _selectedPhoto?.name,
                      extension: _selectedPhoto?.extension,
                      content: _selectedPhoto?.content,
                    )
                  : null,
            )
          : ApiRepo().sendProfileInfoRequest(
              emp,
              (_selectedPhoto != null)
                  ? Attachment(
                      content: _selectedPhoto?.content,
                      extension: _selectedPhoto?.extension,
                      id: _selectedPhoto?.id,
                      name: _selectedPhoto?.name,
                    )
                  : null,
            ),
    ))!;

    if (!response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.errors != null
            ? response.message! + " " + (response.errors?.join('\n') ?? "")
            : response.message ?? context.appStrings!.failedToSubmitRequest,
        icon: VPayIcons.blockUser,
      );
      if (resubmit) refreshableKey!.currentState!.refresh();

      return;
    }

    if (context.read<HomeTabIndexProvider>().hideBarItems!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: resubmit
            ? "${response.message} "
            : "${context.appStrings!.yourRequestHasBeenSubmittedSuccessfullyWithNumber}: ${response.message}",
        isDismissible: false,
      );
      if (resubmit) {
        Navigator.pop(context);
        if (resubmit) refreshableKey!.currentState!.refresh();
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.read<HomeTabIndexProvider>().hideBarItems = false;
        context.read<HomeTabIndexProvider>().index = 2;
      }
    } else {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: resubmit
            ? "${response.message}"
            : "${context.appStrings!.yourRequestHasBeenSubmittedSuccessfullyWithNumber}: ${response.message}",
      );
      if (resubmit) {
        Navigator.pop(context);
        if (resubmit) refreshableKey!.currentState!.refresh();
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
        if (resubmit) refreshableKey!.currentState!.refresh();
      }
    }
  }

  Widget _profilePhoto(StateSetter setState) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          GestureDetector(
            onTap: () async {
              var pickedFile = await pickFile(
                context,
                fileType: FileType.image,
              );
              if (pickedFile == null) {
                return;
              }

              setState(() => _selectedPhoto = pickedFile);
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 52,
              child: ClipOval(
                child: _selectedPhoto?.content != null
                    ? Image.memory(
                        base64Decode(_selectedPhoto!.content!),
                        fit: BoxFit.cover,
                        width: 104.0,
                        height: 104.0,
                      )
                    : Image.asset(
                        VPayImages.avatar,
                        fit: BoxFit.cover,
                        width: 104.0,
                        height: 104.0,
                      ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
            margin: EdgeInsets.all(4),
            width: 28,
            height: 28,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                if (_selectedPhoto != null)
                  showConfirmationBottomSheet(
                    context: context,
                    desc: context.appStrings!.areYouSureYouWantToDeleteYourPhoto,
                    isDismissible: false,
                    onConfirm: () {
                      setState(() => _selectedPhoto = null);
                      Navigator.of(context).pop(true);
                    },
                  );
              },
              child: Icon(
                Icons.delete_forever,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

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
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appStrings!.requestToUpdatePersonalInformation,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 16),
                  if (resubmit &&
                      (_selectedPhoto?.content == null &&
                          _selectedPhoto?.id != null)) ...[
                    AvatarFutureBuilder<BaseResponse<String>>(
                      initFuture: () async =>
                          ApiRepo().getFile(_selectedPhoto?.id),
                      onSuccess: (context, snapshot) {
                        _selectedPhoto?.content = snapshot?.data?.result;
                        return _profilePhoto(setState);
                      },
                    ),
                  ] else
                    _profilePhoto(setState),
                  const SizedBox(height: 16),
                  InnerDropdownFormField<Gender>(
                    label: context.appStrings!.gender,
                    value: _selectedGender,
                    items: Gender.values
                        .map((gender) => DropdownMenuItem<Gender>(
                            value: gender, child: Text("${gender.name![0].toUpperCase()}${gender.name?.substring(1).toLowerCase()}")))
                        .toList(),
                    onChanged: (gender) =>
                        setState(() => _selectedGender = gender),
                    validator: (value) =>
                        value == null ? context.appStrings!.requiredField : null,
                  ),
                  const SizedBox(height: 24),
                  Text(context.appStrings!.birthdate,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: DefaultThemeColors.nepal)),
                  InnerTextFormField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: TextEditingController(
                        text: _selectedBirthdate != null
                            ? dateFormat.format(_selectedBirthdate!)
                            : ""),
                    readOnly: true,
                    suffixIcon: SvgPicture.asset(
                      VPayIcons.calendar,
                      fit: BoxFit.none,
                      alignment: Alignment.center,
                    ),
                    validator: (value) =>
                        value?.isEmpty??true ? context.appStrings!.requiredField : null,
                    onTap: () async {
                      final result = await showDatePicker(
                          context: context,
                          initialDate: _selectedBirthdate ??
                              Jiffy.now()
                                  .subtract(years: 12)
                                  .dateTime,
                          firstDate: Jiffy.now()
                              .subtract(years: 100)
                              .dateTime,
                          lastDate: Jiffy.now()
                              .subtract(years: 12)
                              .dateTime,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light().copyWith(
                                  primary:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: child!,
                            );
                          });
                      if (result == null) return;
                      setState(() => _selectedBirthdate = result);
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomFutureBuilder<BaseResponse<List<String>>>(
                    initFuture: () => ApiRepo().getReligions(),
                    onSuccess: (context, religionSnapshot) {
                      var religions = religionSnapshot.data!.result;
                      if (religions != null) {
                        for (String r in religions)
                          if ((r ?? "").isEmpty)
                            religions[religions.indexOf(r)] = "No name";
                      }
                      religions?.sort((a, b) =>
                          a.toLowerCase().compareTo(b.toLowerCase()));
                      return Column(
                        children: [
                          InnerDropdownFormField<String>(
                            label: context.appStrings!.religion,
                            value: _selectedReligion,
                            items: religions != null
                                ? religions
                                    .map((religion) => DropdownMenuItem<String>(
                                        value: religion, child: Text("${religion[0].toUpperCase()}${religion?.substring(1).toLowerCase()}")))
                                    .toList()
                                : null,
                            onChanged: (religion) =>
                                setState(() => _selectedReligion = religion),
                            validator: (value) {
                              return value == null
                                ? context.appStrings!.requiredField
                                : null;
                            },
                          ),
                          const SizedBox(height: 24),
                          CustomFutureBuilder<BaseResponse<List<Department>>>(
                            initFuture: () => ApiRepo().getDepartments(
                                employeeGroupId: _employee?.employeesGroup?.id,
                                accessible: false),
                            onSuccess: (context, departmentsSnapshot) {
                              var departments = departmentsSnapshot.data!.result;
                              if (departments != null) {
                                for (Department d in departments)
                                  if ((d.name ?? "").isEmpty)
                                    departments[departments.indexOf(d)] =
                                        d.copyWith(name: "No name");
                              }
                              departments?.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()) ?? 0);
                              return Column(
                                children: [
                                  InnerDropdownFormField<Department>(
                                    label: context.appStrings!.department,
                                    value: _selectedDepartment,
                                    items: departments != null
                                        ? departments
                                            .map((department) =>
                                                DropdownMenuItem<Department>(
                                                    value: department,
                                                    child:
                                                        Text(department.name!)))
                                            .toList()
                                        : null,
                                    onChanged: (department) => setState(
                                        () => _selectedDepartment = department),
                                    validator: (value) => value == null
                                        ? context.appStrings!.requiredField
                                        : null,
                                  ),
                                  const SizedBox(height: 24),
                                  CustomFutureBuilder<
                                      BaseResponse<List<BaseModel>>>(
                                    initFuture: () => ApiRepo().getPositions(
                                        _employee?.employeesGroup?.id),
                                    onSuccess: (context, positionsSnapshot) {
                                      var positions =
                                          positionsSnapshot.data!.result;
                                      if (positions != null) {
                                        for (BaseModel p in positions)
                                          if ((p.name ?? "").isEmpty)
                                            positions[positions.indexOf(p)] =
                                                p.copyWith(name: "No name");
                                      }
                                      positions?.sort((a, b) => a.name
                                          !.toLowerCase()
                                          .compareTo(b.name!.toLowerCase()));
                                      return Column(
                                        children: [
                                          InnerDropdownFormField<BaseModel>(
                                            label: context.appStrings!.position,
                                            value: _selectedPosition,
                                            items: positions != null
                                                ? positions
                                                    .map((position) =>
                                                        DropdownMenuItem<
                                                                BaseModel>(
                                                            value: position,
                                                            child: Text(
                                                                position.name!)))
                                                    .toList()
                                                : null,
                                            onChanged: (position) => setState(
                                                () => _selectedPosition =
                                                    position),
                                            validator: (value) => value == null
                                                ? context
                                                    .appStrings!.requiredField
                                                : null,
                                          ),
                                          const SizedBox(height: 24),
                                          CustomFutureBuilder<
                                              BaseResponse<List<Employee>>>(
                                            initFuture: () => ApiRepo()
                                                .getManagers(resubmit
                                                    ? _employee?.parent?.id
                                                    : _employee?.id),
                                            onSuccess:
                                                (context, managersSnapshot) {
                                              var managers =
                                                  managersSnapshot.data!.result;
                                              if (managers != null) {
                                                for (Employee m in managers)
                                                  if ((m.fullName ?? "")
                                                      .isEmpty)
                                                    managers[
                                                        managers.indexOf(
                                                            m)] = m.copyWith(
                                                        fullName: "No name");
                                              }
                                              managers?.sort((a, b) => a
                                                  .fullName
                                                  !.toLowerCase()
                                                  .compareTo(b.fullName
                                                      !.toLowerCase()));
                                              return InnerDropdownFormField<
                                                  Employee>(
                                                label: context.appStrings!
                                                    .reportingManager,
                                                value: _selectedManager != null
                                                    ? managers!.firstWhereOrNull(
                                                        (m) =>
                                                            m.id ==
                                                            _selectedManager!.id)
                                                    : null,
                                                items: managers != null
                                                    ? managers
                                                        .map((manager) =>
                                                            DropdownMenuItem(
                                                                value: manager,
                                                                child: Text(manager
                                                                    .fullName!)))
                                                        .toList()
                                                    : null,
                                                onChanged: (manager) =>
                                                    setState(() =>
                                                        _selectedManager =
                                                            manager),
                                                validator: (value) =>
                                                    value == null
                                                        ? context.appStrings!
                                                            .requiredField
                                                        : null,
                                              );
                                            },
                                          ),
                                          // CustomFutureBuilder<BaseResponse<List<Currency>>>(
                                          //   initFuture: () => ApiRepo().getCurrencies(),
                                          //   onSuccess: (context, currenciesSnapshot) {
                                          //     var currencies = currenciesSnapshot.data.result;
                                          //     if (currencies != null) {
                                          //       for (Currency c in currencies)
                                          //         if ((c.unitName ?? "").isEmpty)
                                          //           currencies[currencies.indexOf(c)] = c.copyWith(unitName: "No name");
                                          //     }
                                          //     currencies?.sort((a, b) =>
                                          //         a?.unitName?.toLowerCase()?.compareTo(b?.unitName?.toLowerCase()));
                                          //     return Column(
                                          //       children: [
                                          //         InnerDropdownFormField<Currency>(
                                          //           label: "Currency",
                                          //           value: _selectedCurrency,
                                          //           items: currencies != null
                                          //               ? currencies
                                          //                   .map((currency) => DropdownMenuItem(
                                          //                       value: currency, child: Text(currency.unitName)))
                                          //                   .toList()
                                          //               : null,
                                          //           // onChanged: (currency) => setState(() => _selectedCurrency = currency),
                                          //           // validator: (value) => value == null ? "Required field" : null,
                                          //         ),
                                          //         const SizedBox(height: 24),
                                          //         CustomFutureBuilder<BaseResponse<List<Employee>>>(
                                          //           initFuture: () => ApiRepo().getManagers(_employee?.id),
                                          //           onSuccess: (context, managersSnapshot) {
                                          //             var managers = managersSnapshot.data.result;
                                          //             if (managers != null) {
                                          //               for (Employee m in managers)
                                          //                 if ((m.fullName ?? "").isEmpty)
                                          //                   managers[managers.indexOf(m)] = m.copyWith(fullName: "No name");
                                          //             }
                                          //             managers?.sort((a, b) => a?.fullName
                                          //                 ?.toLowerCase()
                                          //                 ?.compareTo(b?.fullName?.toLowerCase()));
                                          //             return InnerDropdownFormField<Employee>(
                                          //               label: "Reporting Manager",
                                          //               value: _selectedManager,
                                          //               items: managers != null
                                          //                   ? managers
                                          //                       .map((manager) => DropdownMenuItem(
                                          //                           value: manager, child: Text(manager.fullName)))
                                          //                       .toList()
                                          //                   : null,
                                          //               onChanged: (manager) => setState(() => _selectedManager = manager),
                                          //               validator: (value) => value == null ? "Required field" : null,
                                          //             );
                                          //           },
                                          //         )
                                          //       ],
                                          //     );
                                          //   },
                                          // )
                                        ],
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: CustomElevatedButton(
                        text: resubmit
                            ? context.appStrings!.resubmit.toUpperCase()
                            : context.appStrings!.submit.toUpperCase(),
                        onPressed: () => _onSubmit(resubmit: resubmit),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:provider/provider.dart';
// import 'package:vayroll/assets/icons.dart';
// import 'package:vayroll/models/models.dart';
// import 'package:vayroll/providers/providers.dart';
// import 'package:vayroll/repo/api/api_repo.dart';
// import 'package:vayroll/theme/app_themes.dart';
// import 'package:vayroll/utils/utils.dart';
// import 'package:vayroll/utils/constants.dart';
// import 'package:vayroll/widgets/custom_elevated_button.dart';
//
// import '../widgets.dart';
//
// void showPersonalInfoRequestBottomSheet({@required BuildContext context, @required Employee employee}) {
//   final _formKey = GlobalKey<FormState>();
//   Employee _employee = employee;
//   Gender _selectedGender =
//       _employee?.gender == null ? null : Gender.values.firstWhere((gender) => gender.name == _employee?.gender);
//   DateTime _selectedBirthdate = _employee?.birthDate;
//   BaseModel _selectedDepartment = _employee?.department;
//   BaseModel _selectedPosition = _employee?.position;
//   Currency _selectedCurrency = _employee?.currency;
//   Employee _selectedManager = _employee?.manager;
//
//   void _onSubmit() async {
//     if (!_formKey.currentState.validate()) return;
//
//     var emp = _employee.copyWith(
//       action: RequestAction.update,
//       gender: _selectedGender.name,
//       birthDate: _selectedBirthdate,
//       department: _selectedDepartment,
//       position: _selectedPosition,
//       currency: _selectedCurrency,
//       manager: _selectedManager,
//       photoBase64: "",
//     );
//     var response = await showFutureProgressDialog<BaseResponse<String>>(
//       context: context,
//       initFuture: () => ApiRepo().sendProfileInfoRequest(emp),
//     );
//
//     if (!response.status) {
//       showCustomModalBottomSheet(
//         context: context,
//         desc: response?.message ?? "Error Sending your request!",
//         icon: VPayIcons.blockUser,
//       );
//       return;
//     }
//
//     context.read<HomeTabIndexProvider>().hideBarItems
//         ? showCustomModalBottomSheet(
//             context: context,
//             desc: response?.message ??
//                 "Request to update your personal information has been sent successfully. Please check your request status in Requests section.",
//             isDismissible: false,
//             onTap: () {
//               Navigator.of(context).popUntil((route) => route.isFirst);
//               context.read<HomeTabIndexProvider>().hideBarItems = false;
//               context.read<HomeTabIndexProvider>().index = 2;
//             },
//           )
//         : showCustomModalBottomSheet(
//             context: context,
//             isDismissible: false,
//             desc: response?.message ??
//                 "Request to update your personal information has been sent successfully. Please check your request status in Requests section.",
//             onTap: () {
//               Navigator.of(context).popUntil((route) => route.isFirst);
//             },
//           );
//   }
//
//   Widget _genderDropdown(StateSetter setState) => InnerDropdownFormField<Gender>(
//         label: "Gender",
//         value: _selectedGender,
//         items:
//             Gender.values.map((gender) => DropdownMenuItem<Gender>(value: gender, child: Text(gender.name))).toList(),
//         onChanged: (gender) => setState(() => _selectedGender = gender),
//         validator: (value) => value == null ? "Required field" : null,
//       );
//
//   Widget _departmentsDropdown(StateSetter setState, String employeeGroupId) => CustomFutureBuilder<BaseResponse<List<BaseModel>>>(
//         initFuture: () => ApiRepo().getDepartments(employeeGroupId),
//         onSuccess: (context, snapshot) {
//           var departments = snapshot.data.result;
//           for (BaseModel d in departments)
//             if ((d.name ?? "").isEmpty) departments[departments.indexOf(d)] = d.copyWith(name: "No name");
//           departments?.sort((a, b) => a?.name?.toLowerCase()?.compareTo(b?.name?.toLowerCase()));
//           return InnerDropdownFormField<BaseModel>(
//             label: "Department",
//             value: _selectedDepartment,
//             items: departments != null
//                 ? departments
//                     .map((department) => DropdownMenuItem<BaseModel>(value: department, child: Text(department.name)))
//                     .toList()
//                 : null,
//             onChanged: (department) => setState(() => _selectedDepartment = department),
//             validator: (value) => value == null ? "Required field" : null,
//           );
//         },
//       );
//
//   Widget _positionsDropdown(StateSetter setState, String employeeGroupId) => CustomFutureBuilder<BaseResponse<List<BaseModel>>>(
//         initFuture: () => ApiRepo().getPositions(employeeGroupId),
//         onSuccess: (context, snapshot) {
//           var positions = snapshot.data.result;
//           for (BaseModel p in positions)
//             if ((p.name ?? "").isEmpty) positions[positions.indexOf(p)] = p.copyWith(name: "No name");
//           positions?.sort((a, b) => a?.name?.toLowerCase()?.compareTo(b?.name?.toLowerCase()));
//           return InnerDropdownFormField<BaseModel>(
//             label: "Position",
//             value: _selectedPosition,
//             items: positions != null
//                 ? positions
//                     .map((position) => DropdownMenuItem<BaseModel>(value: position, child: Text(position.name)))
//                     .toList()
//                 : null,
//             onChanged: (position) => setState(() => _selectedPosition = position),
//             validator: (value) => value == null ? "Required field" : null,
//           );
//         },
//       );
//
//   Widget _currenciesDropdown(StateSetter setState) => CustomFutureBuilder<BaseResponse<List<Currency>>>(
//         initFuture: () => ApiRepo().getCurrencies(),
//         onSuccess: (context, snapshot) {
//           var currencies = snapshot.data.result;
//           for (Currency c in currencies)
//             if ((c.unitName ?? "").isEmpty) currencies[currencies.indexOf(c)] = c.copyWith(unitName: "No name");
//           currencies?.sort((a, b) => a?.unitName?.toLowerCase()?.compareTo(b?.unitName?.toLowerCase()));
//           return InnerDropdownFormField<Currency>(
//             label: "Currency",
//             value: _selectedCurrency,
//             items: currencies != null
//                 ? currencies
//                     .map((currency) => DropdownMenuItem(value: currency, child: Text(currency.unitName)))
//                     .toList()
//                 : null,
//             onChanged: (currency) => setState(() => _selectedCurrency = currency),
//             validator: (value) => value == null ? "Required field" : null,
//           );
//         },
//       );
//
//   Widget _managersDropdown(StateSetter setState, String employeeId) => CustomFutureBuilder<BaseResponse<List<Employee>>>(
//         initFuture: () => ApiRepo().getManagers(employeeId),
//         onSuccess: (context, snapshot) {
//           var managers = snapshot.data.result;
//           for (Employee m in managers)
//             if ((m.fullName ?? "").isEmpty) managers[managers.indexOf(m)] = m.copyWith(fullName: "No name");
//           managers?.sort((a, b) => a?.fullName?.toLowerCase()?.compareTo(b?.fullName?.toLowerCase()));
//           return InnerDropdownFormField<Employee>(
//             label: "Reporting Manager",
//             value: _selectedManager,
//             items: managers != null
//                 ? managers.map((manager) => DropdownMenuItem(value: manager, child: Text(manager.fullName))).toList()
//                 : null,
//             onChanged: (manager) => setState(() => _selectedManager = manager),
//             validator: (value) => value == null ? "Required field" : null,
//           );
//         },
//       );
//
//   showModalBottomSheet<dynamic>(
//     isScrollControlled: true,
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
//     ),
//     builder: (BuildContext context) => StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) => ConstrainedBox(
//         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.76),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(30.0),
//             children: [
//               Text(
//                 'Request to update personal information',
//                 style: Theme.of(context).textTheme.headline5.copyWith(color: Theme.of(context).primaryColor),
//               ),
//               const SizedBox(height: 32),
//               _genderDropdown(setState),
//               const SizedBox(height: 24),
//               Text("Birthdate", style: Theme.of(context).textTheme.caption.copyWith(color: DefaultThemeColors.nepal)),
//               InnerTextFormField(
//                 textAlignVertical: TextAlignVertical.bottom,
//                 controller: TextEditingController(
//                     text: _selectedBirthdate != null ? dateFormat.format(_selectedBirthdate) : ""),
//                 readOnly: true,
//                 suffixIcon: SvgPicture.asset(
//                   VPayIcons.calendar,
//                   fit: BoxFit.none,
//                   alignment: Alignment.center,
//                 ),
//                 validator: (value) => value.isEmpty ? "Required field" : null,
//                 onTap: () async {
//                   final result = await showDatePicker(
//                       context: context,
//                       initialDate: _selectedBirthdate ?? DateTime.now(),
//                       firstDate: Jiffy(DateTime.now()).subtract(years: 100).dateTime,
//                       lastDate: DateTime.now(),
//                       builder: (BuildContext context, Widget child) {
//                         return Theme(
//                           data: ThemeData.light().copyWith(
//                             colorScheme: ColorScheme.light().copyWith(
//                               primary: Theme.of(context).colorScheme.secondary,
//                             ),
//                           ),
//                           child: child,
//                         );
//                       });
//                   if (result == null) return;
//                   setState(() => _selectedBirthdate = result);
//                 },
//               ),
//               const SizedBox(height: 24),
//               _departmentsDropdown(setState, _employee?.employeesGroup?.id),
//               // const SizedBox(height: 24),
//               // _positionsDropdown(setState, _employee?.employeesGroup?.id),
//               // const SizedBox(height: 24),
//               // _currenciesDropdown(setState),
//               // const SizedBox(height: 24),
//               // _managersDropdown(setState, _employee?.id),
//               const SizedBox(height: 32),
//               ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: 300),
//                 child: CustomElevatedButton(
//                   text: "Submit",
//                   onPressed: _onSubmit,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
