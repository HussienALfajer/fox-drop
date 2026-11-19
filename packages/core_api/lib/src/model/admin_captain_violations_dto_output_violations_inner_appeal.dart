//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output_violations_inner_appeal.g.dart';

/// The captain's «اعتراض»; an accepted one voids the violation.
///
/// Properties:
/// * [ticketId]
/// * [at]
/// * [outcome]
/// * [decidedAt]
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutputViolationsInnerAppeal
    implements
        Built<
          AdminCaptainViolationsDtoOutputViolationsInnerAppeal,
          AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder
        > {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'outcome')
  AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum? get outcome;
  // enum outcomeEnum {  accepted,  rejected,  };

  @BuiltValueField(wireName: r'decidedAt')
  DateTime? get decidedAt;

  AdminCaptainViolationsDtoOutputViolationsInnerAppeal._();

  factory AdminCaptainViolationsDtoOutputViolationsInnerAppeal([
    void updates(AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutputViolationsInnerAppeal>
  get serializer =>
      _$AdminCaptainViolationsDtoOutputViolationsInnerAppealSerializer();
}

class _$AdminCaptainViolationsDtoOutputViolationsInnerAppealSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainViolationsDtoOutputViolationsInnerAppeal
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutputViolationsInnerAppeal,
    _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal,
  ];

  @override
  final String wireName =
      r'AdminCaptainViolationsDtoOutputViolationsInnerAppeal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputViolationsInnerAppeal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum,
            ),
          );
    yield r'decidedAt';
    yield object.decidedAt == null
        ? null
        : serializers.serialize(
            object.decidedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputViolationsInnerAppeal object, {
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
    required AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ticketId = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'decidedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainViolationsDtoOutputViolationsInnerAppeal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder();
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

class AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
  accepted =
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_accepted;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
  rejected =
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_rejected;

  static Serializer<
    AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
  >
  get serializer =>
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumSerializer;

  const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
  >
  get values =>
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumValues;
  static AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
  valueOf(String name) =>
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumValueOf(
        name,
      );
}
