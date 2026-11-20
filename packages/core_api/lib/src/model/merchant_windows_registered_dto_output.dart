//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_windows_registered_dto_output.g.dart';

/// MerchantWindowsRegisteredDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class MerchantWindowsRegisteredDtoOutput
    implements
        Built<
          MerchantWindowsRegisteredDtoOutput,
          MerchantWindowsRegisteredDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  MerchantWindowsRegisteredDtoOutputStatusEnum get status;
  // enum statusEnum {  registered,  };

  MerchantWindowsRegisteredDtoOutput._();

  factory MerchantWindowsRegisteredDtoOutput([
    void updates(MerchantWindowsRegisteredDtoOutputBuilder b),
  ]) = _$MerchantWindowsRegisteredDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantWindowsRegisteredDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantWindowsRegisteredDtoOutput> get serializer =>
      _$MerchantWindowsRegisteredDtoOutputSerializer();
}

class _$MerchantWindowsRegisteredDtoOutputSerializer
    implements PrimitiveSerializer<MerchantWindowsRegisteredDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantWindowsRegisteredDtoOutput,
    _$MerchantWindowsRegisteredDtoOutput,
  ];

  @override
  final String wireName = r'MerchantWindowsRegisteredDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantWindowsRegisteredDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        MerchantWindowsRegisteredDtoOutputStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantWindowsRegisteredDtoOutput object, {
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
    required MerchantWindowsRegisteredDtoOutputBuilder result,
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
                      MerchantWindowsRegisteredDtoOutputStatusEnum,
                    ),
                  )
                  as MerchantWindowsRegisteredDtoOutputStatusEnum;
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
  MerchantWindowsRegisteredDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantWindowsRegisteredDtoOutputBuilder();
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

class MerchantWindowsRegisteredDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'registered')
  static const MerchantWindowsRegisteredDtoOutputStatusEnum registered =
      _$merchantWindowsRegisteredDtoOutputStatusEnum_registered;

  static Serializer<MerchantWindowsRegisteredDtoOutputStatusEnum>
  get serializer => _$merchantWindowsRegisteredDtoOutputStatusEnumSerializer;

  const MerchantWindowsRegisteredDtoOutputStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantWindowsRegisteredDtoOutputStatusEnum> get values =>
      _$merchantWindowsRegisteredDtoOutputStatusEnumValues;
  static MerchantWindowsRegisteredDtoOutputStatusEnum valueOf(String name) =>
      _$merchantWindowsRegisteredDtoOutputStatusEnumValueOf(name);
}
