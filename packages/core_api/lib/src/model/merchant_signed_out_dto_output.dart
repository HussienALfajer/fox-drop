//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_signed_out_dto_output.g.dart';

/// MerchantSignedOutDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class MerchantSignedOutDtoOutput
    implements
        Built<MerchantSignedOutDtoOutput, MerchantSignedOutDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  MerchantSignedOutDtoOutputStatusEnum get status;
  // enum statusEnum {  signed_out,  };

  MerchantSignedOutDtoOutput._();

  factory MerchantSignedOutDtoOutput([
    void updates(MerchantSignedOutDtoOutputBuilder b),
  ]) = _$MerchantSignedOutDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantSignedOutDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantSignedOutDtoOutput> get serializer =>
      _$MerchantSignedOutDtoOutputSerializer();
}

class _$MerchantSignedOutDtoOutputSerializer
    implements PrimitiveSerializer<MerchantSignedOutDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantSignedOutDtoOutput,
    _$MerchantSignedOutDtoOutput,
  ];

  @override
  final String wireName = r'MerchantSignedOutDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MerchantSignedOutDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantSignedOutDtoOutput object, {
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
    required MerchantSignedOutDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantSignedOutDtoOutputStatusEnum,
                    ),
                  )
                  as MerchantSignedOutDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantSignedOutDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantSignedOutDtoOutputBuilder();
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

class MerchantSignedOutDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'signed_out')
  static const MerchantSignedOutDtoOutputStatusEnum signedOut =
      _$merchantSignedOutDtoOutputStatusEnum_signedOut;

  static Serializer<MerchantSignedOutDtoOutputStatusEnum> get serializer =>
      _$merchantSignedOutDtoOutputStatusEnumSerializer;

  const MerchantSignedOutDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<MerchantSignedOutDtoOutputStatusEnum> get values =>
      _$merchantSignedOutDtoOutputStatusEnumValues;
  static MerchantSignedOutDtoOutputStatusEnum valueOf(String name) =>
      _$merchantSignedOutDtoOutputStatusEnumValueOf(name);
}
