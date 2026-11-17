//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_compensation_requests_dto_output_requests_inner_reason.g.dart';

/// A reason of Content's item_unavailable_note list, its label as chosen.
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class AdminCompensationRequestsDtoOutputRequestsInnerReason
    implements
        Built<
          AdminCompensationRequestsDtoOutputRequestsInnerReason,
          AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  AdminCompensationRequestsDtoOutputRequestsInnerReason._();

  factory AdminCompensationRequestsDtoOutputRequestsInnerReason([
    void updates(
      AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder b,
    ),
  ]) = _$AdminCompensationRequestsDtoOutputRequestsInnerReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCompensationRequestsDtoOutputRequestsInnerReason>
  get serializer =>
      _$AdminCompensationRequestsDtoOutputRequestsInnerReasonSerializer();
}

class _$AdminCompensationRequestsDtoOutputRequestsInnerReasonSerializer
    implements
        PrimitiveSerializer<
          AdminCompensationRequestsDtoOutputRequestsInnerReason
        > {
  @override
  final Iterable<Type> types = const [
    AdminCompensationRequestsDtoOutputRequestsInnerReason,
    _$AdminCompensationRequestsDtoOutputRequestsInnerReason,
  ];

  @override
  final String wireName =
      r'AdminCompensationRequestsDtoOutputRequestsInnerReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCompensationRequestsDtoOutputRequestsInnerReason object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensationRequestsDtoOutputRequestsInnerReason object, {
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
    required AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder
    result,
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCompensationRequestsDtoOutputRequestsInnerReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder();
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
