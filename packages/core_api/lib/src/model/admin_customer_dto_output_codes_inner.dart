//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_codes_inner.g.dart';

/// AdminCustomerDtoOutputCodesInner
///
/// Properties:
/// * [code]
/// * [kind]
/// * [orderId]
/// * [currency]
/// * [discount]
/// * [status] - held, spent, or returned (given back).
/// * [heldAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputCodesInner
    implements
        Built<
          AdminCustomerDtoOutputCodesInner,
          AdminCustomerDtoOutputCodesInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'discount')
  String get discount;

  /// held, spent, or returned (given back).
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'heldAt')
  DateTime get heldAt;

  AdminCustomerDtoOutputCodesInner._();

  factory AdminCustomerDtoOutputCodesInner([
    void updates(AdminCustomerDtoOutputCodesInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputCodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputCodesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputCodesInner> get serializer =>
      _$AdminCustomerDtoOutputCodesInnerSerializer();
}

class _$AdminCustomerDtoOutputCodesInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputCodesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputCodesInner,
    _$AdminCustomerDtoOutputCodesInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputCodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputCodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'heldAt';
    yield serializers.serialize(
      object.heldAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputCodesInner object, {
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
    required AdminCustomerDtoOutputCodesInnerBuilder result,
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.kind = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'discount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discount = valueDes;
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
        case r'heldAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.heldAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputCodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputCodesInnerBuilder();
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
