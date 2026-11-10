//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_acknowledge_edit_dto.g.dart';

/// MerchantAcknowledgeEditDto
///
/// Properties:
/// * [through] - The newest edit's `at` the prompt showed: the edits up to it are acknowledged, a newer one keeps ringing (RA §8.13).
@BuiltValue()
abstract class MerchantAcknowledgeEditDto
    implements
        Built<MerchantAcknowledgeEditDto, MerchantAcknowledgeEditDtoBuilder> {
  /// The newest edit's `at` the prompt showed: the edits up to it are acknowledged, a newer one keeps ringing (RA §8.13).
  @BuiltValueField(wireName: r'through')
  DateTime get through;

  MerchantAcknowledgeEditDto._();

  factory MerchantAcknowledgeEditDto([
    void updates(MerchantAcknowledgeEditDtoBuilder b),
  ]) = _$MerchantAcknowledgeEditDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAcknowledgeEditDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAcknowledgeEditDto> get serializer =>
      _$MerchantAcknowledgeEditDtoSerializer();
}

class _$MerchantAcknowledgeEditDtoSerializer
    implements PrimitiveSerializer<MerchantAcknowledgeEditDto> {
  @override
  final Iterable<Type> types = const [
    MerchantAcknowledgeEditDto,
    _$MerchantAcknowledgeEditDto,
  ];

  @override
  final String wireName = r'MerchantAcknowledgeEditDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAcknowledgeEditDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'through';
    yield serializers.serialize(
      object.through,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAcknowledgeEditDto object, {
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
    required MerchantAcknowledgeEditDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'through':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.through = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAcknowledgeEditDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAcknowledgeEditDtoBuilder();
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
