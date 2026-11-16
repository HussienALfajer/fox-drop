//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_settlement_preview_dto_output_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settlement_preview_dto_output.g.dart';

/// AdminRestaurantSettlementPreviewDtoOutput
///
/// Properties:
/// * [restaurantId]
/// * [restaurantName]
/// * [cityId]
/// * [currency]
/// * [due] - + the restaurant owes, − the platform owes it.
/// * [lines]
/// * [total]
/// * [remaining] - What stays on the account, of the sign of due.
@BuiltValue()
abstract class AdminRestaurantSettlementPreviewDtoOutput
    implements
        Built<
          AdminRestaurantSettlementPreviewDtoOutput,
          AdminRestaurantSettlementPreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// + the restaurant owes, − the platform owes it.
  @BuiltValueField(wireName: r'due')
  String get due;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRestaurantSettlementPreviewDtoOutputLinesInner> get lines;

  @BuiltValueField(wireName: r'total')
  String get total;

  /// What stays on the account, of the sign of due.
  @BuiltValueField(wireName: r'remaining')
  String get remaining;

  AdminRestaurantSettlementPreviewDtoOutput._();

  factory AdminRestaurantSettlementPreviewDtoOutput([
    void updates(AdminRestaurantSettlementPreviewDtoOutputBuilder b),
  ]) = _$AdminRestaurantSettlementPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantSettlementPreviewDtoOutputBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettlementPreviewDtoOutput> get serializer =>
      _$AdminRestaurantSettlementPreviewDtoOutputSerializer();
}

class _$AdminRestaurantSettlementPreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantSettlementPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettlementPreviewDtoOutput,
    _$AdminRestaurantSettlementPreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantSettlementPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettlementPreviewDtoOutput object, {
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
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'due';
    yield serializers.serialize(
      object.due,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantSettlementPreviewDtoOutputLinesInner),
      ]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'remaining';
    yield serializers.serialize(
      object.remaining,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementPreviewDtoOutput object, {
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
    required AdminRestaurantSettlementPreviewDtoOutputBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'due':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.due = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantSettlementPreviewDtoOutputLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantSettlementPreviewDtoOutputLinesInner
                  >;
          result.lines.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        case r'remaining':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.remaining = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSettlementPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettlementPreviewDtoOutputBuilder();
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
