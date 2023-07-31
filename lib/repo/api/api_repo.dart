import 'dart:core';

import 'package:dio/dio.dart';
import 'package:vayroll/models/announcement/announcementResponsePage.dart';
import 'package:vayroll/models/announcement/notificationResponsePage.dart';
import 'package:vayroll/models/document/all_help_document.dart';
import 'package:vayroll/models/emergency_contacts/emergencyContactsResponsePage.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/models/pagination/Profile/certifications/certificationResponsePage.dart';
import 'package:vayroll/models/pagination/Profile/educations/educationResponsePage.dart';
import 'package:vayroll/models/pagination/Profile/skills/skillResponsePage.dart';
import 'package:vayroll/models/pagination/Profile/workExperience/workExperienceResponsePage.dart';
import 'package:vayroll/models/pagination/payslips/payslipsResponsePage.dart';
import 'package:vayroll/repo/api/error_handling_interceptor.dart';
import 'package:vayroll/repo/api/logging_interceptor.dart';
import 'package:vayroll/repo/api/refresh_token_interceptor.dart';
import 'package:vayroll/repo/api/send_email_support_interceptor.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/utils/utils.dart';

class ApiRepo {
  //region Singleton
  static final ApiRepo _singleton = ApiRepo._internal();

  final Dio _client;

  factory ApiRepo() {
    return _singleton;
  }

  ApiRepo._internal() : _client = _generateClient();

  static Dio _generateClient() {
    final client = Dio();
    client.options.baseUrl = Urls.baseUrl;
    client.options.connectTimeout = Duration(seconds: 120);
    client.options.receiveTimeout = Duration(seconds: 40);
    client.interceptors.add(LoggingInterceptor());
    client.interceptors.add(RefreshTokenInterceptor(client));
    client.interceptors.add(SendEMailSupportInterceptor(client));
    client.interceptors.add(ErrorHandlingInterceptor());
    return client;
  }
  //endregion

