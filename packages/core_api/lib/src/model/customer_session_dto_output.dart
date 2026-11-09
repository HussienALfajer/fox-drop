//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_session_dto_output.g.dart';

/// CustomerSessionDtoOutput
///
/// Properties:
/// * [accountId] 
/// * [sessionId] 
@BuiltValue()
abstract class CustomerSessionDtoOutput implements Built<CustomerSessionDtoOutput, CustomerSessionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  CustomerSessionDtoOutput._();

  factory CustomerSessionDtoOutput([void updates(CustomerSessionDtoOutputBuilder b)]) = _$CustomerSessionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSessionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSessionDtoOutput> get serializer => _$CustomerSessionDtoOutputSerializer();
}

class _$CustomerSessionDtoOutputSerializer implements PrimitiveSerializer<CustomerSessionDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerSessionDtoOutput, _$CustomerSessionDtoOutput];

  @override
  final String wireName = r'CustomerSessionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerSessionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountId = valueDes;
          break;
        case r'sessionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSessionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSessionDtoOutputBuilder();
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


