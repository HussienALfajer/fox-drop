//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_account_state_dto_output_dues.g.dart';

/// «عليك {المبلغ} لـ FOX DROP. ادفعه في المكتب ليُفك الحظر تلقائياً.» in the city of the point (AP §8.8).
///
/// Properties:
/// * [amount] - Minor units, above zero.
/// * [currency]
@BuiltValue()
abstract class CustomerAccountStateDtoOutputDues
    implements
        Built<
          CustomerAccountStateDtoOutputDues,
          CustomerAccountStateDtoOutputDuesBuilder
        > {
  /// Minor units, above zero.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CustomerAccountStateDtoOutputDues._();

  factory CustomerAccountStateDtoOutputDues([
    void updates(CustomerAccountStateDtoOutputDuesBuilder b),
  ]) = _$CustomerAccountStateDtoOutputDues;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAccountStateDtoOutputDuesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAccountStateDtoOutputDues> get serializer =>
      _$CustomerAccountStateDtoOutputDuesSerializer();
}

class _$CustomerAccountStateDtoOutputDuesSerializer
    implements PrimitiveSerializer<CustomerAccountStateDtoOutputDues> {
  @override
  final Iterable<Type> types = const [
    CustomerAccountStateDtoOutputDues,
    _$CustomerAccountStateDtoOutputDues,
  ];

  @override
  final String wireName = r'CustomerAccountStateDtoOutputDues';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAccountStateDtoOutputDues object, {
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
    CustomerAccountStateDtoOutputDues object, {
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
    required CustomerAccountStateDtoOutputDuesBuilder result,
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
  CustomerAccountStateDtoOutputDues deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAccountStateDtoOutputDuesBuilder();
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
