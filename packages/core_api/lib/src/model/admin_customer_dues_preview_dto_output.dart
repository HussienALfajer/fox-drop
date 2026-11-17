//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_settlement_preview_dto_output_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dues_preview_dto_output.g.dart';

/// AdminCustomerDuesPreviewDtoOutput
///
/// Properties:
/// * [customerId]
/// * [customerName]
/// * [cityId]
/// * [currency]
/// * [due] - + the customer owes; 0 or less when nothing is owed.
/// * [lines]
/// * [total]
/// * [remaining] - What stays owed after the payment.
@BuiltValue()
abstract class AdminCustomerDuesPreviewDtoOutput
    implements
        Built<
          AdminCustomerDuesPreviewDtoOutput,
          AdminCustomerDuesPreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'customerId')
  String get customerId;

  @BuiltValueField(wireName: r'customerName')
  String get customerName;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// + the customer owes; 0 or less when nothing is owed.
  @BuiltValueField(wireName: r'due')
  String get due;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRestaurantSettlementPreviewDtoOutputLinesInner> get lines;

  @BuiltValueField(wireName: r'total')
  String get total;

  /// What stays owed after the payment.
  @BuiltValueField(wireName: r'remaining')
  String get remaining;

  AdminCustomerDuesPreviewDtoOutput._();

  factory AdminCustomerDuesPreviewDtoOutput([
    void updates(AdminCustomerDuesPreviewDtoOutputBuilder b),
  ]) = _$AdminCustomerDuesPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDuesPreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDuesPreviewDtoOutput> get serializer =>
      _$AdminCustomerDuesPreviewDtoOutputSerializer();
}

class _$AdminCustomerDuesPreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminCustomerDuesPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDuesPreviewDtoOutput,
    _$AdminCustomerDuesPreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminCustomerDuesPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDuesPreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customerId';
    yield serializers.serialize(
      object.customerId,
      specifiedType: const FullType(String),
    );
    yield r'customerName';
    yield serializers.serialize(
      object.customerName,
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
    AdminCustomerDuesPreviewDtoOutput object, {
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
    required AdminCustomerDuesPreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customerId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerId = valueDes;
          break;
        case r'customerName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerName = valueDes;
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
  AdminCustomerDuesPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDuesPreviewDtoOutputBuilder();
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
