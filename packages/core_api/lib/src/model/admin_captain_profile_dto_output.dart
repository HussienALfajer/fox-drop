//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_acceptance.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_suspension.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_earnings.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_rating.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_app.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_on_time.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_custody.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output.g.dart';

/// AdminCaptainProfileDtoOutput
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [name]
/// * [phone] - In full for captains.manage (each view audited), masked otherwise.
/// * [vehicle]
/// * [plateNumber]
/// * [status]
/// * [suspension]
/// * [applicationId] - The captain's file; null for a seeded one.
/// * [contractPhase]
/// * [custody]
/// * [earnings]
/// * [ordersToday]
/// * [delivered]
/// * [onTime]
/// * [cancellations] - Captain cancellations within captain.violation_window_days (AP §9.7.6).
/// * [acceptance]
/// * [rating]
/// * [app]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutput
    implements
        Built<
          AdminCaptainProfileDtoOutput,
          AdminCaptainProfileDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// In full for captains.manage (each view audited), masked otherwise.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'vehicle')
  String get vehicle;

  @BuiltValueField(wireName: r'plateNumber')
  String? get plateNumber;

  @BuiltValueField(wireName: r'status')
  AdminCaptainProfileDtoOutputStatusEnum get status;
  // enum statusEnum {  online,  busy,  offline,  suspended,  cash_blocked,  terminated,  };

  @BuiltValueField(wireName: r'suspension')
  AdminCaptainProfileDtoOutputSuspension? get suspension;

  /// The captain's file; null for a seeded one.
  @BuiltValueField(wireName: r'applicationId')
  String? get applicationId;

  @BuiltValueField(wireName: r'contractPhase')
  AdminCaptainProfileDtoOutputContractPhaseEnum? get contractPhase;
  // enum contractPhaseEnum {  probation,  commitment,  open,  };

  @BuiltValueField(wireName: r'custody')
  AdminCaptainProfileDtoOutputCustody get custody;

  @BuiltValueField(wireName: r'earnings')
  AdminCaptainProfileDtoOutputEarnings get earnings;

  @BuiltValueField(wireName: r'ordersToday')
  int get ordersToday;

  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  @BuiltValueField(wireName: r'onTime')
  AdminCaptainProfileDtoOutputOnTime get onTime;

  /// Captain cancellations within captain.violation_window_days (AP §9.7.6).
  @BuiltValueField(wireName: r'cancellations')
  int get cancellations;

  @BuiltValueField(wireName: r'acceptance')
  AdminCaptainListDtoOutputCaptainsInnerAcceptance? get acceptance;

  @BuiltValueField(wireName: r'rating')
  AdminCaptainProfileDtoOutputRating? get rating;

  @BuiltValueField(wireName: r'app')
  AdminCaptainProfileDtoOutputApp get app;

  AdminCaptainProfileDtoOutput._();

  factory AdminCaptainProfileDtoOutput([
    void updates(AdminCaptainProfileDtoOutputBuilder b),
  ]) = _$AdminCaptainProfileDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutput> get serializer =>
      _$AdminCaptainProfileDtoOutputSerializer();
}

