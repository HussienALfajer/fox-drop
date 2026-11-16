//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_period_statement_dto_output_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_period_statement_dto_output.g.dart';

/// AdminRestaurantPeriodStatementDtoOutput
///
/// Properties:
/// * [restaurantId]
/// * [restaurantName]
/// * [cityId]
/// * [currency]
/// * [fromDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [toDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [from] - The cutoff that starts the first day.
/// * [to] - The cutoff that ends the last day.
/// * [opening] - + the restaurant owes, − the platform owes it.
/// * [orders]
/// * [itemsValue]
/// * [commission]
/// * [discountShare]
/// * [exceptions]
/// * [paid]
/// * [closing]
/// * [lines]
@BuiltValue()
abstract class AdminRestaurantPeriodStatementDtoOutput
    implements
        Built<
          AdminRestaurantPeriodStatementDtoOutput,
          AdminRestaurantPeriodStatementDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'currency')
  String? get currency;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'fromDay')
  String get fromDay;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'toDay')
  String get toDay;

  /// The cutoff that starts the first day.
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// The cutoff that ends the last day.
  @BuiltValueField(wireName: r'to')
  DateTime get to;

  /// + the restaurant owes, − the platform owes it.
  @BuiltValueField(wireName: r'opening')
  String get opening;

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

  @BuiltValueField(wireName: r'paid')
  String get paid;

  @BuiltValueField(wireName: r'closing')
  String get closing;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRestaurantPeriodStatementDtoOutputLinesInner> get lines;

  AdminRestaurantPeriodStatementDtoOutput._();

  factory AdminRestaurantPeriodStatementDtoOutput([
    void updates(AdminRestaurantPeriodStatementDtoOutputBuilder b),
  ]) = _$AdminRestaurantPeriodStatementDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantPeriodStatementDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantPeriodStatementDtoOutput> get serializer =>
      _$AdminRestaurantPeriodStatementDtoOutputSerializer();
}

class _$AdminRestaurantPeriodStatementDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantPeriodStatementDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantPeriodStatementDtoOutput,
    _$AdminRestaurantPeriodStatementDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantPeriodStatementDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantPeriodStatementDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'fromDay';
    yield serializers.serialize(
      object.fromDay,
      specifiedType: const FullType(String),
    );
    yield r'toDay';
    yield serializers.serialize(
      object.toDay,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(DateTime),
    );
    yield r'opening';
    yield serializers.serialize(
      object.opening,
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
    yield r'paid';
    yield serializers.serialize(
      object.paid,
      specifiedType: const FullType(String),
    );
    yield r'closing';
    yield serializers.serialize(
      object.closing,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantPeriodStatementDtoOutputLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantPeriodStatementDtoOutput object, {
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
    required AdminRestaurantPeriodStatementDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
          break;
        case r'fromDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fromDay = valueDes;
          break;
        case r'toDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.toDay = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.to = valueDes;
          break;
        case r'opening':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.opening = valueDes;
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
        case r'paid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.paid = valueDes;
          break;
        case r'closing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.closing = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantPeriodStatementDtoOutputLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantPeriodStatementDtoOutputLinesInner
                  >;
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
  AdminRestaurantPeriodStatementDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantPeriodStatementDtoOutputBuilder();
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
