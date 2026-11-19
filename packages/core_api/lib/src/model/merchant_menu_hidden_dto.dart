//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_hidden_dto.g.dart';

/// MerchantMenuHiddenDto
///
/// Properties:
/// * [hidden]
@BuiltValue()
abstract class MerchantMenuHiddenDto
    implements Built<MerchantMenuHiddenDto, MerchantMenuHiddenDtoBuilder> {
  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  MerchantMenuHiddenDto._();

  factory MerchantMenuHiddenDto([
    void updates(MerchantMenuHiddenDtoBuilder b),
  ]) = _$MerchantMenuHiddenDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuHiddenDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuHiddenDto> get serializer =>
      _$MerchantMenuHiddenDtoSerializer();
}

class _$MerchantMenuHiddenDtoSerializer
    implements PrimitiveSerializer<MerchantMenuHiddenDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuHiddenDto,
    _$MerchantMenuHiddenDto,
  ];

  @override
  final String wireName = r'MerchantMenuHiddenDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuHiddenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'hidden';
    yield serializers.serialize(
      object.hidden,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuHiddenDto object, {
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
    required MerchantMenuHiddenDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hidden':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.hidden = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuHiddenDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuHiddenDtoBuilder();
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
