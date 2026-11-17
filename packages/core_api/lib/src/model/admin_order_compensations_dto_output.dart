//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_note.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_compensations_dto_output_compensations_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_compensations_dto_output.g.dart';

/// AdminOrderCompensationsDtoOutput
///
/// Properties:
/// * [compensations] - Newest first.
/// * [currency] - The order's currency, the codes' too.
/// * [capLeft] - What the admin may still give on this order without OWN's approval; null for no cap (OWN).
/// * [canCompensate] - The session holds operations.compensate.
/// * [reasons] - The active «تعويض الزبون» reasons, in order; each takes an optional note.
@BuiltValue()
abstract class AdminOrderCompensationsDtoOutput
    implements
        Built<
          AdminOrderCompensationsDtoOutput,
          AdminOrderCompensationsDtoOutputBuilder
        > {
  /// Newest first.
  @BuiltValueField(wireName: r'compensations')
  BuiltList<AdminOrderCompensationsDtoOutputCompensationsInner>
  get compensations;

  /// The order's currency, the codes' too.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// What the admin may still give on this order without OWN's approval; null for no cap (OWN).
  @BuiltValueField(wireName: r'capLeft')
  String? get capLeft;

  /// The session holds operations.compensate.
  @BuiltValueField(wireName: r'canCompensate')
  bool get canCompensate;

  /// The active «تعويض الزبون» reasons, in order; each takes an optional note.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerItemReportNote?> get reasons;

  AdminOrderCompensationsDtoOutput._();

  factory AdminOrderCompensationsDtoOutput([
    void updates(AdminOrderCompensationsDtoOutputBuilder b),
  ]) = _$AdminOrderCompensationsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCompensationsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCompensationsDtoOutput> get serializer =>
      _$AdminOrderCompensationsDtoOutputSerializer();
}

class _$AdminOrderCompensationsDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderCompensationsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCompensationsDtoOutput,
    _$AdminOrderCompensationsDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderCompensationsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCompensationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'compensations';
    yield serializers.serialize(
      object.compensations,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderCompensationsDtoOutputCompensationsInner),
      ]),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'capLeft';
    yield object.capLeft == null
        ? null
        : serializers.serialize(
            object.capLeft,
            specifiedType: const FullType.nullable(String),
          );
    yield r'canCompensate';
    yield serializers.serialize(
      object.canCompensate,
      specifiedType: const FullType(bool),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(MerchantOrdersDtoOutputOrdersInnerItemReportNote),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCompensationsDtoOutput object, {
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
    required AdminOrderCompensationsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'compensations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderCompensationsDtoOutputCompensationsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderCompensationsDtoOutputCompensationsInner
                  >;
          result.compensations.replace(valueDes);
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
        case r'capLeft':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.capLeft = valueDes;
          break;
        case r'canCompensate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.canCompensate = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        MerchantOrdersDtoOutputOrdersInnerItemReportNote,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantOrdersDtoOutputOrdersInnerItemReportNote?
                  >;
          result.reasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCompensationsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCompensationsDtoOutputBuilder();
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
