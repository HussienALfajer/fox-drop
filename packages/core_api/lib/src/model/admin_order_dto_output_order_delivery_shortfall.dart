//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_delivery_shortfall.g.dart';

/// «نقص في التحصيل» (AP §8.6), open until operations resolve it.
///
/// Properties:
/// * [amount]
/// * [reason]
/// * [note]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderDeliveryShortfall
    implements
        Built<
          AdminOrderDtoOutputOrderDeliveryShortfall,
          AdminOrderDtoOutputOrderDeliveryShortfallBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  CaptainWentOfflineDtoOutputHandIn? get amount;

  @BuiltValueField(wireName: r'reason')
  AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum get reason;
  // enum reasonEnum {  customer_short,  counting_error,  other,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminOrderDtoOutputOrderDeliveryShortfall._();

  factory AdminOrderDtoOutputOrderDeliveryShortfall([
    void updates(AdminOrderDtoOutputOrderDeliveryShortfallBuilder b),
  ]) = _$AdminOrderDtoOutputOrderDeliveryShortfall;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderDeliveryShortfallBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderDeliveryShortfall> get serializer =>
      _$AdminOrderDtoOutputOrderDeliveryShortfallSerializer();
}

class _$AdminOrderDtoOutputOrderDeliveryShortfallSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderDeliveryShortfall> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderDeliveryShortfall,
    _$AdminOrderDtoOutputOrderDeliveryShortfall,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderDeliveryShortfall';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryShortfall object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum,
      ),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryShortfall object, {
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
    required AdminOrderDtoOutputOrderDeliveryShortfallBuilder result,
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
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.amount.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderDeliveryShortfall deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderDeliveryShortfallBuilder();
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

class AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer_short')
  static const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
  customerShort =
      _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_customerShort;
  @BuiltValueEnumConst(wireName: r'counting_error')
  static const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
  countingError =
      _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_countingError;
  @BuiltValueEnumConst(wireName: r'other')
  static const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum other =
      _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_other;

  static Serializer<AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnumSerializer;

  const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum>
  get values => _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnumValues;
  static AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnumValueOf(name);
}
