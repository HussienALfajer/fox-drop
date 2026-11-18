//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_operations_dto_minimum_order.g.dart';

/// AdminDraftOperationsDtoMinimumOrder
///
/// Properties:
/// * [amount] - Integer minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class AdminDraftOperationsDtoMinimumOrder
    implements
        Built<
          AdminDraftOperationsDtoMinimumOrder,
          AdminDraftOperationsDtoMinimumOrderBuilder
        > {
  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminDraftOperationsDtoMinimumOrder._();

  factory AdminDraftOperationsDtoMinimumOrder([
    void updates(AdminDraftOperationsDtoMinimumOrderBuilder b),
  ]) = _$AdminDraftOperationsDtoMinimumOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftOperationsDtoMinimumOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftOperationsDtoMinimumOrder> get serializer =>
      _$AdminDraftOperationsDtoMinimumOrderSerializer();
}

class _$AdminDraftOperationsDtoMinimumOrderSerializer
    implements PrimitiveSerializer<AdminDraftOperationsDtoMinimumOrder> {
  @override
  final Iterable<Type> types = const [
    AdminDraftOperationsDtoMinimumOrder,
    _$AdminDraftOperationsDtoMinimumOrder,
  ];

  @override
  final String wireName = r'AdminDraftOperationsDtoMinimumOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftOperationsDtoMinimumOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoMinimumOrder object, {
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
    required AdminDraftOperationsDtoMinimumOrderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftOperationsDtoMinimumOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftOperationsDtoMinimumOrderBuilder();
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
