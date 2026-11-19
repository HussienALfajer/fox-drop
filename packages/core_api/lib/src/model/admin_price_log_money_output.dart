//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_price_log_money_output.g.dart';

/// AdminPriceLogMoneyOutput
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminPriceLogMoneyOutput
    implements
        Built<AdminPriceLogMoneyOutput, AdminPriceLogMoneyOutputBuilder> {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminPriceLogMoneyOutput._();

  factory AdminPriceLogMoneyOutput([
    void updates(AdminPriceLogMoneyOutputBuilder b),
  ]) = _$AdminPriceLogMoneyOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPriceLogMoneyOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPriceLogMoneyOutput> get serializer =>
      _$AdminPriceLogMoneyOutputSerializer();
}

class _$AdminPriceLogMoneyOutputSerializer
    implements PrimitiveSerializer<AdminPriceLogMoneyOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPriceLogMoneyOutput,
    _$AdminPriceLogMoneyOutput,
  ];

  @override
  final String wireName = r'AdminPriceLogMoneyOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPriceLogMoneyOutput object, {
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
    AdminPriceLogMoneyOutput object, {
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
    required AdminPriceLogMoneyOutputBuilder result,
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
  AdminPriceLogMoneyOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPriceLogMoneyOutputBuilder();
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
