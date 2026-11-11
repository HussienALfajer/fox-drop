//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_cannot_complete.g.dart';

/// «لا أستطيع إكمال الطلب» (CA §9.11, slice 2.13b): the captain's open request, «بانتظار العمليات» with «تراجع»; every step stays open. Null without one.
///
/// Properties:
/// * [reason] - The captain_cannot_complete reason's label as chosen.
/// * [note] - The text of «أخرى».
/// * [at]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderCannotComplete
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderCannotComplete,
          CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder
        > {
  /// The captain_cannot_complete reason's label as chosen.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The text of «أخرى».
  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputOrderCannotComplete._();

  factory CaptainActiveOrderDtoOutputOrderCannotComplete([
    void updates(CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderCannotComplete;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderCannotComplete>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderCannotCompleteSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderCannotCompleteSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderCannotComplete> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderCannotComplete,
    _$CaptainActiveOrderDtoOutputOrderCannotComplete,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderCannotComplete';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCannotComplete object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCannotComplete object, {
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
    required CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder result,
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
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderCannotComplete deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder();
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
