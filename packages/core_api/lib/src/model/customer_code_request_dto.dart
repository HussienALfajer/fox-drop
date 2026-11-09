//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_code_request_dto.g.dart';

/// CustomerCodeRequestDto
///
/// Properties:
/// * [phone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [deviceId] - The app installation, generated once by the app and kept until it is removed.
@BuiltValue()
abstract class CustomerCodeRequestDto
    implements Built<CustomerCodeRequestDto, CustomerCodeRequestDtoBuilder> {
  /// The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The app installation, generated once by the app and kept until it is removed.
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  CustomerCodeRequestDto._();

  factory CustomerCodeRequestDto([
    void updates(CustomerCodeRequestDtoBuilder b),
  ]) = _$CustomerCodeRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCodeRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCodeRequestDto> get serializer =>
      _$CustomerCodeRequestDtoSerializer();
}

class _$CustomerCodeRequestDtoSerializer
    implements PrimitiveSerializer<CustomerCodeRequestDto> {
  @override
  final Iterable<Type> types = const [
    CustomerCodeRequestDto,
    _$CustomerCodeRequestDto,
  ];

  @override
  final String wireName = r'CustomerCodeRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodeRequestDto object, {
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
    required CustomerCodeRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        case r'deviceId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCodeRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCodeRequestDtoBuilder();
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
