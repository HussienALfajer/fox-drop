//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_card_dto_output_order_dispatch_manual.g.dart';

/// The order left automatic dispatch for operations; null while it has not.
///
/// Properties:
/// * [reason] - «مختلط»’s fallback after dispatch.max_offers_before_manual failed offers or at the no-captain alert, or «توزيع يدوي لهذا الطلب».
/// * [at]
@BuiltValue()
abstract class AdminOrderCardDtoOutputOrderDispatchManual
    implements
        Built<
          AdminOrderCardDtoOutputOrderDispatchManual,
          AdminOrderCardDtoOutputOrderDispatchManualBuilder
        > {
  /// «مختلط»’s fallback after dispatch.max_offers_before_manual failed offers or at the no-captain alert, or «توزيع يدوي لهذا الطلب».
  @BuiltValueField(wireName: r'reason')
  AdminOrderCardDtoOutputOrderDispatchManualReasonEnum get reason;
  // enum reasonEnum {  max_offers,  no_captain_alert,  operations,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminOrderCardDtoOutputOrderDispatchManual._();

  factory AdminOrderCardDtoOutputOrderDispatchManual([
    void updates(AdminOrderCardDtoOutputOrderDispatchManualBuilder b),
  ]) = _$AdminOrderCardDtoOutputOrderDispatchManual;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCardDtoOutputOrderDispatchManualBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCardDtoOutputOrderDispatchManual>
  get serializer => _$AdminOrderCardDtoOutputOrderDispatchManualSerializer();
}

class _$AdminOrderCardDtoOutputOrderDispatchManualSerializer
    implements PrimitiveSerializer<AdminOrderCardDtoOutputOrderDispatchManual> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCardDtoOutputOrderDispatchManual,
    _$AdminOrderCardDtoOutputOrderDispatchManual,
  ];

  @override
  final String wireName = r'AdminOrderCardDtoOutputOrderDispatchManual';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderDispatchManual object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(
        AdminOrderCardDtoOutputOrderDispatchManualReasonEnum,
      ),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderDispatchManual object, {
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
    required AdminOrderCardDtoOutputOrderDispatchManualBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderDispatchManualReasonEnum,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderDispatchManualReasonEnum;
          result.reason = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCardDtoOutputOrderDispatchManual deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCardDtoOutputOrderDispatchManualBuilder();
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

/// «مختلط»’s fallback after dispatch.max_offers_before_manual failed offers or at the no-captain alert, or «توزيع يدوي لهذا الطلب».
class AdminOrderCardDtoOutputOrderDispatchManualReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'max_offers')
  static const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum maxOffers =
      _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_maxOffers;
  @BuiltValueEnumConst(wireName: r'no_captain_alert')
  static const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum
  noCaptainAlert =
      _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_noCaptainAlert;
  @BuiltValueEnumConst(wireName: r'operations')
  static const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum operations =
      _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_operations;

  static Serializer<AdminOrderCardDtoOutputOrderDispatchManualReasonEnum>
  get serializer =>
      _$adminOrderCardDtoOutputOrderDispatchManualReasonEnumSerializer;

  const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderCardDtoOutputOrderDispatchManualReasonEnum>
  get values => _$adminOrderCardDtoOutputOrderDispatchManualReasonEnumValues;
  static AdminOrderCardDtoOutputOrderDispatchManualReasonEnum valueOf(
    String name,
  ) => _$adminOrderCardDtoOutputOrderDispatchManualReasonEnumValueOf(name);
}
