//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_violation_dto.g.dart';

/// AdminRecordViolationDto
///
/// Properties:
/// * [severe] - The type is from the severe list.
/// * [typeCode]
/// * [typeNote]
/// * [step] - The step the admin confirms (the suggestion or another).
/// * [orderId] - One of the captain's orders, or null.
/// * [reason]
@BuiltValue()
abstract class AdminRecordViolationDto
    implements Built<AdminRecordViolationDto, AdminRecordViolationDtoBuilder> {
  /// The type is from the severe list.
  @BuiltValueField(wireName: r'severe')
  bool get severe;

  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  @BuiltValueField(wireName: r'typeNote')
  String? get typeNote;

  /// The step the admin confirms (the suggestion or another).
  @BuiltValueField(wireName: r'step')
  AdminRecordViolationDtoStepEnum get step;
  // enum stepEnum {  warning,  suspension_1d,  suspension_7d,  termination,  };

  /// One of the captain's orders, or null.
  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRecordViolationDto._();

  factory AdminRecordViolationDto([
    void updates(AdminRecordViolationDtoBuilder b),
  ]) = _$AdminRecordViolationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordViolationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordViolationDto> get serializer =>
      _$AdminRecordViolationDtoSerializer();
}

class _$AdminRecordViolationDtoSerializer
    implements PrimitiveSerializer<AdminRecordViolationDto> {
  @override
  final Iterable<Type> types = const [
    AdminRecordViolationDto,
    _$AdminRecordViolationDto,
  ];

  @override
  final String wireName = r'AdminRecordViolationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordViolationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'severe';
    yield serializers.serialize(
      object.severe,
      specifiedType: const FullType(bool),
    );
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'typeNote';
    yield object.typeNote == null
        ? null
        : serializers.serialize(
            object.typeNote,
            specifiedType: const FullType.nullable(String),
          );
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(AdminRecordViolationDtoStepEnum),
    );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordViolationDto object, {
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
    required AdminRecordViolationDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'severe':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.severe = valueDes;
          break;
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
          break;
        case r'typeNote':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.typeNote = valueDes;
          break;
        case r'step':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRecordViolationDtoStepEnum,
                    ),
                  )
                  as AdminRecordViolationDtoStepEnum;
          result.step = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRecordViolationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordViolationDtoBuilder();
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

/// The step the admin confirms (the suggestion or another).
class AdminRecordViolationDtoStepEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminRecordViolationDtoStepEnum warning =
      _$adminRecordViolationDtoStepEnum_warning;
  @BuiltValueEnumConst(wireName: r'suspension_1d')
  static const AdminRecordViolationDtoStepEnum suspension1d =
      _$adminRecordViolationDtoStepEnum_suspension1d;
  @BuiltValueEnumConst(wireName: r'suspension_7d')
  static const AdminRecordViolationDtoStepEnum suspension7d =
      _$adminRecordViolationDtoStepEnum_suspension7d;
  @BuiltValueEnumConst(wireName: r'termination')
  static const AdminRecordViolationDtoStepEnum termination =
      _$adminRecordViolationDtoStepEnum_termination;

  static Serializer<AdminRecordViolationDtoStepEnum> get serializer =>
      _$adminRecordViolationDtoStepEnumSerializer;

  const AdminRecordViolationDtoStepEnum._(String name) : super(name);

  static BuiltSet<AdminRecordViolationDtoStepEnum> get values =>
      _$adminRecordViolationDtoStepEnumValues;
  static AdminRecordViolationDtoStepEnum valueOf(String name) =>
      _$adminRecordViolationDtoStepEnumValueOf(name);
}
