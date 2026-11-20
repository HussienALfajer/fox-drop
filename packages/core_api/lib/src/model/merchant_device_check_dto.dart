//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_device_check_dto.g.dart';

/// MerchantDeviceCheckDto
///
/// Properties:
/// * [failed] - The checks of RA §4.5 that failed; empty when all passed.
/// * [delayMs] - Check 8: the server connection’s delay, or null when it failed.
@BuiltValue()
abstract class MerchantDeviceCheckDto
    implements Built<MerchantDeviceCheckDto, MerchantDeviceCheckDtoBuilder> {
  /// The checks of RA §4.5 that failed; empty when all passed.
  @BuiltValueField(wireName: r'failed')
  BuiltList<MerchantDeviceCheckDtoFailedEnum> get failed;
  // enum failedEnum {  notifications,  battery,  autostart,  full_screen,  alarm_volume,  sleep,  test_ring,  connection,  };

  /// Check 8: the server connection’s delay, or null when it failed.
  @BuiltValueField(wireName: r'delayMs')
  int? get delayMs;

  MerchantDeviceCheckDto._();

  factory MerchantDeviceCheckDto([
    void updates(MerchantDeviceCheckDtoBuilder b),
  ]) = _$MerchantDeviceCheckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDeviceCheckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDeviceCheckDto> get serializer =>
      _$MerchantDeviceCheckDtoSerializer();
}

class _$MerchantDeviceCheckDtoSerializer
    implements PrimitiveSerializer<MerchantDeviceCheckDto> {
  @override
  final Iterable<Type> types = const [
    MerchantDeviceCheckDto,
    _$MerchantDeviceCheckDto,
  ];

  @override
  final String wireName = r'MerchantDeviceCheckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDeviceCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantDeviceCheckDtoFailedEnum),
      ]),
    );
    yield r'delayMs';
    yield object.delayMs == null
        ? null
        : serializers.serialize(
            object.delayMs,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceCheckDto object, {
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
    required MerchantDeviceCheckDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'failed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantDeviceCheckDtoFailedEnum),
                    ]),
                  )
                  as BuiltList<MerchantDeviceCheckDtoFailedEnum>;
          result.failed.replace(valueDes);
          break;
        case r'delayMs':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.delayMs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantDeviceCheckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDeviceCheckDtoBuilder();
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

class MerchantDeviceCheckDtoFailedEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'notifications')
  static const MerchantDeviceCheckDtoFailedEnum notifications =
      _$merchantDeviceCheckDtoFailedEnum_notifications;
  @BuiltValueEnumConst(wireName: r'battery')
  static const MerchantDeviceCheckDtoFailedEnum battery =
      _$merchantDeviceCheckDtoFailedEnum_battery;
  @BuiltValueEnumConst(wireName: r'autostart')
  static const MerchantDeviceCheckDtoFailedEnum autostart =
      _$merchantDeviceCheckDtoFailedEnum_autostart;
  @BuiltValueEnumConst(wireName: r'full_screen')
  static const MerchantDeviceCheckDtoFailedEnum fullScreen =
      _$merchantDeviceCheckDtoFailedEnum_fullScreen;
  @BuiltValueEnumConst(wireName: r'alarm_volume')
  static const MerchantDeviceCheckDtoFailedEnum alarmVolume =
      _$merchantDeviceCheckDtoFailedEnum_alarmVolume;
  @BuiltValueEnumConst(wireName: r'sleep')
  static const MerchantDeviceCheckDtoFailedEnum sleep =
      _$merchantDeviceCheckDtoFailedEnum_sleep;
  @BuiltValueEnumConst(wireName: r'test_ring')
  static const MerchantDeviceCheckDtoFailedEnum testRing =
      _$merchantDeviceCheckDtoFailedEnum_testRing;
  @BuiltValueEnumConst(wireName: r'connection')
  static const MerchantDeviceCheckDtoFailedEnum connection =
      _$merchantDeviceCheckDtoFailedEnum_connection;

  static Serializer<MerchantDeviceCheckDtoFailedEnum> get serializer =>
      _$merchantDeviceCheckDtoFailedEnumSerializer;

  const MerchantDeviceCheckDtoFailedEnum._(String name) : super(name);

  static BuiltSet<MerchantDeviceCheckDtoFailedEnum> get values =>
      _$merchantDeviceCheckDtoFailedEnumValues;
  static MerchantDeviceCheckDtoFailedEnum valueOf(String name) =>
      _$merchantDeviceCheckDtoFailedEnumValueOf(name);
}
