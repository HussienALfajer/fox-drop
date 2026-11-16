//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_statement_dto_output_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_statement_dto_output.g.dart';

/// MerchantStatementDtoOutput
///
/// Properties:
/// * [id]
/// * [restaurantName]
/// * [cutoff]
/// * [periodFrom]
/// * [currency]
/// * [orders]
/// * [itemsValue] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [commission] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [discountShare] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [exceptions] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [weekTotal] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [previousDue] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [paid] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [earlierUnpaid] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [totalDue] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [status]
/// * [unpaid] - What of the total due is still unpaid, oldest first.
/// * [lines]
@BuiltValue()
abstract class MerchantStatementDtoOutput
    implements
        Built<MerchantStatementDtoOutput, MerchantStatementDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'cutoff')
  DateTime get cutoff;

  @BuiltValueField(wireName: r'periodFrom')
  DateTime? get periodFrom;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'commission')
  String get commission;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'discountShare')
  String get discountShare;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'exceptions')
  String get exceptions;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'weekTotal')
  String get weekTotal;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'previousDue')
  String get previousDue;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'paid')
  String get paid;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'earlierUnpaid')
  String get earlierUnpaid;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'totalDue')
  String get totalDue;

  @BuiltValueField(wireName: r'status')
  MerchantStatementDtoOutputStatusEnum? get status;
  // enum statusEnum {  unpaid,  partly_paid,  paid,  };

  /// What of the total due is still unpaid, oldest first.
  @BuiltValueField(wireName: r'unpaid')
  String get unpaid;

  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantStatementDtoOutputLinesInner> get lines;

  MerchantStatementDtoOutput._();

  factory MerchantStatementDtoOutput([
    void updates(MerchantStatementDtoOutputBuilder b),
  ]) = _$MerchantStatementDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatementDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatementDtoOutput> get serializer =>
      _$MerchantStatementDtoOutputSerializer();
}

class _$MerchantStatementDtoOutputSerializer
    implements PrimitiveSerializer<MerchantStatementDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantStatementDtoOutput,
    _$MerchantStatementDtoOutput,
  ];

  @override
  final String wireName = r'MerchantStatementDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatementDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
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
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'discountShare';
    yield serializers.serialize(
      object.discountShare,
      specifiedType: const FullType(String),
    );
    yield r'exceptions';
    yield serializers.serialize(
      object.exceptions,
      specifiedType: const FullType(String),
    );
    yield r'weekTotal';
    yield serializers.serialize(
      object.weekTotal,
      specifiedType: const FullType(String),
    );
    yield r'previousDue';
    yield serializers.serialize(
      object.previousDue,
      specifiedType: const FullType(String),
    );
    yield r'paid';
    yield serializers.serialize(
      object.paid,
      specifiedType: const FullType(String),
    );
    yield r'earlierUnpaid';
    yield serializers.serialize(
      object.earlierUnpaid,
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
              MerchantStatementDtoOutputStatusEnum,
            ),
          );
    yield r'unpaid';
    yield serializers.serialize(
      object.unpaid,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantStatementDtoOutputLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementDtoOutput object, {
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
    required MerchantStatementDtoOutputBuilder result,
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
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
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
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'discountShare':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discountShare = valueDes;
          break;
        case r'exceptions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.exceptions = valueDes;
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
        case r'previousDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.previousDue = valueDes;
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
        case r'earlierUnpaid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.earlierUnpaid = valueDes;
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
                      MerchantStatementDtoOutputStatusEnum,
                    ),
                  )
                  as MerchantStatementDtoOutputStatusEnum?;
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
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantStatementDtoOutputLinesInner),
                    ]),
                  )
                  as BuiltList<MerchantStatementDtoOutputLinesInner>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatementDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatementDtoOutputBuilder();
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

class MerchantStatementDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'unpaid')
  static const MerchantStatementDtoOutputStatusEnum unpaid =
      _$merchantStatementDtoOutputStatusEnum_unpaid;
  @BuiltValueEnumConst(wireName: r'partly_paid')
  static const MerchantStatementDtoOutputStatusEnum partlyPaid =
      _$merchantStatementDtoOutputStatusEnum_partlyPaid;
  @BuiltValueEnumConst(wireName: r'paid')
  static const MerchantStatementDtoOutputStatusEnum paid =
      _$merchantStatementDtoOutputStatusEnum_paid;

  static Serializer<MerchantStatementDtoOutputStatusEnum> get serializer =>
      _$merchantStatementDtoOutputStatusEnumSerializer;

  const MerchantStatementDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<MerchantStatementDtoOutputStatusEnum> get values =>
      _$merchantStatementDtoOutputStatusEnumValues;
  static MerchantStatementDtoOutputStatusEnum valueOf(String name) =>
      _$merchantStatementDtoOutputStatusEnumValueOf(name);
}
