//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_device_saved_dto_output.g.dart';

/// MerchantDeviceSavedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class MerchantDeviceSavedDtoOutput
    implements
        Built<
          MerchantDeviceSavedDtoOutput,
          MerchantDeviceSavedDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  MerchantDeviceSavedDtoOutputStatusEnum get status;
  // enum statusEnum {  saved,  };

  MerchantDeviceSavedDtoOutput._();

  factory MerchantDeviceSavedDtoOutput([
    void updates(MerchantDeviceSavedDtoOutputBuilder b),
  ]) = _$MerchantDeviceSavedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDeviceSavedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDeviceSavedDtoOutput> get serializer =>
      _$MerchantDeviceSavedDtoOutputSerializer();
}

class _$MerchantDeviceSavedDtoOutputSerializer
    implements PrimitiveSerializer<MerchantDeviceSavedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantDeviceSavedDtoOutput,
    _$MerchantDeviceSavedDtoOutput,
  ];

  @override
  final String wireName = r'MerchantDeviceSavedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDeviceSavedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MerchantDeviceSavedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceSavedDtoOutput object, {
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
    required MerchantDeviceSavedDtoOutputBuilder result,
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
                      MerchantDeviceSavedDtoOutputStatusEnum,
                    ),
                  )
                  as MerchantDeviceSavedDtoOutputStatusEnum;
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
  MerchantDeviceSavedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDeviceSavedDtoOutputBuilder();
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

class MerchantDeviceSavedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'saved')
  static const MerchantDeviceSavedDtoOutputStatusEnum saved =
      _$merchantDeviceSavedDtoOutputStatusEnum_saved;

  static Serializer<MerchantDeviceSavedDtoOutputStatusEnum> get serializer =>
      _$merchantDeviceSavedDtoOutputStatusEnumSerializer;

  const MerchantDeviceSavedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<MerchantDeviceSavedDtoOutputStatusEnum> get values =>
      _$merchantDeviceSavedDtoOutputStatusEnumValues;
  static MerchantDeviceSavedDtoOutputStatusEnum valueOf(String name) =>
      _$merchantDeviceSavedDtoOutputStatusEnumValueOf(name);
}
