//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_statement_list_dto_output_statements_inner.g.dart';

/// MerchantStatementListDtoOutputStatementsInner
///
/// Properties:
/// * [id]
/// * [cutoff] - The settlement day’s cutoff that closed it.
/// * [periodFrom] - The previous statement’s cutoff, null for the first.
/// * [currency]
/// * [weekTotal] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [totalDue] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [status]
/// * [unpaid] - What of the total due is still unpaid, oldest first.
@BuiltValue()
abstract class MerchantStatementListDtoOutputStatementsInner
    implements
        Built<
          MerchantStatementListDtoOutputStatementsInner,
          MerchantStatementListDtoOutputStatementsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The settlement day’s cutoff that closed it.
  @BuiltValueField(wireName: r'cutoff')
  DateTime get cutoff;

  /// The previous statement’s cutoff, null for the first.
  @BuiltValueField(wireName: r'periodFrom')
  DateTime? get periodFrom;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'weekTotal')
  String get weekTotal;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'totalDue')
  String get totalDue;

  @BuiltValueField(wireName: r'status')
  MerchantStatementListDtoOutputStatementsInnerStatusEnum? get status;
  // enum statusEnum {  unpaid,  partly_paid,  paid,  };

  /// What of the total due is still unpaid, oldest first.
  @BuiltValueField(wireName: r'unpaid')
  String get unpaid;

  MerchantStatementListDtoOutputStatementsInner._();

  factory MerchantStatementListDtoOutputStatementsInner([
    void updates(MerchantStatementListDtoOutputStatementsInnerBuilder b),
  ]) = _$MerchantStatementListDtoOutputStatementsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantStatementListDtoOutputStatementsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatementListDtoOutputStatementsInner>
  get serializer => _$MerchantStatementListDtoOutputStatementsInnerSerializer();
}

class _$MerchantStatementListDtoOutputStatementsInnerSerializer
    implements
        PrimitiveSerializer<MerchantStatementListDtoOutputStatementsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantStatementListDtoOutputStatementsInner,
    _$MerchantStatementListDtoOutputStatementsInner,
  ];

  @override
  final String wireName = r'MerchantStatementListDtoOutputStatementsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatementListDtoOutputStatementsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cutoff';
    yield serializers.serialize(
      object.cutoff,
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
    yield r'weekTotal';
    yield serializers.serialize(
      object.weekTotal,
      specifiedType: const FullType(String),
    );
    yield r'totalDue';
    yield serializers.serialize(
      object.totalDue,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield object.status == null
        ? null
        : serializers.serialize(
            object.status,
            specifiedType: const FullType.nullable(
              MerchantStatementListDtoOutputStatementsInnerStatusEnum,
            ),
          );
    yield r'unpaid';
    yield serializers.serialize(
      object.unpaid,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementListDtoOutputStatementsInner object, {
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
    required MerchantStatementListDtoOutputStatementsInnerBuilder result,
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
        case r'cutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.cutoff = valueDes;
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
        case r'weekTotal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.weekTotal = valueDes;
          break;
        case r'totalDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.totalDue = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatementListDtoOutputStatementsInnerStatusEnum,
                    ),
                  )
                  as MerchantStatementListDtoOutputStatementsInnerStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'unpaid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.unpaid = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatementListDtoOutputStatementsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatementListDtoOutputStatementsInnerBuilder();
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

class MerchantStatementListDtoOutputStatementsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'unpaid')
  static const MerchantStatementListDtoOutputStatementsInnerStatusEnum unpaid =
      _$merchantStatementListDtoOutputStatementsInnerStatusEnum_unpaid;
  @BuiltValueEnumConst(wireName: r'partly_paid')
  static const MerchantStatementListDtoOutputStatementsInnerStatusEnum
  partlyPaid =
      _$merchantStatementListDtoOutputStatementsInnerStatusEnum_partlyPaid;
  @BuiltValueEnumConst(wireName: r'paid')
  static const MerchantStatementListDtoOutputStatementsInnerStatusEnum paid =
      _$merchantStatementListDtoOutputStatementsInnerStatusEnum_paid;

  static Serializer<MerchantStatementListDtoOutputStatementsInnerStatusEnum>
  get serializer =>
      _$merchantStatementListDtoOutputStatementsInnerStatusEnumSerializer;

  const MerchantStatementListDtoOutputStatementsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantStatementListDtoOutputStatementsInnerStatusEnum>
  get values => _$merchantStatementListDtoOutputStatementsInnerStatusEnumValues;
  static MerchantStatementListDtoOutputStatementsInnerStatusEnum valueOf(
    String name,
  ) => _$merchantStatementListDtoOutputStatementsInnerStatusEnumValueOf(name);
}
