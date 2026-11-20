//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_device_report_dto.g.dart';

/// MerchantDeviceReportDto
///
/// Properties:
/// * [appVersion]
/// * [ringing] - «الرنين على هذا الجهاز» (RA §4.4), an owner’s setting; ignored for a cashier, whose device always rings; null leaves it as it is.
@BuiltValue()
abstract class MerchantDeviceReportDto
    implements Built<MerchantDeviceReportDto, MerchantDeviceReportDtoBuilder> {
  @BuiltValueField(wireName: r'appVersion')
  String get appVersion;

  /// «الرنين على هذا الجهاز» (RA §4.4), an owner’s setting; ignored for a cashier, whose device always rings; null leaves it as it is.
  @BuiltValueField(wireName: r'ringing')
  bool? get ringing;

  MerchantDeviceReportDto._();

  factory MerchantDeviceReportDto([
    void updates(MerchantDeviceReportDtoBuilder b),
  ]) = _$MerchantDeviceReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDeviceReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDeviceReportDto> get serializer =>
      _$MerchantDeviceReportDtoSerializer();
}

class _$MerchantDeviceReportDtoSerializer
    implements PrimitiveSerializer<MerchantDeviceReportDto> {
  @override
  final Iterable<Type> types = const [
    MerchantDeviceReportDto,
    _$MerchantDeviceReportDto,
  ];

  @override
  final String wireName = r'MerchantDeviceReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDeviceReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'appVersion';
    yield serializers.serialize(
      object.appVersion,
      specifiedType: const FullType(String),
    );
    yield r'ringing';
    yield object.ringing == null
        ? null
        : serializers.serialize(
            object.ringing,
            specifiedType: const FullType.nullable(bool),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceReportDto object, {
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
    required MerchantDeviceReportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'appVersion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.appVersion = valueDes;
          break;
        case r'ringing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.ringing = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantDeviceReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDeviceReportDtoBuilder();
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