class _$AdminCaptainProfileDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutput,
    _$AdminCaptainProfileDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(String),
    );
    yield r'plateNumber';
    yield object.plateNumber == null
        ? null
        : serializers.serialize(
            object.plateNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputStatusEnum),
    );
    yield r'suspension';
    yield object.suspension == null
        ? null
        : serializers.serialize(
            object.suspension,
            specifiedType: const FullType.nullable(
              AdminCaptainProfileDtoOutputSuspension,
            ),
          );
    yield r'applicationId';
    yield object.applicationId == null
        ? null
        : serializers.serialize(
            object.applicationId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'contractPhase';
    yield object.contractPhase == null
        ? null
        : serializers.serialize(
            object.contractPhase,
            specifiedType: const FullType.nullable(
              AdminCaptainProfileDtoOutputContractPhaseEnum,
            ),
          );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputCustody),
    );
    yield r'earnings';
    yield serializers.serialize(
      object.earnings,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputEarnings),
    );
    yield r'ordersToday';
    yield serializers.serialize(
      object.ordersToday,
      specifiedType: const FullType(int),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
    yield r'onTime';
    yield serializers.serialize(
      object.onTime,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputOnTime),
    );
    yield r'cancellations';
    yield serializers.serialize(
      object.cancellations,
      specifiedType: const FullType(int),
    );
    yield r'acceptance';
    yield object.acceptance == null
        ? null
        : serializers.serialize(
            object.acceptance,
            specifiedType: const FullType.nullable(
              AdminCaptainListDtoOutputCaptainsInnerAcceptance,
            ),
          );
    yield r'rating';
    yield object.rating == null
        ? null
        : serializers.serialize(
            object.rating,
            specifiedType: const FullType.nullable(
              AdminCaptainProfileDtoOutputRating,
            ),
          );
    yield r'app';
    yield serializers.serialize(
      object.app,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputApp),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminCaptainProfileDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.vehicle = valueDes;
          break;
        case r'plateNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.plateNumber = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputStatusEnum,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'suspension':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainProfileDtoOutputSuspension,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputSuspension?;
          if (valueDes == null) continue;
          result.suspension.replace(valueDes);
          break;
        case r'applicationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.applicationId = valueDes;
          break;
        case r'contractPhase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainProfileDtoOutputContractPhaseEnum,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputContractPhaseEnum?;
          if (valueDes == null) continue;
          result.contractPhase = valueDes;
          break;
        case r'custody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputCustody,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputCustody;
          result.custody.replace(valueDes);
          break;
        case r'earnings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputEarnings,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputEarnings;
          result.earnings.replace(valueDes);
          break;
        case r'ordersToday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ordersToday = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        case r'onTime':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputOnTime,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputOnTime;
          result.onTime.replace(valueDes);
          break;
        case r'cancellations':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.cancellations = valueDes;
          break;
        case r'acceptance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListDtoOutputCaptainsInnerAcceptance,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerAcceptance?;
          if (valueDes == null) continue;
          result.acceptance.replace(valueDes);
          break;
        case r'rating':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainProfileDtoOutputRating,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputRating?;
          if (valueDes == null) continue;
          result.rating.replace(valueDes);
          break;
        case r'app':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputApp,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputApp;
          result.app.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class AdminCaptainProfileDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'online')
  static const AdminCaptainProfileDtoOutputStatusEnum online =
      _$adminCaptainProfileDtoOutputStatusEnum_online;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminCaptainProfileDtoOutputStatusEnum busy =
      _$adminCaptainProfileDtoOutputStatusEnum_busy;
  @BuiltValueEnumConst(wireName: r'offline')
  static const AdminCaptainProfileDtoOutputStatusEnum offline =
      _$adminCaptainProfileDtoOutputStatusEnum_offline;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainProfileDtoOutputStatusEnum suspended =
      _$adminCaptainProfileDtoOutputStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'cash_blocked')
  static const AdminCaptainProfileDtoOutputStatusEnum cashBlocked =
      _$adminCaptainProfileDtoOutputStatusEnum_cashBlocked;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminCaptainProfileDtoOutputStatusEnum terminated =
      _$adminCaptainProfileDtoOutputStatusEnum_terminated;

  static Serializer<AdminCaptainProfileDtoOutputStatusEnum> get serializer =>
      _$adminCaptainProfileDtoOutputStatusEnumSerializer;

  const AdminCaptainProfileDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainProfileDtoOutputStatusEnum> get values =>
      _$adminCaptainProfileDtoOutputStatusEnumValues;
  static AdminCaptainProfileDtoOutputStatusEnum valueOf(String name) =>
      _$adminCaptainProfileDtoOutputStatusEnumValueOf(name);
}

class AdminCaptainProfileDtoOutputContractPhaseEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'probation')
  static const AdminCaptainProfileDtoOutputContractPhaseEnum probation =
      _$adminCaptainProfileDtoOutputContractPhaseEnum_probation;
  @BuiltValueEnumConst(wireName: r'commitment')
  static const AdminCaptainProfileDtoOutputContractPhaseEnum commitment =
      _$adminCaptainProfileDtoOutputContractPhaseEnum_commitment;
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminCaptainProfileDtoOutputContractPhaseEnum open =
      _$adminCaptainProfileDtoOutputContractPhaseEnum_open;

  static Serializer<AdminCaptainProfileDtoOutputContractPhaseEnum>
  get serializer => _$adminCaptainProfileDtoOutputContractPhaseEnumSerializer;

  const AdminCaptainProfileDtoOutputContractPhaseEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainProfileDtoOutputContractPhaseEnum> get values =>
      _$adminCaptainProfileDtoOutputContractPhaseEnumValues;
  static AdminCaptainProfileDtoOutputContractPhaseEnum valueOf(String name) =>
      _$adminCaptainProfileDtoOutputContractPhaseEnumValueOf(name);
}
