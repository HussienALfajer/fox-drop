//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_rejection.g.dart';

/// AdminCaptainApplicationDtoOutputRejection
///
/// Properties:
/// * [reason]
/// * [at]
/// * [reapplyFrom]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputRejection
    implements
        Built<
          AdminCaptainApplicationDtoOutputRejection,
          AdminCaptainApplicationDtoOutputRejectionBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'reapplyFrom')
  DateTime get reapplyFrom;

  AdminCaptainApplicationDtoOutputRejection._();

  factory AdminCaptainApplicationDtoOutputRejection([
    void updates(AdminCaptainApplicationDtoOutputRejectionBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputRejection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationDtoOutputRejectionBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputRejection> get serializer =>
      _$AdminCaptainApplicationDtoOutputRejectionSerializer();
}

class _$AdminCaptainApplicationDtoOutputRejectionSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationDtoOutputRejection> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputRejection,
    _$AdminCaptainApplicationDtoOutputRejection,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputRejection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputRejection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'reapplyFrom';
    yield serializers.serialize(
      object.reapplyFrom,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputRejection object, {
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
    required AdminCaptainApplicationDtoOutputRejectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
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
        case r'reapplyFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.reapplyFrom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputRejection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputRejectionBuilder();
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
