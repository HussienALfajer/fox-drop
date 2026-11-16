//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_overdue_dto_output_overdue.g.dart';

/// What is overdue, or null when nothing is.
///
/// Properties:
/// * [amount] - What is still unpaid merchant.settlement_overdue_days after its settlement day.
/// * [statementDate] - The settlement day of the oldest statement still unpaid, on the city's clock.
/// * [currency]
@BuiltValue()
abstract class MerchantOverdueDtoOutputOverdue
    implements
        Built<
          MerchantOverdueDtoOutputOverdue,
          MerchantOverdueDtoOutputOverdueBuilder
        > {
  /// What is still unpaid merchant.settlement_overdue_days after its settlement day.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// The settlement day of the oldest statement still unpaid, on the city's clock.
  @BuiltValueField(wireName: r'statementDate')
  Date get statementDate;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  MerchantOverdueDtoOutputOverdue._();

  factory MerchantOverdueDtoOutputOverdue([
    void updates(MerchantOverdueDtoOutputOverdueBuilder b),
  ]) = _$MerchantOverdueDtoOutputOverdue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOverdueDtoOutputOverdueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOverdueDtoOutputOverdue> get serializer =>
      _$MerchantOverdueDtoOutputOverdueSerializer();
}

class _$MerchantOverdueDtoOutputOverdueSerializer
    implements PrimitiveSerializer<MerchantOverdueDtoOutputOverdue> {
  @override
  final Iterable<Type> types = const [
    MerchantOverdueDtoOutputOverdue,
    _$MerchantOverdueDtoOutputOverdue,
  ];

  @override
  final String wireName = r'MerchantOverdueDtoOutputOverdue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOverdueDtoOutputOverdue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'statementDate';
    yield serializers.serialize(
      object.statementDate,
      specifiedType: const FullType(Date),
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
    MerchantOverdueDtoOutputOverdue object, {
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
    required MerchantOverdueDtoOutputOverdueBuilder result,
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
        case r'statementDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.statementDate = valueDes;
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
  MerchantOverdueDtoOutputOverdue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOverdueDtoOutputOverdueBuilder();
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
