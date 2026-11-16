//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_dto_compensation_reason.g.dart';

/// AdminCancelDtoCompensationReason
///
/// Properties:
/// * [code]
/// * [note]
@BuiltValue()
abstract class AdminCancelDtoCompensationReason
    implements
        Built<
          AdminCancelDtoCompensationReason,
          AdminCancelDtoCompensationReasonBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminCancelDtoCompensationReason._();

  factory AdminCancelDtoCompensationReason([
    void updates(AdminCancelDtoCompensationReasonBuilder b),
  ]) = _$AdminCancelDtoCompensationReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancelDtoCompensationReasonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelDtoCompensationReason> get serializer =>
      _$AdminCancelDtoCompensationReasonSerializer();
}

class _$AdminCancelDtoCompensationReasonSerializer
    implements PrimitiveSerializer<AdminCancelDtoCompensationReason> {
  @override
  final Iterable<Type> types = const [
    AdminCancelDtoCompensationReason,
    _$AdminCancelDtoCompensationReason,
  ];

  @override
  final String wireName = r'AdminCancelDtoCompensationReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelDtoCompensationReason object, {
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
    AdminCancelDtoCompensationReason object, {
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
    required AdminCancelDtoCompensationReasonBuilder result,
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
  AdminCancelDtoCompensationReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelDtoCompensationReasonBuilder();
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
