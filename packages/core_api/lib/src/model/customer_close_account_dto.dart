//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_close_account_dto.g.dart';

/// CustomerCloseAccountDto
///
/// Properties:
/// * [code]
@BuiltValue()
abstract class CustomerCloseAccountDto
    implements Built<CustomerCloseAccountDto, CustomerCloseAccountDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  CustomerCloseAccountDto._();

  factory CustomerCloseAccountDto([
    void updates(CustomerCloseAccountDtoBuilder b),
  ]) = _$CustomerCloseAccountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCloseAccountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCloseAccountDto> get serializer =>
      _$CustomerCloseAccountDtoSerializer();
}

class _$CustomerCloseAccountDtoSerializer
    implements PrimitiveSerializer<CustomerCloseAccountDto> {
  @override
  final Iterable<Type> types = const [
    CustomerCloseAccountDto,
    _$CustomerCloseAccountDto,
  ];

  @override
  final String wireName = r'CustomerCloseAccountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCloseAccountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCloseAccountDto object, {
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
    required CustomerCloseAccountDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCloseAccountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCloseAccountDtoBuilder();
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
