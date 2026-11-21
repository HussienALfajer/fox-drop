//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_customer_contact_dto.g.dart';

/// CaptainCustomerContactDto
///
/// Properties:
/// * [channel] - «اتصال بالزبون» (`call`) or «واتساب الزبون» (`whatsapp`).
@BuiltValue()
abstract class CaptainCustomerContactDto
    implements
        Built<CaptainCustomerContactDto, CaptainCustomerContactDtoBuilder> {
  /// «اتصال بالزبون» (`call`) or «واتساب الزبون» (`whatsapp`).
  @BuiltValueField(wireName: r'channel')
  CaptainCustomerContactDtoChannelEnum get channel;
  // enum channelEnum {  call,  whatsapp,  };

  CaptainCustomerContactDto._();

  factory CaptainCustomerContactDto([
    void updates(CaptainCustomerContactDtoBuilder b),
  ]) = _$CaptainCustomerContactDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCustomerContactDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustomerContactDto> get serializer =>
      _$CaptainCustomerContactDtoSerializer();
}

class _$CaptainCustomerContactDtoSerializer
    implements PrimitiveSerializer<CaptainCustomerContactDto> {
  @override
  final Iterable<Type> types = const [
    CaptainCustomerContactDto,
    _$CaptainCustomerContactDto,
  ];

  @override
  final String wireName = r'CaptainCustomerContactDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustomerContactDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(CaptainCustomerContactDtoChannelEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustomerContactDto object, {
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
    required CaptainCustomerContactDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCustomerContactDtoChannelEnum,
                    ),
                  )
                  as CaptainCustomerContactDtoChannelEnum;
          result.channel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCustomerContactDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCustomerContactDtoBuilder();
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

/// «اتصال بالزبون» (`call`) or «واتساب الزبون» (`whatsapp`).
class CaptainCustomerContactDtoChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'call')
  static const CaptainCustomerContactDtoChannelEnum call =
      _$captainCustomerContactDtoChannelEnum_call;
  @BuiltValueEnumConst(wireName: r'whatsapp')
  static const CaptainCustomerContactDtoChannelEnum whatsapp =
      _$captainCustomerContactDtoChannelEnum_whatsapp;

  static Serializer<CaptainCustomerContactDtoChannelEnum> get serializer =>
      _$captainCustomerContactDtoChannelEnumSerializer;

  const CaptainCustomerContactDtoChannelEnum._(String name) : super(name);

  static BuiltSet<CaptainCustomerContactDtoChannelEnum> get values =>
      _$captainCustomerContactDtoChannelEnumValues;
  static CaptainCustomerContactDtoChannelEnum valueOf(String name) =>
      _$captainCustomerContactDtoChannelEnumValueOf(name);
}
