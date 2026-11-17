//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_problem_body_dto.g.dart';

/// MerchantOrderProblemBodyDto
///
/// Properties:
/// * [reasonCode] - A code of Content's merchant_problem list (RA Appendix C).
/// * [note] - Optional, up to 300 characters; the text of «أخرى».
@BuiltValue()
abstract class MerchantOrderProblemBodyDto
    implements
        Built<MerchantOrderProblemBodyDto, MerchantOrderProblemBodyDtoBuilder> {
  /// A code of Content's merchant_problem list (RA Appendix C).
  @BuiltValueField(wireName: r'reasonCode')
  String get reasonCode;

  /// Optional, up to 300 characters; the text of «أخرى».
  @BuiltValueField(wireName: r'note')
  String? get note;

  MerchantOrderProblemBodyDto._();

  factory MerchantOrderProblemBodyDto([
    void updates(MerchantOrderProblemBodyDtoBuilder b),
  ]) = _$MerchantOrderProblemBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderProblemBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderProblemBodyDto> get serializer =>
      _$MerchantOrderProblemBodyDtoSerializer();
}

class _$MerchantOrderProblemBodyDtoSerializer
    implements PrimitiveSerializer<MerchantOrderProblemBodyDto> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderProblemBodyDto,
    _$MerchantOrderProblemBodyDto,
  ];

  @override
  final String wireName = r'MerchantOrderProblemBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderProblemBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasonCode';
    yield serializers.serialize(
      object.reasonCode,
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
    MerchantOrderProblemBodyDto object, {
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
    required MerchantOrderProblemBodyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasonCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reasonCode = valueDes;
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
  MerchantOrderProblemBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderProblemBodyDtoBuilder();
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
