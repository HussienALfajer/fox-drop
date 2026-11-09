//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_settings_dto.g.dart';

/// MerchantOrderSettingsDto
///
/// Properties:
/// * [defaultPrepMin] - Within prepFloorMin and prepCeilingMin.
/// * [maxActiveOrders] - Off (null) or 1 to 50.
@BuiltValue()
abstract class MerchantOrderSettingsDto
    implements
        Built<MerchantOrderSettingsDto, MerchantOrderSettingsDtoBuilder> {
  /// Within prepFloorMin and prepCeilingMin.
  @BuiltValueField(wireName: r'defaultPrepMin')
  int get defaultPrepMin;

  /// Off (null) or 1 to 50.
  @BuiltValueField(wireName: r'maxActiveOrders')
  int? get maxActiveOrders;

  MerchantOrderSettingsDto._();

  factory MerchantOrderSettingsDto([
    void updates(MerchantOrderSettingsDtoBuilder b),
  ]) = _$MerchantOrderSettingsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderSettingsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderSettingsDto> get serializer =>
      _$MerchantOrderSettingsDtoSerializer();
}

class _$MerchantOrderSettingsDtoSerializer
    implements PrimitiveSerializer<MerchantOrderSettingsDto> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderSettingsDto,
    _$MerchantOrderSettingsDto,
  ];

  @override
  final String wireName = r'MerchantOrderSettingsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderSettingsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'defaultPrepMin';
    yield serializers.serialize(
      object.defaultPrepMin,
      specifiedType: const FullType(int),
    );
    yield r'maxActiveOrders';
    yield object.maxActiveOrders == null
        ? null
        : serializers.serialize(
            object.maxActiveOrders,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderSettingsDto object, {
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
    required MerchantOrderSettingsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'defaultPrepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.defaultPrepMin = valueDes;
          break;
        case r'maxActiveOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxActiveOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrderSettingsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderSettingsDtoBuilder();
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
