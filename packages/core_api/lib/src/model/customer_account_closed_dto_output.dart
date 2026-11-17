//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_account_closed_dto_output.g.dart';

/// CustomerAccountClosedDtoOutput
///
/// Properties:
/// * [status] - Every session of the account ended; the app signs out (CU §5.6 item 4).
@BuiltValue()
abstract class CustomerAccountClosedDtoOutput
    implements
        Built<
          CustomerAccountClosedDtoOutput,
          CustomerAccountClosedDtoOutputBuilder
        > {
  /// Every session of the account ended; the app signs out (CU §5.6 item 4).
  @BuiltValueField(wireName: r'status')
  CustomerAccountClosedDtoOutputStatusEnum get status;
  // enum statusEnum {  closed,  };

  CustomerAccountClosedDtoOutput._();

  factory CustomerAccountClosedDtoOutput([
    void updates(CustomerAccountClosedDtoOutputBuilder b),
  ]) = _$CustomerAccountClosedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAccountClosedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAccountClosedDtoOutput> get serializer =>
      _$CustomerAccountClosedDtoOutputSerializer();
}

class _$CustomerAccountClosedDtoOutputSerializer
    implements PrimitiveSerializer<CustomerAccountClosedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerAccountClosedDtoOutput,
    _$CustomerAccountClosedDtoOutput,
  ];

  @override
  final String wireName = r'CustomerAccountClosedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAccountClosedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerAccountClosedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAccountClosedDtoOutput object, {
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
    required CustomerAccountClosedDtoOutputBuilder result,
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
                      CustomerAccountClosedDtoOutputStatusEnum,
                    ),
                  )
                  as CustomerAccountClosedDtoOutputStatusEnum;
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
  CustomerAccountClosedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAccountClosedDtoOutputBuilder();
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

/// Every session of the account ended; the app signs out (CU §5.6 item 4).
class CustomerAccountClosedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'closed')
  static const CustomerAccountClosedDtoOutputStatusEnum closed =
      _$customerAccountClosedDtoOutputStatusEnum_closed;

  static Serializer<CustomerAccountClosedDtoOutputStatusEnum> get serializer =>
      _$customerAccountClosedDtoOutputStatusEnumSerializer;

  const CustomerAccountClosedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<CustomerAccountClosedDtoOutputStatusEnum> get values =>
      _$customerAccountClosedDtoOutputStatusEnumValues;
  static CustomerAccountClosedDtoOutputStatusEnum valueOf(String name) =>
      _$customerAccountClosedDtoOutputStatusEnumValueOf(name);
}
