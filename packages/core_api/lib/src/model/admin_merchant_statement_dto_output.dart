//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_merchant_statement_dto_output_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_merchant_statement_dto_output.g.dart';

/// AdminMerchantStatementDtoOutput
///
/// Properties:
/// * [id]
/// * [restaurantId]
/// * [restaurantName]
/// * [cutoff]
/// * [periodFrom]
/// * [createdAt]
/// * [currency]
/// * [orders]
/// * [itemsValue]
/// * [commission]
/// * [discountShare]
/// * [exceptions]
/// * [weekTotal]
/// * [previousDue]
/// * [paid]
/// * [earlierUnpaid]
/// * [totalDue]
/// * [lines]
@BuiltValue()
abstract class AdminMerchantStatementDtoOutput
    implements
        Built<
          AdminMerchantStatementDtoOutput,
          AdminMerchantStatementDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'cutoff')
  DateTime get cutoff;

  @BuiltValueField(wireName: r'periodFrom')
  DateTime? get periodFrom;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  @BuiltValueField(wireName: r'commission')
  String get commission;

  @BuiltValueField(wireName: r'discountShare')
  String get discountShare;

  @BuiltValueField(wireName: r'exceptions')
  String get exceptions;

  @BuiltValueField(wireName: r'weekTotal')
  String get weekTotal;

  @BuiltValueField(wireName: r'previousDue')
  String get previousDue;

  @BuiltValueField(wireName: r'paid')
  String get paid;

  @BuiltValueField(wireName: r'earlierUnpaid')
  String get earlierUnpaid;

  @BuiltValueField(wireName: r'totalDue')
  String get totalDue;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminMerchantStatementDtoOutputLinesInner> get lines;

  AdminMerchantStatementDtoOutput._();

  factory AdminMerchantStatementDtoOutput([
    void updates(AdminMerchantStatementDtoOutputBuilder b),
  ]) = _$AdminMerchantStatementDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMerchantStatementDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMerchantStatementDtoOutput> get serializer =>
      _$AdminMerchantStatementDtoOutputSerializer();
}

class _$AdminMerchantStatementDtoOutputSerializer
    implements PrimitiveSerializer<AdminMerchantStatementDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMerchantStatementDtoOutput,
    _$AdminMerchantStatementDtoOutput,
  ];

  @override
  final String wireName = r'AdminMerchantStatementDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMerchantStatementDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
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
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
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
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMerchantStatementDtoOutputLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMerchantStatementDtoOutput object, {
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
    required AdminMerchantStatementDtoOutputBuilder result,
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
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
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
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
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
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMerchantStatementDtoOutputLinesInner),
                    ]),
                  )
                  as BuiltList<AdminMerchantStatementDtoOutputLinesInner>;
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
  AdminMerchantStatementDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMerchantStatementDtoOutputBuilder();
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
