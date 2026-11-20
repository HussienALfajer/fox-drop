//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_device_check_output.g.dart';

/// MerchantDeviceCheckOutput
///
/// Properties:
/// * [at]
/// * [passed] - No failed item but `sleep`, a warning only.
/// * [failed]
/// * [delayMs]
@BuiltValue()
abstract class MerchantDeviceCheckOutput
    implements
        Built<MerchantDeviceCheckOutput, MerchantDeviceCheckOutputBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// No failed item but `sleep`, a warning only.
  @BuiltValueField(wireName: r'passed')
  bool get passed;

  @BuiltValueField(wireName: r'failed')
  BuiltList<MerchantDeviceCheckOutputFailedEnum> get failed;
  // enum failedEnum {  notifications,  battery,  autostart,  full_screen,  alarm_volume,  sleep,  test_ring,  connection,  };

  @BuiltValueField(wireName: r'delayMs')
  int? get delayMs;

  MerchantDeviceCheckOutput._();

  factory MerchantDeviceCheckOutput([
    void updates(MerchantDeviceCheckOutputBuilder b),
  ]) = _$MerchantDeviceCheckOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDeviceCheckOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDeviceCheckOutput> get serializer =>
      _$MerchantDeviceCheckOutputSerializer();
}

class _$MerchantDeviceCheckOutputSerializer
    implements PrimitiveSerializer<MerchantDeviceCheckOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantDeviceCheckOutput,
    _$MerchantDeviceCheckOutput,
  ];

  @override
  final String wireName = r'MerchantDeviceCheckOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDeviceCheckOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'passed';
    yield serializers.serialize(
      object.passed,
      specifiedType: const FullType(bool),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantDeviceCheckOutputFailedEnum),
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
    MerchantDeviceCheckOutput object, {
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
    required MerchantDeviceCheckOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'passed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.passed = valueDes;
          break;
        case r'failed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantDeviceCheckOutputFailedEnum),
                    ]),
                  )
                  as BuiltList<MerchantDeviceCheckOutputFailedEnum>;
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
  MerchantDeviceCheckOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDeviceCheckOutputBuilder();
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

class MerchantDeviceCheckOutputFailedEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'notifications')
  static const MerchantDeviceCheckOutputFailedEnum notifications =
      _$merchantDeviceCheckOutputFailedEnum_notifications;
  @BuiltValueEnumConst(wireName: r'battery')
  static const MerchantDeviceCheckOutputFailedEnum battery =
      _$merchantDeviceCheckOutputFailedEnum_battery;
  @BuiltValueEnumConst(wireName: r'autostart')
  static const MerchantDeviceCheckOutputFailedEnum autostart =
      _$merchantDeviceCheckOutputFailedEnum_autostart;
  @BuiltValueEnumConst(wireName: r'full_screen')
  static const MerchantDeviceCheckOutputFailedEnum fullScreen =
      _$merchantDeviceCheckOutputFailedEnum_fullScreen;
  @BuiltValueEnumConst(wireName: r'alarm_volume')
  static const MerchantDeviceCheckOutputFailedEnum alarmVolume =
      _$merchantDeviceCheckOutputFailedEnum_alarmVolume;
  @BuiltValueEnumConst(wireName: r'sleep')
  static const MerchantDeviceCheckOutputFailedEnum sleep =
      _$merchantDeviceCheckOutputFailedEnum_sleep;
  @BuiltValueEnumConst(wireName: r'test_ring')
  static const MerchantDeviceCheckOutputFailedEnum testRing =
      _$merchantDeviceCheckOutputFailedEnum_testRing;
  @BuiltValueEnumConst(wireName: r'connection')
  static const MerchantDeviceCheckOutputFailedEnum connection =
      _$merchantDeviceCheckOutputFailedEnum_connection;

  static Serializer<MerchantDeviceCheckOutputFailedEnum> get serializer =>
      _$merchantDeviceCheckOutputFailedEnumSerializer;

  const MerchantDeviceCheckOutputFailedEnum._(String name) : super(name);

  static BuiltSet<MerchantDeviceCheckOutputFailedEnum> get values =>
      _$merchantDeviceCheckOutputFailedEnumValues;
  static MerchantDeviceCheckOutputFailedEnum valueOf(String name) =>
      _$merchantDeviceCheckOutputFailedEnumValueOf(name);
}
