//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_statement_list_dto_output_statements_inner_payout.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_statement_list_dto_output_statements_inner.g.dart';

/// CaptainStatementListDtoOutputStatementsInner
///
/// Properties:
/// * [id]
/// * [createdAt]
/// * [periodFrom] - The previous payout, null for the first.
/// * [currency] - The city's base currency.
/// * [orders]
/// * [paid] - In the base.
/// * [payout]
/// * [carriedOut] - Carried to the next week.
@BuiltValue()
abstract class CaptainStatementListDtoOutputStatementsInner
    implements
        Built<
          CaptainStatementListDtoOutputStatementsInner,
          CaptainStatementListDtoOutputStatementsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// The previous payout, null for the first.
  @BuiltValueField(wireName: r'periodFrom')
  DateTime? get periodFrom;

  /// The city's base currency.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  /// In the base.
  @BuiltValueField(wireName: r'paid')
  String get paid;

  @BuiltValueField(wireName: r'payout')
  CaptainStatementListDtoOutputStatementsInnerPayout? get payout;

  /// Carried to the next week.
  @BuiltValueField(wireName: r'carriedOut')
  String get carriedOut;

  CaptainStatementListDtoOutputStatementsInner._();

  factory CaptainStatementListDtoOutputStatementsInner([
    void updates(CaptainStatementListDtoOutputStatementsInnerBuilder b),
  ]) = _$CaptainStatementListDtoOutputStatementsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainStatementListDtoOutputStatementsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainStatementListDtoOutputStatementsInner>
  get serializer => _$CaptainStatementListDtoOutputStatementsInnerSerializer();
}

class _$CaptainStatementListDtoOutputStatementsInnerSerializer
    implements
        PrimitiveSerializer<CaptainStatementListDtoOutputStatementsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainStatementListDtoOutputStatementsInner,
    _$CaptainStatementListDtoOutputStatementsInner,
  ];

  @override
  final String wireName = r'CaptainStatementListDtoOutputStatementsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainStatementListDtoOutputStatementsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'periodFrom';
    yield object.periodFrom == null
        ? null
        : serializers.serialize(
            object.periodFrom,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'paid';
    yield serializers.serialize(
      object.paid,
      specifiedType: const FullType(String),
    );
    yield r'payout';
    yield object.payout == null
        ? null
        : serializers.serialize(
            object.payout,
            specifiedType: const FullType.nullable(
              CaptainStatementListDtoOutputStatementsInnerPayout,
            ),
          );
    yield r'carriedOut';
    yield serializers.serialize(
      object.carriedOut,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainStatementListDtoOutputStatementsInner object, {
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
    required CaptainStatementListDtoOutputStatementsInnerBuilder result,
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
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'periodFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.periodFrom = valueDes;
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
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'paid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.paid = valueDes;
          break;
        case r'payout':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainStatementListDtoOutputStatementsInnerPayout,
                    ),
                  )
                  as CaptainStatementListDtoOutputStatementsInnerPayout?;
          if (valueDes == null) continue;
          result.payout.replace(valueDes);
          break;
        case r'carriedOut':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.carriedOut = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainStatementListDtoOutputStatementsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainStatementListDtoOutputStatementsInnerBuilder();
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
