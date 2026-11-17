//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_orders_last.g.dart';

/// AdminCustomerDtoOutputOrdersLast
///
/// Properties:
/// * [id]
/// * [number]
/// * [status]
/// * [placedAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputOrdersLast
    implements
        Built<
          AdminCustomerDtoOutputOrdersLast,
          AdminCustomerDtoOutputOrdersLastBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  AdminCustomerDtoOutputOrdersLast._();

  factory AdminCustomerDtoOutputOrdersLast([
    void updates(AdminCustomerDtoOutputOrdersLastBuilder b),
  ]) = _$AdminCustomerDtoOutputOrdersLast;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputOrdersLastBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputOrdersLast> get serializer =>
      _$AdminCustomerDtoOutputOrdersLastSerializer();
}

class _$AdminCustomerDtoOutputOrdersLastSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputOrdersLast> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputOrdersLast,
    _$AdminCustomerDtoOutputOrdersLast,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputOrdersLast';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputOrdersLast object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputOrdersLast object, {
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
    required AdminCustomerDtoOutputOrdersLastBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.status = valueDes;
          break;
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputOrdersLast deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputOrdersLastBuilder();
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