  static BaseResponse getErrorResponse(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          return BaseResponse(
            status: false,
            code: e.response!.statusCode,
            message: (e.response!.data ?? "").toString().isNotEmpty
                ? e.response!.data['error'] ?? e.response!.data['message']
                : e.error.toString(),
            errors: (e.response?.data['errors'] as List?)?.map((e) => e as String).toList(),
          );
        case DioExceptionType.unknown:
          return BaseResponse(status: false, message: 'Connection Failed');
    case DioExceptionType.connectionTimeout:
      return BaseResponse(status: false, message: 'Connection Failed');
        case DioExceptionType.sendTimeout:
      return BaseResponse(status: false, message: 'Connection Failed');
        case DioExceptionType.receiveTimeout:
      return BaseResponse(status: false, message: 'Connection Failed');
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.badCertificate:
          break;
        case DioExceptionType.connectionError:
          break;
      }
    }
    printIfDebug(e.toString());
    return BaseResponse(status: false);
  }

  Future<BaseResponse<LoginDTO>> login(String username, String password) async {
    try {
final response = await _client.post(Urls.login, data: {
        "username": username,
        "password": password
      }).timeout(Duration(seconds: 10));
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => LoginDTO.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<String>>> getOCRKeywords() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(Urls.getOCRKeywords, data: accessToken);
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => (response.data['result'] as List?)?.map((e) => e as String).toList() as List<String>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<String>>> getOCRNegativeKeywords() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(Urls.getOCRNegativeKeywords, data: accessToken);
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => (response.data['result'] as List?)?.map((e) => e as String).toList() as List<String>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> logout() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final response = await _client.post(Urls.logout, data: {"token": accessToken});
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<LoginDTO>> refreshToken() async {
    try {
      final refreshToken = (await DiskRepo().getTokens()).last;
      final response = await _client.post(Urls.refreshToken, data: {"token": refreshToken});
      if (response.data['result'] != null) {
        BaseResponse<LoginDTO> refreshResponse =
            BaseResponse.fromJson(response.data, (_) => LoginDTO.fromJson(response.data['result']));
        await DiskRepo().saveTokens(
          refreshResponse.result!.accessToken!,
          refreshResponse.result!.refreshToken!,
        );
        return refreshResponse;
      }
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<UserDTO>> getUser() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final deviceInfo = (await DeviceInfo().getDeviceInfo())!;

      final response = await _client.post(Urls.getUser, data: {
        "token": accessToken,
        "deviceId": deviceInfo.id,
        "deviceModel": deviceInfo.model,
        "deviceType": deviceInfo.type,
      }).timeout(Duration(seconds: 10));
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => UserDTO.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> acceptDataConsent() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());
      final response = await _client
          .post(Urls.acceptDataConsent, data: {"token": accessToken, "acceptance": true, "userId": userId});
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resetPassword(String email) async {
    try {
      final response = await _client.post(
        Urls.resetPassword,
        queryParameters: {"email": email},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> newPassword(String? newPassword) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client
          .post(Urls.newPassword, data: {"token": accessToken, "new_password": newPassword, "userId": userId});
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> changePassword(String? currentPassword, String? newPassword) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.changePassword,
        data: {"token": accessToken, "userId": userId, "old_password": currentPassword, "new_password": newPassword},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<bool>> sendOtp(String channel, String? contact) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final deviceInfo = (await DeviceInfo().getDeviceInfo())!;

      final response = await _client.post(Urls.sendOtp,
          data: {"token": accessToken, "channel": channel, "contact": contact, "deviceId": deviceInfo.id});
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] ==true?true:false);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<bool>> verifyOtp(String otp, String? contact) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());
      final deviceInfo = (await DeviceInfo().getDeviceInfo())!;

      final response = await _client.post(Urls.verifyOtp,
          data: {"token": accessToken, "contact": contact, "otp": otp, "deviceId": deviceInfo.id, "userId": userId});
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as bool?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<Employee>> getMyEmployee() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getEmployee,
        data: {"token": accessToken, "userId": userId},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => Employee.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<Employee>> getEmployee({String? userId, String? employeeId}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmployee,
        data: {"token": accessToken, "userId": userId, "employeeId": employeeId},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => Employee.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<EmployeeInfo>> getEmployeeInfo({String? userId, String? employeeId}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmployeeInfo,
        data: {"token": accessToken, "userId": userId, "employeeId": employeeId},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => EmployeeInfo.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // region emergency contacts

  Future<BaseResponse<EmergencyContactsResponsePage>> getEmergencyContacts(
      String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmergencyContacts,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => EmergencyContactsResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> sendEmergencyContactsRequest(String? employeeId, List<EmergencyContact> contacts) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.sendEmergencyContactsRequest,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "emergencyContacts": contacts,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitEmergencyContacts(
      String? employeeId, List<EmergencyContact> emergencyContacts, String? requestStateId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmitEmergencyContactRequest,
        data: {
          "emergencyContacts": emergencyContacts,
          "employeeId": employeeId,
          "token": accessToken,
          "requestStateId": requestStateId,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion emergency contacts

  Future<BaseResponse<String>> getFile(String? fileId, {bool payslip = false}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getFile,
        data: {"token": accessToken, "fileId": fileId, "payslip": payslip},
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // region events

  Future<BaseResponse<List<BirthdaysResponse>>> getBirthdays(
      String employeesGroupId, String fromDate, String toDate) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(Urls.getBirthdays, data: {
        "employeesGroupId": employeesGroupId,
        "fromDate": fromDate,
        "toDate": toDate,
        "token": accessToken,
      });
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => BirthdaysResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<EventsResponse>> getEvents(
      String employeeId, String employeesGroupId, String fromDate, String toDate) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(Urls.getEvents, data: {
        "employeeId": employeeId,
        "employeesGroupId": employeesGroupId,
        "fromDate": fromDate,
        "toDate": toDate,
        "token": accessToken,
        "userId": userId,
      });
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => EventsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion events

  // region notes

  Future<BaseResponse<List<CalenderNotes>>> getNotes(String fromDate, String toDate) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(Urls.getNotes, data: {
        "fromDate": fromDate,
        "toDate": toDate,
        "token": accessToken,
        "userId": userId,
      });
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => CalenderNotes.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> createNote(String? title, String? desc, String noteDate) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(Urls.createNote, data: {
        "title": title,
        "description": desc,
        "noteDate": noteDate,
        "token": accessToken,
        "userId": userId,
      });
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> updateNote(String? id, String? title, String? desc) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(Urls.updateNote, data: {
        "id": id,
        "title": title,
        "description": desc,
        //"noteDate": noteDate,
        "token": accessToken,
        "userId": userId,
      });
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> deleteNote(String? noteId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        "${Urls.deleteNote}$noteId",
        data: {
          "token": accessToken,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion notes

  // region education

  Future<BaseResponse<EducationResponsePage>> getEducations(String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.educations,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => EducationResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> addUpdateDeleteEducation(String? employeeId, EducationResponseDTO education,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.educationsRiseRequest,
        data: {
          "attachment": attachment,
          "education": education,
          "employeeId": employeeId,
          "token": accessToken,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitEducation(
      String? employeeId, EducationResponseDTO education, String? requestStateId,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmiteducationRequest,
        data: {
          "attachment": attachment,
          "education": education,
          "employeeId": employeeId,
          "token": accessToken,
          "requestStateId": requestStateId,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion education

  // region experience

  Future<BaseResponse<WorkExperienceResponsePage>> getExperiences(
      String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.experiences,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => WorkExperienceResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> addUpdateDeleteExperience(String? employeeId, ExperiencesResponseDTO workExperience,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.experiencesRiseRequest,
        data: {
          "attachment": attachment,
          "workExperience": workExperience,
          "employeeId": employeeId,
          "token": accessToken,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitExperiences(
      String? employeeId, ExperiencesResponseDTO workExperience, String? requestStateId,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmitexperienceRequest,
        data: {
          "attachment": attachment,
          "workExperience": workExperience,
          "employeeId": employeeId,
          "token": accessToken,
          "requestStateId": requestStateId,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion experience
  // region certificate

  Future<BaseResponse<CertificationResponsePage>> getCertificates(
      String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.certificates,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => CertificationResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> addUpdateDeleteCertificate(String? employeeId, CertificateResponseDTO certificate,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.certificatesRiseRequest,
        data: {
          "attachment": attachment,
          "certificate": certificate,
          "employeeId": employeeId,
          "token": accessToken,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitCertificates(
      String? employeeId, CertificateResponseDTO certificate, String? requestStateId,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmitCertificationRequest,
        data: {
          "attachment": attachment,
          "certificate": certificate,
          "employeeId": employeeId,
          "token": accessToken,
          "requestStateId": requestStateId,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion certificate

  // region skill

  Future<BaseResponse<SkillResponsePage>> getSkills(String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.skills,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => SkillResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> addUpdateDeleteSkill(String? employeeId, SkillsResponseDTO skill) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.skillsRiseRequest,
        data: {
          "token": accessToken,
          "skill": skill,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitSkills(String? employeeId, SkillsResponseDTO skill, String? requestStateId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmitskillRequest,
        data: {
          "skill": skill,
          "employeeId": employeeId,
          "token": accessToken,
          "requestStateId": requestStateId,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // endregion skill

  Future<BaseResponse<List<Department>>> getDepartments(
      {String? employeeGroupId, bool? accessible, String? employeeId}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAllDepartments,
        data: {
          "token": accessToken,
          "employeesGroupId": employeeGroupId,
          "employeeId": employeeId,
          "accessible": accessible,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => Department.fromJson(e as Map<String, dynamic>))
                .toList() as List<Department>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<BaseModel>>> getPositions(String? employeeGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getPositions,
        data: {"token": accessToken, "employeesGroupId": employeeGroupId},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
                .toList() as List<BaseModel>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Currency>>> getCurrencies() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getCurrencies,
        data: {"token": accessToken},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) =>  Currency.fromJson(e as Map<String, dynamic>))
                .toList() as List<Currency>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Employee>>> getManagers(String? employeeId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getManagers,
        data: {"token": accessToken, "employeeId": employeeId},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) =>  Employee.fromJson(e as Map<String, dynamic>))
                .toList() as List<Employee> );
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Country>>> getCountries() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getCountries,
        data: {"token": accessToken},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => Country.fromJson(e as Map<String, dynamic>))
                .toList() as List<Country>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<dynamic>>> getSkillProficiencies() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getSkillProficiencies,
        data: accessToken,
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => (response.data['result'] as List<dynamic>?));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> confirmProfile(String? employeeId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.confirmEmployeeProfile,
        data: {"token": accessToken, "employeeId": employeeId},
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> sendProfileInfoRequest(Employee employee, Attachment? photo) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final response = await _client.post(
        Urls.sendEmployeeInfoRequest,
        data: {
          "token": accessToken,
          "employeeId": employee.id,
          "employee": employee,
          "attachment": photo,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitProfileInfo(String? employeeId, Employee employee, String? requestStateId,
      {Attachment? attachment}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmitinfoRequest,
        data: {
          "attachment": attachment,
          "employee": employee,
          "employeeId": employeeId,
          "token": accessToken,
          "requestStateId": requestStateId,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<String>>> getReligions() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(Urls.getReligions, data: accessToken);
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => (response.data['result'] as List?)?.map((e) => e as String).toList() as List<String>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<LeaveBalanceResponse> getLeaveBalance(String? employeeId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getLeaveBalance,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      return LeaveBalanceResponse.fromJson(response.data);
    } catch (e) {
      return LeaveBalanceResponse.fromJson(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllRequestsResponse>> getActiveRequests(String requestType,
      {bool? isMine, int? pageIndex, int? pageSize, List<String>? requestStatus}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getMyActiveRequests,
        data: {
          "token": accessToken,
          "userId": userId,
          "requestKind": [requestType],
          "isMine": isMine,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "requestStatus": requestStatus
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllRequestsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<EmployeeFeedback>> sendFeedback(EmployeeFeedback feedback) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final response = await _client.post(
        Urls.sendFeedback,
        data: {
          "token": accessToken,
          "employeeId": feedback.employeeId,
          "feedbackContent": feedback.feedbackContent,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => EmployeeFeedback.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> checkIn(String? employeeId, CheckInOut data) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final response = await _client.post(
        Urls.checkIn,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "checkInLatitude": data.latitude,
          "checkInLongitude": data.longitude,
          "checkInTime": dateFormat3.format(data.time!),
          "isManualCheckIn": data.isManual,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> checkOut(String? employeeId, CheckInOut data) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final response = await _client.post(
        Urls.checkOut,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "id": data.id,
          "checkOutLatitude": data.latitude,
          "checkOutLongitude": data.longitude,
          "checkOutTime": dateFormat3.format(data.time!),
          "isManualCheckOut": data.isManual,
          "totalWorkingHours": data.workingHours,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> requestAction(String? requestStateId, String action) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.actions,
        data: {
          "token": accessToken,
          "userId": userId,
          "action": action,
          "requestStateId": requestStateId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllDailyAttendanceResponse>> getAttendanceSessions(String? employeeId,
      {int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAttendanceSessions,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "date": dateFormat2.format(DateTime.now()),
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => AllDailyAttendanceResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<DepartmentAttendanceResponse>> getTeamAttendance(String? employeeId, DateTime date,
      {int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getTeamAttendance,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "date": dateFormat2.format(date),
          "pageIndex": pageIndex,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => DepartmentAttendanceResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<DepartmentAttendanceResponse>> getDepartmentAttendance(
      String? employeeId, DateTime date, String? departmentId,
      {int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAttendanceDepartments,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "date": dateFormat2.format(date),
          "pageIndex": pageIndex,
          "departmentId": departmentId,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => DepartmentAttendanceResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<DepartmentAttendanceResponse>> getDepartmentAttendanceSummary(
      String? employeeId, DateTime date, String? departmentId,
      {int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAttendanceDepartmentSummary,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "date": dateFormat2.format(date),
          "departmentId": departmentId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => DepartmentAttendanceResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  // Future<BaseResponse<List<DepartmentAttendance>>> getAccessibleAttendanceDepartments(
  //     String employeeId, DateTime dateTime) async {
  //   try {
  //     final accessToken = (await DiskRepo().getTokens()).first;

  //     final response = await _client.post(
  //       Urls.getAccessibleAttendanceDepartments,
  //       data: {
  //         "token": accessToken,
  //         "employeeId": employeeId,
  //         "date": dateFormat2.format(dateTime),
  //       },
  //     );
  //     if (response.data['result'] != null)
  //       return BaseResponse.fromJson(
  //           response.data,
  //           (_) => (response.data['result'] as List)
  //               ?.map((e) => e == null ? null : DepartmentAttendance.fromJson(e as Map<String, dynamic>))
  //               ?.toList());
  //     return BaseResponse.fromMap(response.data);
  //   } catch (e) {
  //     return BaseResponse.fromMap(getErrorResponse(e).toMap());
  //   }
  // }

  // Future<BaseResponse<List<DepartmentAccessible>>> getAccessibleDepartments(String employeeId) async {
  //   try {
  //     final accessToken = (await DiskRepo().getTokens()).first;

  //     final response = await _client.post(
  //       Urls.getAccessibleDepartments,
  //       data: {
  //         "token": accessToken,
  //         "employeeId": employeeId,
  //       },
  //     );
  //     if (response.data['result'] != null)
  //       return BaseResponse.fromJson(
  //           response.data,
  //           (_) => (response.data['result'] as List)
  //               ?.map((e) => e == null ? null : DepartmentAccessible.fromJson(e as Map<String, dynamic>))
  //               ?.toList());
  //     return BaseResponse.fromMap(response.data);
  //   } catch (e) {
  //     return BaseResponse.fromMap(getErrorResponse(e).toMap());
  //   }
  // }

  // Future<BaseResponse<List<DepartmentAccessible>>> getAllDepartmentsDetails(String employeesGroupId) async {
  //   try {
  //     final accessToken = (await DiskRepo().getTokens()).first;

  //     final response = await _client.post(
  //       Urls.getAllDepartmentsDetails,
  //       data: {
  //         "token": accessToken,
  //         "employeesGroupId": employeesGroupId,
  //       },
  //     );
  //     if (response.data['result'] != null)
  //       return BaseResponse.fromJson(
  //           response.data,
  //           (_) => (response.data['result'] as List)
  //               ?.map((e) => e == null ? null : DepartmentAccessible.fromJson(e as Map<String, dynamic>))
  //               ?.toList());
  //     return BaseResponse.fromMap(response.data);
  //   } catch (e) {
  //     return BaseResponse.fromMap(getErrorResponse(e).toMap());
  //   }
  // }

  // Future<BaseResponse<List<DepartmentAttendance>>> getAllAccessibleDepartmentsAttendance(
  //   String employeesGroupId,
  //   DateTime dateTime,
  // ) async {
  //   try {
  //     final accessToken = (await DiskRepo().getTokens()).first;

  //     final response = await _client.post(
  //       Urls.getAllAccessibleAttendanceDepartments,
  //       data: {
  //         "token": accessToken,
  //         "employeesGroupId": employeesGroupId,
  //         "date": dateFormat2.format(dateTime),
  //       },
  //     );
  //     if (response.data['result'] != null)
  //       return BaseResponse.fromJson(
  //           response.data,
  //           (_) => (response.data['result'] as List)
  //               ?.map((e) => e == null ? null : DepartmentAttendance.fromJson(e as Map<String, dynamic>))
  //               ?.toList());
  //     return BaseResponse.fromMap(response.data);
  //   } catch (e) {
  //     return BaseResponse.fromMap(getErrorResponse(e).toMap());
  //   }
  // }

  Future<BaseResponse<AnnualAttendance>> getAnnualAttendance(String? employeeId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAnnualAttendance,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AnnualAttendance.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllRequestsResponse>> getAllRequests({
    bool? behalfOfMe,
    bool? submitter,
    bool? approver,
    String? requestNumber,
    String? fromSubmissionDate,
    String? toSubmissionDate,
    String? fromClosedDate,
    String? toClosedDate,
    List<String>? requestKind,
    List<String>? requestStatus,
    bool? manager,
    List<String?>? subject,
    bool? department,
    int? pageIndex,
    int? pageSize,
  }) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getRequests,
        data: {
          "token": accessToken,
          "userId": userId,
          "behalfOfMe": behalfOfMe,
          "submitter": submitter,
          "approver": approver,
          "requestNumber": requestNumber,
          "fromSubmissionDate": fromSubmissionDate,
          "toSubmissionDate": toSubmissionDate,
          "fromClosedDate": fromClosedDate,
          "toClosedDate": toClosedDate,
          "requestKind": requestKind,
          "requestStatus": requestStatus,
          "manager": manager,
          "subject": subject,
          "department": department,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllRequestsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<bool>> isUserApproverForDecidable() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.isRequestApproverByDefinition,
        data: {
          "token": accessToken,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as bool);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllRequestsResponse>> getDecidableRequests({
    bool? behalfOfMe,
    bool? submitter,
    bool? notifier,
    bool? approver,
    String? requestNumber,
    String? fromSubmissionDate,
    String? toSubmissionDate,
    String? fromClosedDate,
    String? toClosedDate,
    List<String>? requestKind,
    List<String>? requestStatus,
    int? pageIndex,
    int? pageSize,
  }) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getDecidableRequest,
        data: {
          "token": accessToken,
          "userId": userId,
          "behalfOfMe": behalfOfMe,
          "submitter": submitter,
          "approver": approver,
          "notifier": notifier,
          "requestNumber": requestNumber,
          "fromSubmissionDate": fromSubmissionDate,
          "toSubmissionDate": toSubmissionDate,
          "fromClosedDate": fromClosedDate,
          "toClosedDate": toClosedDate,
          "requestKind": requestKind,
          "requestStatus": requestStatus,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllRequestsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> makeActionOnDecidableRequest({
    String? action,
    String? requestStepId,
    String? note,
  }) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.makeDecidableRequestAction,
        data: {
          "token": accessToken,
          "userId": userId,
          "action": action,
          "requestStepId": requestStepId,
          "note": note,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllAppealResponse>> getAppealRequests({
    String? category,
    int? pageIndex,
    int? pageSize,
    bool? submitter,
  }) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getAppealRequests,
        data: {
          "token": accessToken,
          "userId": userId,
          "category": category,
          "submitter": submitter,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllAppealResponse.fromJson(response.data['result']));

      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<CalendarAttendance>>> getCalendarAttendance(
      String? employeeId, DateTime from, DateTime to) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getCalendarAttendance,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "fromDate": dateFormat3.format(from),
          "toDate": dateFormat3.format(to),
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => CalendarAttendance.fromJson(e as Map<String, dynamic>))
                .toList() as List<CalendarAttendance>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> attendanceAppealRequest(
      String? employeeId, DateTime date, DateTime checkIn, DateTime checkOut, String? note, Attachment? attachment) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.attendanceAppealRequest,
        data: {
          "token": accessToken,
          "userId": userId,
          "employeeId": employeeId,
          "appealDate": dateFormat3.format(date),
          "checkInTime": dateFormat3.format(checkIn),
          "checkOutTime": dateFormat3.format(checkOut),
          "note": note,
          "attachment": attachment,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<RequestDetailsResponse>> getRequestDetials(MyRequestsResponseDTO? requestInfo) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final response = await _client.post(
        Urls.getRequestdetials,
        data: {
          "token": accessToken,
          "requestNumber": requestInfo?.requestNumber,
          "requestId": requestInfo?.requestId,
          "employeeId": requestInfo?.subjectId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(
          response.data,
          (_) => RequestDetailsResponse.fromJson(
            response.data['result'],
            (_) {
              if (response.data['result']['error'] == "") {
                switch (response.data['result']['requestInfo']['transactionClassName']) {
                  case RequestProfileType.employeeEducation:
                    return EducationResponseDTO.fromJson(response.data['result']['newValue']);
                  case RequestProfileType.employeeCertificate:
                    return CertificateResponseDTO.fromJson(response.data['result']['newValue']);
                  case RequestProfileType.employeeSkill:
                    return SkillsResponseDTO.fromJson(response.data['result']['newValue']);
                  case RequestProfileType.employeeWorkExperience:
                    return ExperiencesResponseDTO.fromJson(response.data['result']['newValue']);
                  case RequestProfileType.personalInformation:
                    return Employee.fromJson(response.data['result']['newValue']);
                  case RequestProfileType.employeeEmergencyContact:
                    return EmergencyContact.fromJson(response.data['result']['newValue']);

                  default:
                    return null;
                }
              }
            },
          ),
        );
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> resubmitAttendanceAppealRequest(String? id, String? requestStateId, String? employeeId,
      DateTime date, DateTime checkIn, DateTime checkOut, String? note, Attachment? attachment) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.resubmitAttendanceAppealRequest,
        data: {
          "token": accessToken,
          "id": id,
          "requestStateId": requestStateId,
          "userId": userId,
          "employeeId": employeeId,
          "appealDate": dateFormat3.format(date),
          "checkInTime": dateFormat3.format(checkIn),
          "checkOutTime": dateFormat3.format(checkOut),
          "note": note,
          "attachment": attachment,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> sendAppealRequest(AppealRequest appealRequestInfo) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());
      appealRequestInfo.token = accessToken;
      appealRequestInfo.submitterId = userId;

      final response = await _client.post(
        Urls.sendAppealRequest,
        data: appealRequestInfo.toJson(),
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<DrewFieldsRequestsResponse> getRequestDrewFields(String? employeeId, String? requestKind) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getDrewFieldsSubmit,
        data: {"token": accessToken, "userId": userId, "requestKind": requestKind, "employeeId": employeeId},
      );

      return DrewFieldsRequestsResponse.fromJson(response.data);
    } catch (e) {
      return DrewFieldsRequestsResponse.fromJson(getErrorResponse(e).toMap());
    }
  }

  Future<DrewFieldsRequestsResponse> getRequestDrewFieldsResubmit(
      String? employeeId, String? requestKind, String? requestStateId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.getDrewFieldsResubmit,
        data: {
          "token": accessToken,
          "userId": userId,
          "requestKind": requestKind,
          "employeeId": employeeId,
          "requestStateId": requestStateId
        },
      );

      return DrewFieldsRequestsResponse.fromJson(response.data);
    } catch (e) {
      return DrewFieldsRequestsResponse.fromJson(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Employee>>> getRequestsubjects(String? employeeId, String? requestKind) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());

      final response = await _client.post(
        Urls.requestSubjects,
        data: {"token": accessToken, "userId": userId, "requestKind": requestKind, "employeeId": employeeId},
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
                .toList() as List<Employee>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> submitRequest(
      String? employeeId, String? submitterId, String? requestKind, List<RequestStateAttributesDTO> requestStateAttributes,
      {String? note, String? requestStateId}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());
      final submitterId = (await DiskRepo().getEmployeeId());

      final response = await _client.post(
        Urls.submitRequest,
        data: {
          "token": accessToken,
          "userId": userId,
          "actualSubmitterId": submitterId,
          "requestKind": requestKind,
          "employeeId": employeeId,
          "note": note,
          "requestStateAttributes": requestStateAttributes,
          "requestStateId": requestStateId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> reSubmitRequest(String? employeeId, String? submitterId, String? requestKind,
      String? requestStateId, List<RequestStateAttributesDTO> requestStateAttributes,
      {String? note}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());
      final submitterId = (await DiskRepo().getEmployeeId());

      final response = await _client.post(
        Urls.reSubmitRequest,
        data: {
          "token": accessToken,
          "userId": userId,
          "actualSubmitterId": submitterId,
          "requestKind": requestKind,
          "employeeId": employeeId,
          "note": note,
          "requestStateAttributes": requestStateAttributes,
          "requestStateId": requestStateId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<SummaryRequestsResponse> validateRequest(
    String? employeeId,
    String? requestKind,
    List<RequestStateAttributesDTO>? requestStateAttributes, {
    String? note,
    String? requestStateId,
  }) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = (await DiskRepo().getUserId());
      final submitterId = (await DiskRepo().getEmployeeId());

      final response = await _client.post(
        Urls.summaryRequest,
        data: {
          "token": accessToken,
          "userId": userId,
          "actualSubmitterId": submitterId,
          "requestKind": requestKind,
          "employeeId": employeeId,
          "note": note,
          "requestStateAttributes": requestStateAttributes,
          "requestStateId": requestStateId,
        },
      );
      return SummaryRequestsResponse.fromJson(response.data);
    } catch (e) {
      return SummaryRequestsResponse.fromJson(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<Appeal>> getAppealRequestDetails(String? id) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAppealRequestDetails,
        data: {
          "token": accessToken,
          "appealRequestId": id,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => Appeal.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> sendAppealNote(AppealNoteRequest appealNoteRequestInfo) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = await DiskRepo().getUserId();

      appealNoteRequestInfo.token = accessToken;
      appealNoteRequestInfo.submitterId = userId;

      final response = await _client.post(
        Urls.sendAppealNote,
        data: appealNoteRequestInfo.toJson(),
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<PayslipsResponsePage>> getPayslips(String? employeeId,
      {DateTime? fromDate, DateTime? toDate, int? numberOfMonths, int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getPayslips,
        data: {
          "token": accessToken,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "employeeId": employeeId,
          "fromDate": fromDate != null ? dateFormat2.format(fromDate) : null,
          "toDate": toDate != null ? dateFormat2.format(toDate) : null,
          "numberOfMonths": numberOfMonths != null ? numberOfMonths : null,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => PayslipsResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> emailPayslip(String? employeeId, String payrollId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.emailPayslip,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "payrollId": payrollId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<ExpenseResponse>> getExpensesClaims(String? employeeId, String date) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.expenseClaim,
        data: {
          "date": date,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => ExpenseResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AnnouncementResponsePage>> getUserAnnouncements(
      String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getUserAnnouncements,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AnnouncementResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<Announcement>> getAnnouncementById(String? employeeId, String? announcementId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getAnnouncementById,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "announcementId": announcementId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => Announcement.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<int>> getUnreadAnnouncementsCount(String? employeeId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getUnreadAnnouncementsCount,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as int?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<bool>> markAnnouncementAsRead(String? employeeId, String? announcementId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.markAnnouncementAsRead,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "announcementId": announcementId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as bool?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<NotificationResponsePage>> getUserNotifications(
      String? employeeId, int pageIndex, int pageSize) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getUserNotifications,
        data: {
          "pageIndex": pageIndex,
          "pageSize": pageSize,
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => NotificationResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<int>> getUnreadNotificationCount(String? employeeId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getUnreadNotificationsCount,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as int?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<HRContact>>> getHRContacts(String? employeesGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getHRContacts,
        data: {
          "token": accessToken,
          "employeesGroupId": employeesGroupId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => e == null ? null : HRContact.fromJson(e as Map<String, dynamic>))
                .toList() as List<HRContact>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<Company>> getCompanyInfo(String? employeesGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getCompanyInfo,
        data: {
          "token": accessToken,
          "employeesGroupId": employeesGroupId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => Company.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<DeaprtmentDetailsResponse>> getDepartmentEmployess(
      String? departmentId, String? employeesGroupId, String? employeeId,
      {String? employeeName, int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getDepartmentEmployess,
        data: {
          "token": accessToken,
          "departmentId": departmentId,
          "employeesGroupId": employeesGroupId,
          "employeeId": employeeId,
          "employeeName": employeeName,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => DeaprtmentDetailsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllDocumentsResponsePage>> getCompanydocuments(
      {String? employeesGroupId, String? departmentId, int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getCompanydocuments,
        data: {
          "token": accessToken,
          "employeesGroupId": employeesGroupId,
          "departmentId": departmentId,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllDocumentsResponsePage.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllEmailsResponse>> getEmails(String? employeeId, List<String> status,
      {int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmails,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "status": status,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllEmailsResponse.fromJson(response.data['result']));

      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List>> sendEmailToHR(HREmail email) async {
    try {
      email.token = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.sendEmailToHR,
        data: email.toJson(),
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as List?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List>> sendEmail(Email email) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(Urls.sendEmail, data: {
        "token": accessToken,
        "email": email.toJson(),
      });
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as List?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<ChartEmployee>> getEmployeeGroupChart(String? employeesGroupId, String? organizationId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmployeeGroupChart,
        data: {
          "token": accessToken,
          "employeesGroupId": employeesGroupId,
          "organizationId": organizationId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => ChartEmployee.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<dynamic>> updateFCMToken(String fcmToken) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final deviceInfo = (await DeviceInfo().getDeviceInfo())!;

      final response = await _client.post(
        Urls.updateFCMToken,
        data: {
          "token": accessToken,
          "deviceId": deviceInfo.id,
          "fcmToken": fcmToken,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as dynamic);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<SupportContacts>> getSupportContacts() async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.support,
        data: {"token": accessToken},
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => SupportContacts.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List>> saveCall(String? fromEmployeeId, String? phoneNumber, String startedAt,
      {Caller? recipient}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.saveCall,
        data: {
          "token": accessToken,
          "fromEmployeeId": fromEmployeeId,
          "phoneNumber": phoneNumber,
          "startedAt": startedAt,
          "recipient": recipient,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as List?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllCallsResponse>> callHistory(String? fromEmployeeId, {int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.callHistory,
        data: {
          "token": accessToken,
          "fromEmployeeId": fromEmployeeId,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllCallsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<EmailDTO>> getEmailDetails(String? employeeId, String? emailId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmailDetails,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "emailId": emailId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => EmailDTO.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<String>> getEmailFile(String? attachmentId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.downloadMailAttachment,
        data: {
          "token": accessToken,
          "attachmentId": attachmentId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as String);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<bool>> markNotificationAsRead({String? notificationId, String? employeeId}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.markNotificationAsRead,
        data: {
          "token": accessToken,
          "notificationId": notificationId,
          "employeeId": employeeId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as bool?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Contract>>> getContracts(List<String?>? departmentIds, String? employeesGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getContracts,
        data: {
          "token": accessToken,
          "departmentIds": departmentIds,
          "employeesGroupId": employeesGroupId,
        },
      );
      if (response.data['result'] != null) {
        var res = BaseResponse<List<Contract>>.fromJson(
            response.data,
            (_) => (response.data['result'] as Map<String, dynamic>)
                .entries
                .map((e) =>Contract(name: e.key, count: e.value))
                .toList() as List<Contract>);
        for (int i = 0; i < res.result!.length; i++) {
          res.result![i].color = colorBallet[i];
        }
        return res;
      }
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<PositionGender>>> getPositionsAndGenders(
      List<String?>? departmentIds, String? employeesGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getPositionsAndGenders,
        data: {
          "token": accessToken,
          "departmentIds": departmentIds,
          "employeesGroupId": employeesGroupId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => PositionGender.fromJson(e as Map<String, dynamic>))
                .toList() as List<PositionGender>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Experience>>> getExperience(List<String?>? departmentIds, String? employeesGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getExperience,
        data: {
          "token": accessToken,
          "departmentIds": departmentIds,
          "employeesGroupId": employeesGroupId,
        },
      );
      if (response.data['result'] != null) {
        return BaseResponse<List<Experience>>.fromJson(
            response.data,
            (_) => (response.data['result'] as Map<String, dynamic>)
                .entries
                .map((e) =>  Experience(name: e.key, count: e.value))
                .toList());
      }
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<LeaveBalanceBriefDTO>>> leaveBalancesDynamic(
      String? employeeId, String? leaveTransactionId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.leaveBalancesDynamic,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "leaveTransactionId": leaveTransactionId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) =>  LeaveBalanceBriefDTO.fromJson(e as Map<String, dynamic>))
                .toList() as List<LeaveBalanceBriefDTO>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<LeaveBalanceResponseDTO>> leaveBalancePeriod(
    String? employeeId,
    String startDate,
    String endDate,
    String? leaveRuleBalanceId,
    String? leaveRuleId,
  ) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.leaveBalancePeriod,
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "startDate": startDate,
          "endDate": endDate,
          "leaveRuleId": leaveRuleId,
          "leaveRuleBalanceId": leaveRuleBalanceId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => LeaveBalanceResponseDTO.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<bool>> isManager(List<String> requestKind, List<String> transactionClassName) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final userId = await DiskRepo().getUserId();

      final response = await _client.post(
        Urls.isRequestApprover,
        data: {
          "token": accessToken,
          "requestKind": requestKind,
          "transactionClassName": transactionClassName,
          "userId": userId,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => response.data['result'] as bool?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<Employee>>> getEmployeeReportees(String? managerId, String? employeesGroupId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getEmployeeReportees,
        data: {
          "token": accessToken,
          "employeesGroupId": employeesGroupId,
          "managerId": managerId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data,
            (_) => (response.data['result'] as List?)
                ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
                .toList() as List<Employee>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<AllHelpDocumentsResponse>> getHelpdocuments(
      {String? employeesGroupId, String? departmentId, int? pageIndex, int? pageSize}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.getHelpDocuments,
        data: {
          "token": accessToken,
          "pageIndex": pageIndex,
          "pageSize": pageSize,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(response.data, (_) => AllHelpDocumentsResponse.fromJson(response.data['result']));
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  Future<BaseResponse<List<int>>> getHelpDocumentAttachment(String? attachmentId) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;

      final response = await _client.post(
        Urls.downloadHelpDocuments,
        data: {
          "token": accessToken,
          "attachmentId": attachmentId,
        },
      );

      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => (response.data['result'] as List?)?.map((e) => e as int).toList() as List<int>);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }
}
