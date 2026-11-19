//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_activation_contract.g.dart';

/// AdminCaptainApplicationDtoOutputActivationContract
///
/// Properties:
/// * [signedOn]
/// * [startsOn]
/// * [probationDays]
/// * [commitmentMonths]
/// * [probationEndsOn]
/// * [commitmentStartsOn] - As confirmed, or expected on the probation end.
/// * [commitmentEndsOn]
/// * [probationConfirmedOn]
/// * [phase]
/// * [review] - The probation review: due from its notice, overdue past its end.
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputActivationContract
    implements
        Built<
          AdminCaptainApplicationDtoOutputActivationContract,
          AdminCaptainApplicationDtoOutputActivationContractBuilder
        > {
  @BuiltValueField(wireName: r'signedOn')
  Date get signedOn;

  @BuiltValueField(wireName: r'startsOn')
  Date get startsOn;

  @BuiltValueField(wireName: r'probationDays')
  int get probationDays;

  @BuiltValueField(wireName: r'commitmentMonths')
  int get commitmentMonths;

  @BuiltValueField(wireName: r'probationEndsOn')
  Date get probationEndsOn;

  /// As confirmed, or expected on the probation end.
  @BuiltValueField(wireName: r'commitmentStartsOn')
  Date get commitmentStartsOn;

  @BuiltValueField(wireName: r'commitmentEndsOn')
  Date get commitmentEndsOn;

  @BuiltValueField(wireName: r'probationConfirmedOn')
  Date? get probationConfirmedOn;

  @BuiltValueField(wireName: r'phase')
  AdminCaptainApplicationDtoOutputActivationContractPhaseEnum get phase;
  // enum phaseEnum {  probation,  commitment,  open,  };

  /// The probation review: due from its notice, overdue past its end.
  @BuiltValueField(wireName: r'review')
  AdminCaptainApplicationDtoOutputActivationContractReviewEnum get review;
  // enum reviewEnum {  none,  due,  overdue,  };

  AdminCaptainApplicationDtoOutputActivationContract._();

  factory AdminCaptainApplicationDtoOutputActivationContract([
    void updates(AdminCaptainApplicationDtoOutputActivationContractBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputActivationContract;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputActivationContractBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputActivationContract>
  get serializer =>
      _$AdminCaptainApplicationDtoOutputActivationContractSerializer();
}

class _$AdminCaptainApplicationDtoOutputActivationContractSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputActivationContract
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputActivationContract,
    _$AdminCaptainApplicationDtoOutputActivationContract,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputActivationContract';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationContract object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedOn';
    yield serializers.serialize(
      object.signedOn,
      specifiedType: const FullType(Date),
    );
    yield r'startsOn';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(Date),
    );
    yield r'probationDays';
    yield serializers.serialize(
      object.probationDays,
      specifiedType: const FullType(int),
    );
    yield r'commitmentMonths';
    yield serializers.serialize(
      object.commitmentMonths,
      specifiedType: const FullType(int),
    );
    yield r'probationEndsOn';
    yield serializers.serialize(
      object.probationEndsOn,
      specifiedType: const FullType(Date),
    );
    yield r'commitmentStartsOn';
    yield serializers.serialize(
      object.commitmentStartsOn,
      specifiedType: const FullType(Date),
    );
    yield r'commitmentEndsOn';
    yield serializers.serialize(
      object.commitmentEndsOn,
      specifiedType: const FullType(Date),
    );
    yield r'probationConfirmedOn';
    yield object.probationConfirmedOn == null
        ? null
        : serializers.serialize(
            object.probationConfirmedOn,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'phase';
    yield serializers.serialize(
      object.phase,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputActivationContractPhaseEnum,
      ),
    );
    yield r'review';
    yield serializers.serialize(
      object.review,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputActivationContractReviewEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationContract object, {
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
    required AdminCaptainApplicationDtoOutputActivationContractBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.signedOn = valueDes;
          break;
        case r'startsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.startsOn = valueDes;
          break;
        case r'probationDays':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.probationDays = valueDes;
          break;
        case r'commitmentMonths':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.commitmentMonths = valueDes;
          break;
        case r'probationEndsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.probationEndsOn = valueDes;
          break;
        case r'commitmentStartsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.commitmentStartsOn = valueDes;
          break;
        case r'commitmentEndsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.commitmentEndsOn = valueDes;
          break;
        case r'probationConfirmedOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.probationConfirmedOn = valueDes;
          break;
        case r'phase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputActivationContractPhaseEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationContractPhaseEnum;
          result.phase = valueDes;
          break;
        case r'review':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputActivationContractReviewEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationContractReviewEnum;
          result.review = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputActivationContract deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputActivationContractBuilder();
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

class AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'probation')
  static const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
  probation =
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_probation;
  @BuiltValueEnumConst(wireName: r'commitment')
  static const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
  commitment =
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_commitment;
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
  open = _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_open;

  static Serializer<AdminCaptainApplicationDtoOutputActivationContractPhaseEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnumSerializer;

  const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputActivationContractPhaseEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnumValues;
  static AdminCaptainApplicationDtoOutputActivationContractPhaseEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputActivationContractPhaseEnumValueOf(
    name,
  );
}

/// The probation review: due from its notice, overdue past its end.
class AdminCaptainApplicationDtoOutputActivationContractReviewEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const AdminCaptainApplicationDtoOutputActivationContractReviewEnum
  none = _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_none;
  @BuiltValueEnumConst(wireName: r'due')
  static const AdminCaptainApplicationDtoOutputActivationContractReviewEnum
  due = _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_due;
  @BuiltValueEnumConst(wireName: r'overdue')
  static const AdminCaptainApplicationDtoOutputActivationContractReviewEnum
  overdue =
      _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_overdue;

  static Serializer<
    AdminCaptainApplicationDtoOutputActivationContractReviewEnum
  >
  get serializer =>
      _$adminCaptainApplicationDtoOutputActivationContractReviewEnumSerializer;

  const AdminCaptainApplicationDtoOutputActivationContractReviewEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputActivationContractReviewEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputActivationContractReviewEnumValues;
  static AdminCaptainApplicationDtoOutputActivationContractReviewEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputActivationContractReviewEnumValueOf(
    name,
  );
}
