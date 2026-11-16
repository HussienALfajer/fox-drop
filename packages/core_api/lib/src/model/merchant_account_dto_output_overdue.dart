//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account_dto_output_overdue.g.dart';

/// «متأخر: {المبلغ} من كشف {التاريخ}» (RA §12.6), or null when nothing is overdue.
///
/// Properties:
/// * [amount] - What is still unpaid merchant.settlement_overdue_days after its settlement day.
/// * [statementDate] - The settlement day of the oldest statement still unpaid, on the city's clock.
@BuiltValue()
abstract class MerchantAccountDtoOutputOverdue
    implements
        Built<
          MerchantAccountDtoOutputOverdue,
          MerchantAccountDtoOutputOverdueBuilder
        > {
  /// What is still unpaid merchant.settlement_overdue_days after its settlement day.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// The settlement day of the oldest statement still unpaid, on the city's clock.
  @BuiltValueField(wireName: r'statementDate')
  Date get statementDate;

  MerchantAccountDtoOutputOverdue._();

  factory MerchantAccountDtoOutputOverdue([
    void updates(MerchantAccountDtoOutputOverdueBuilder b),
  ]) = _$MerchantAccountDtoOutputOverdue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountDtoOutputOverdueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccountDtoOutputOverdue> get serializer =>
      _$MerchantAccountDtoOutputOverdueSerializer();
}

class _$MerchantAccountDtoOutputOverdueSerializer
    implements PrimitiveSerializer<MerchantAccountDtoOutputOverdue> {
  @override
  final Iterable<Type> types = const [
    MerchantAccountDtoOutputOverdue,
    _$MerchantAccountDtoOutputOverdue,
  ];

  @override
  final String wireName = r'MerchantAccountDtoOutputOverdue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccountDtoOutputOverdue object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAccountDtoOutputOverdue object, {
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
    required MerchantAccountDtoOutputOverdueBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAccountDtoOutputOverdue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountDtoOutputOverdueBuilder();
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
