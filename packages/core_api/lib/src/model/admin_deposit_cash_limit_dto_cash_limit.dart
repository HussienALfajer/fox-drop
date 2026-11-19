//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposit_cash_limit_dto_cash_limit.g.dart';

/// In the city's base currency.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminDepositCashLimitDtoCashLimit
    implements
        Built<
          AdminDepositCashLimitDtoCashLimit,
          AdminDepositCashLimitDtoCashLimitBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminDepositCashLimitDtoCashLimit._();

  factory AdminDepositCashLimitDtoCashLimit([
    void updates(AdminDepositCashLimitDtoCashLimitBuilder b),
  ]) = _$AdminDepositCashLimitDtoCashLimit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDepositCashLimitDtoCashLimitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositCashLimitDtoCashLimit> get serializer =>
      _$AdminDepositCashLimitDtoCashLimitSerializer();
}

class _$AdminDepositCashLimitDtoCashLimitSerializer
    implements PrimitiveSerializer<AdminDepositCashLimitDtoCashLimit> {
  @override
  final Iterable<Type> types = const [
    AdminDepositCashLimitDtoCashLimit,
    _$AdminDepositCashLimitDtoCashLimit,
  ];

  @override
  final String wireName = r'AdminDepositCashLimitDtoCashLimit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositCashLimitDtoCashLimit object, {
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
    AdminDepositCashLimitDtoCashLimit object, {
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
    required AdminDepositCashLimitDtoCashLimitBuilder result,
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
  AdminDepositCashLimitDtoCashLimit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositCashLimitDtoCashLimitBuilder();
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
