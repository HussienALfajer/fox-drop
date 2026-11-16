//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_compensate_dto_reason.g.dart';

/// AdminCompensateDtoReason
///
/// Properties:
/// * [code]
/// * [note]
@BuiltValue()
abstract class AdminCompensateDtoReason
    implements
        Built<AdminCompensateDtoReason, AdminCompensateDtoReasonBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminCompensateDtoReason._();

  factory AdminCompensateDtoReason([
    void updates(AdminCompensateDtoReasonBuilder b),
  ]) = _$AdminCompensateDtoReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCompensateDtoReasonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCompensateDtoReason> get serializer =>
      _$AdminCompensateDtoReasonSerializer();
}

class _$AdminCompensateDtoReasonSerializer
    implements PrimitiveSerializer<AdminCompensateDtoReason> {
  @override
  final Iterable<Type> types = const [
    AdminCompensateDtoReason,
    _$AdminCompensateDtoReason,
  ];

  @override
  final String wireName = r'AdminCompensateDtoReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCompensateDtoReason object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensateDtoReason object, {
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
    required AdminCompensateDtoReasonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCompensateDtoReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCompensateDtoReasonBuilder();
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
