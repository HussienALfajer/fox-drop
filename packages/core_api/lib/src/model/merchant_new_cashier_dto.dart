//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_new_cashier_dto.g.dart';

/// MerchantNewCashierDto
///
/// Properties:
/// * [name]
/// * [phone] - A mobile of any country in E.164, as at sign-in.
@BuiltValue()
abstract class MerchantNewCashierDto
    implements Built<MerchantNewCashierDto, MerchantNewCashierDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// A mobile of any country in E.164, as at sign-in.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  MerchantNewCashierDto._();

  factory MerchantNewCashierDto([
    void updates(MerchantNewCashierDtoBuilder b),
  ]) = _$MerchantNewCashierDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantNewCashierDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantNewCashierDto> get serializer =>
      _$MerchantNewCashierDtoSerializer();
}

class _$MerchantNewCashierDtoSerializer
    implements PrimitiveSerializer<MerchantNewCashierDto> {
  @override
  final Iterable<Type> types = const [
    MerchantNewCashierDto,
    _$MerchantNewCashierDto,
  ];

  @override
  final String wireName = r'MerchantNewCashierDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantNewCashierDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantNewCashierDto object, {
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
    required MerchantNewCashierDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantNewCashierDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantNewCashierDtoBuilder();
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
