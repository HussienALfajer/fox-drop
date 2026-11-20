//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_signed_out_dto_output.g.dart';

/// MerchantPortalSignedOutDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class MerchantPortalSignedOutDtoOutput
    implements
        Built<
          MerchantPortalSignedOutDtoOutput,
          MerchantPortalSignedOutDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  MerchantPortalSignedOutDtoOutputStatusEnum get status;
  // enum statusEnum {  signed_out,  };

  MerchantPortalSignedOutDtoOutput._();

  factory MerchantPortalSignedOutDtoOutput([
    void updates(MerchantPortalSignedOutDtoOutputBuilder b),
  ]) = _$MerchantPortalSignedOutDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalSignedOutDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalSignedOutDtoOutput> get serializer =>
      _$MerchantPortalSignedOutDtoOutputSerializer();
}

class _$MerchantPortalSignedOutDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPortalSignedOutDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalSignedOutDtoOutput,
    _$MerchantPortalSignedOutDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPortalSignedOutDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MerchantPortalSignedOutDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSignedOutDtoOutput object, {
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
    required MerchantPortalSignedOutDtoOutputBuilder result,
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
                      MerchantPortalSignedOutDtoOutputStatusEnum,
                    ),
                  )
                  as MerchantPortalSignedOutDtoOutputStatusEnum;
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
  MerchantPortalSignedOutDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalSignedOutDtoOutputBuilder();
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

class MerchantPortalSignedOutDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'signed_out')
  static const MerchantPortalSignedOutDtoOutputStatusEnum signedOut =
      _$merchantPortalSignedOutDtoOutputStatusEnum_signedOut;

  static Serializer<MerchantPortalSignedOutDtoOutputStatusEnum>
  get serializer => _$merchantPortalSignedOutDtoOutputStatusEnumSerializer;

  const MerchantPortalSignedOutDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<MerchantPortalSignedOutDtoOutputStatusEnum> get values =>
      _$merchantPortalSignedOutDtoOutputStatusEnumValues;
  static MerchantPortalSignedOutDtoOutputStatusEnum valueOf(String name) =>
      _$merchantPortalSignedOutDtoOutputStatusEnumValueOf(name);
}
