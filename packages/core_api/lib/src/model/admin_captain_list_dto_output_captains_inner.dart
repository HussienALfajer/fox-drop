//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_acceptance.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_earnings.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_custody.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_list_dto_output_captains_inner.g.dart';

/// AdminCaptainListDtoOutputCaptainsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [maskedPhone]
/// * [vehicle]
/// * [plateNumber]
/// * [status]
/// * [applicationId]
/// * [contractPhase]
/// * [custody]
/// * [earnings]
/// * [ordersToday]
/// * [acceptance]
/// * [ratingAverage]
/// * [ratingCount]
@BuiltValue()
abstract class AdminCaptainListDtoOutputCaptainsInner
    implements
        Built<
          AdminCaptainListDtoOutputCaptainsInner,
          AdminCaptainListDtoOutputCaptainsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'maskedPhone')
  String? get maskedPhone;

  @BuiltValueField(wireName: r'vehicle')
  String get vehicle;

  @BuiltValueField(wireName: r'plateNumber')
  String? get plateNumber;

  @BuiltValueField(wireName: r'status')
  AdminCaptainListDtoOutputCaptainsInnerStatusEnum get status;
  // enum statusEnum {  online,  busy,  offline,  suspended,  cash_blocked,  terminated,  };

  @BuiltValueField(wireName: r'applicationId')
  String? get applicationId;

  @BuiltValueField(wireName: r'contractPhase')
  AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum? get contractPhase;
  // enum contractPhaseEnum {  probation,  commitment,  open,  };

  @BuiltValueField(wireName: r'custody')
  AdminCaptainListDtoOutputCaptainsInnerCustody get custody;

  @BuiltValueField(wireName: r'earnings')
  AdminCaptainListDtoOutputCaptainsInnerEarnings get earnings;

  @BuiltValueField(wireName: r'ordersToday')
  int get ordersToday;

  @BuiltValueField(wireName: r'acceptance')
  AdminCaptainListDtoOutputCaptainsInnerAcceptance? get acceptance;

  @BuiltValueField(wireName: r'ratingAverage')
  num? get ratingAverage;

  @BuiltValueField(wireName: r'ratingCount')
  int get ratingCount;

  AdminCaptainListDtoOutputCaptainsInner._();

  factory AdminCaptainListDtoOutputCaptainsInner([
    void updates(AdminCaptainListDtoOutputCaptainsInnerBuilder b),
  ]) = _$AdminCaptainListDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainListDtoOutputCaptainsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainListDtoOutputCaptainsInner> get serializer =>
      _$AdminCaptainListDtoOutputCaptainsInnerSerializer();
}

class _$AdminCaptainListDtoOutputCaptainsInnerSerializer
    implements PrimitiveSerializer<AdminCaptainListDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainListDtoOutputCaptainsInner,
    _$AdminCaptainListDtoOutputCaptainsInner,
  ];

  @override
  final String wireName = r'AdminCaptainListDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'maskedPhone';
    yield object.maskedPhone == null
        ? null
        : serializers.serialize(
            object.maskedPhone,
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
      specifiedType: const FullType(
        AdminCaptainListDtoOutputCaptainsInnerStatusEnum,
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
              AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum,
            ),
          );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(
        AdminCaptainListDtoOutputCaptainsInnerCustody,
      ),
    );
    yield r'earnings';
    yield serializers.serialize(
      object.earnings,
      specifiedType: const FullType(
        AdminCaptainListDtoOutputCaptainsInnerEarnings,
      ),
    );
    yield r'ordersToday';
    yield serializers.serialize(
      object.ordersToday,
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
    yield r'ratingAverage';
    yield object.ratingAverage == null
        ? null
        : serializers.serialize(
            object.ratingAverage,
            specifiedType: const FullType.nullable(num),
          );
    yield r'ratingCount';
    yield serializers.serialize(
      object.ratingCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInner object, {
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
    required AdminCaptainListDtoOutputCaptainsInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'maskedPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maskedPhone = valueDes;
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
                      AdminCaptainListDtoOutputCaptainsInnerStatusEnum,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerStatusEnum;
          result.status = valueDes;
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
                      AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum?;
          if (valueDes == null) continue;
          result.contractPhase = valueDes;
          break;
        case r'custody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainListDtoOutputCaptainsInnerCustody,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustody;
          result.custody.replace(valueDes);
          break;
        case r'earnings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainListDtoOutputCaptainsInnerEarnings,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerEarnings;
          result.earnings.replace(valueDes);
          break;
        case r'ordersToday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ordersToday = valueDes;
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
        case r'ratingAverage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.ratingAverage = valueDes;
          break;
        case r'ratingCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ratingCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainListDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainListDtoOutputCaptainsInnerBuilder();
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

class AdminCaptainListDtoOutputCaptainsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'online')
  static const AdminCaptainListDtoOutputCaptainsInnerStatusEnum online =
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_online;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminCaptainListDtoOutputCaptainsInnerStatusEnum busy =
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_busy;
  @BuiltValueEnumConst(wireName: r'offline')
  static const AdminCaptainListDtoOutputCaptainsInnerStatusEnum offline =
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_offline;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainListDtoOutputCaptainsInnerStatusEnum suspended =
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'cash_blocked')
  static const AdminCaptainListDtoOutputCaptainsInnerStatusEnum cashBlocked =
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_cashBlocked;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminCaptainListDtoOutputCaptainsInnerStatusEnum terminated =
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_terminated;

  static Serializer<AdminCaptainListDtoOutputCaptainsInnerStatusEnum>
  get serializer =>
      _$adminCaptainListDtoOutputCaptainsInnerStatusEnumSerializer;

  const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainListDtoOutputCaptainsInnerStatusEnum>
  get values => _$adminCaptainListDtoOutputCaptainsInnerStatusEnumValues;
  static AdminCaptainListDtoOutputCaptainsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCaptainListDtoOutputCaptainsInnerStatusEnumValueOf(name);
}

class AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'probation')
  static const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
  probation =
      _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_probation;
  @BuiltValueEnumConst(wireName: r'commitment')
  static const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
  commitment =
      _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_commitment;
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum open =
      _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_open;

  static Serializer<AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum>
  get serializer =>
      _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnumSerializer;

  const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum>
  get values => _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnumValues;
  static AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum valueOf(
    String name,
  ) => _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnumValueOf(name);
}
