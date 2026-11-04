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
import 'package:core_api/src/model/complete_setup_dto.dart';
import 'package:core_api/src/model/setup_token_dto.dart';
import 'package:core_api/src/model/sign_in_dto.dart';
import 'package:core_api/src/model/signed_out_dto_output.dart';
import 'package:core_api/src/model/status_dto_output.dart';
import 'package:core_api/src/model/totp_enrolment_dto_output.dart';

part 'serializers.g.dart';

@SerializersFor([
  AdminSessionDtoOutput,
  BackupCodesDtoOutput,
  CompleteSetupDto,
  SetupTokenDto,
  SignInDto,
  SignedOutDtoOutput,
  StatusDtoOutput,
  TotpEnrolmentDtoOutput,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
