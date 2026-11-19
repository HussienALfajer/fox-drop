//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_dto_output_application_rejection.g.dart';

/// CaptainApplicationDtoOutputApplicationRejection
///
/// Properties:
/// * [reason]
/// * [at]
/// * [reapplyFrom] - A new application from then (K11).
@BuiltValue()
abstract class CaptainApplicationDtoOutputApplicationRejection
    implements
        Built<
          CaptainApplicationDtoOutputApplicationRejection,
          CaptainApplicationDtoOutputApplicationRejectionBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// A new application from then (K11).
  @BuiltValueField(wireName: r'reapplyFrom')
  DateTime get reapplyFrom;

  CaptainApplicationDtoOutputApplicationRejection._();

  factory CaptainApplicationDtoOutputApplicationRejection([
    void updates(CaptainApplicationDtoOutputApplicationRejectionBuilder b),
  ]) = _$CaptainApplicationDtoOutputApplicationRejection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainApplicationDtoOutputApplicationRejectionBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDtoOutputApplicationRejection>
  get serializer =>
      _$CaptainApplicationDtoOutputApplicationRejectionSerializer();
}

class _$CaptainApplicationDtoOutputApplicationRejectionSerializer
    implements
        PrimitiveSerializer<CaptainApplicationDtoOutputApplicationRejection> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDtoOutputApplicationRejection,
    _$CaptainApplicationDtoOutputApplicationRejection,
  ];

  @override
  final String wireName = r'CaptainApplicationDtoOutputApplicationRejection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationRejection object, {
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
    CaptainApplicationDtoOutputApplicationRejection object, {
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
    required CaptainApplicationDtoOutputApplicationRejectionBuilder result,
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
  CaptainApplicationDtoOutputApplicationRejection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationDtoOutputApplicationRejectionBuilder();
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
