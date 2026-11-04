//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:core_api/src/date_serializer.dart';
import 'package:core_api/src/model/date.dart';

import 'package:core_api/src/model/admin_session_dto_output.dart';
import 'package:core_api/src/model/backup_codes_dto_output.dart';
import 'package:core_api/src/model/change_roles_dto.dart';
import 'package:core_api/src/model/complete_setup_dto.dart';
import 'package:core_api/src/model/create_user_dto.dart';
import 'package:core_api/src/model/done_dto_output.dart';
import 'package:core_api/src/model/role_matrix_dto_output.dart';
import 'package:core_api/src/model/role_matrix_dto_output_roles_inner.dart';
import 'package:core_api/src/model/setup_link_dto_output.dart';
import 'package:core_api/src/model/setup_token_dto.dart';
import 'package:core_api/src/model/sign_in_dto.dart';
import 'package:core_api/src/model/signed_out_dto_output.dart';
import 'package:core_api/src/model/status_dto_output.dart';
import 'package:core_api/src/model/team_users_dto_output.dart';
import 'package:core_api/src/model/team_users_dto_output_users_inner.dart';
import 'package:core_api/src/model/team_users_dto_output_users_inner_open_sessions_inner.dart';
import 'package:core_api/src/model/totp_enrolment_dto_output.dart';

part 'serializers.g.dart';

@SerializersFor([
  AdminSessionDtoOutput,
  BackupCodesDtoOutput,
  ChangeRolesDto,
  CompleteSetupDto,
  CreateUserDto,
  DoneDtoOutput,
  RoleMatrixDtoOutput,
  RoleMatrixDtoOutputRolesInner,
  SetupLinkDtoOutput,
  SetupTokenDto,
  SignInDto,
  SignedOutDtoOutput,
  StatusDtoOutput,
  TeamUsersDtoOutput,
  TeamUsersDtoOutputUsersInner,
  TeamUsersDtoOutputUsersInnerOpenSessionsInner,
  TotpEnrolmentDtoOutput,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(TeamUsersDtoOutputUsersInner)]),
        () => ListBuilder<TeamUsersDtoOutputUsersInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(TeamUsersDtoOutputUsersInnerOpenSessionsInner)]),
        () => ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(String)]),
        () => ListBuilder<String>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(RoleMatrixDtoOutputRolesInner)]),
        () => ListBuilder<RoleMatrixDtoOutputRolesInner>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
