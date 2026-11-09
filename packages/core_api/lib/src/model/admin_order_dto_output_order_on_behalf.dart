//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_on_behalf_rejection_reasons_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_on_behalf_prep_time.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_on_behalf.g.dart';

/// While placed: the choices of AP §9.3.2's accept and reject on the restaurant's behalf.
///
/// Properties:
/// * [prepTime] 
/// * [rejectionReasons] - «رفض نيابة عن المطعم»: the restaurant's reasons (AP Appendix B), in order.
/// * [busyExtraOptionsMin] - «ضغط طلبات»: busy mode with one of merchant.busy_extra_options_min.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOnBehalf implements Built<AdminOrderDtoOutputOrderOnBehalf, AdminOrderDtoOutputOrderOnBehalfBuilder> {
  @BuiltValueField(wireName: r'prepTime')
  AdminOrderDtoOutputOrderOnBehalfPrepTime get prepTime;

  /// «رفض نيابة عن المطعم»: the restaurant's reasons (AP Appendix B), in order.
  @BuiltValueField(wireName: r'rejectionReasons')
  BuiltList<AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner> get rejectionReasons;

  /// «ضغط طلبات»: busy mode with one of merchant.busy_extra_options_min.
  @BuiltValueField(wireName: r'busyExtraOptionsMin')
  BuiltList<int> get busyExtraOptionsMin;

  AdminOrderDtoOutputOrderOnBehalf._();

  factory AdminOrderDtoOutputOrderOnBehalf([void updates(AdminOrderDtoOutputOrderOnBehalfBuilder b)]) = _$AdminOrderDtoOutputOrderOnBehalf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderOnBehalfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOnBehalf> get serializer => _$AdminOrderDtoOutputOrderOnBehalfSerializer();
}

class _$AdminOrderDtoOutputOrderOnBehalfSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderOnBehalf> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderOnBehalf, _$AdminOrderDtoOutputOrderOnBehalf];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOnBehalf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOnBehalf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'prepTime';
    yield serializers.serialize(
      object.prepTime,
      specifiedType: const FullType(AdminOrderDtoOutputOrderOnBehalfPrepTime),
    );
    yield r'rejectionReasons';
    yield serializers.serialize(
      object.rejectionReasons,
      specifiedType: const FullType(BuiltList, [FullType(AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner)]),
    );
    yield r'busyExtraOptionsMin';
    yield serializers.serialize(
      object.busyExtraOptionsMin,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOnBehalf object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderOnBehalfBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'prepTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOrderDtoOutputOrderOnBehalfPrepTime),
          ) as AdminOrderDtoOutputOrderOnBehalfPrepTime;
          result.prepTime.replace(valueDes);
          break;
        case r'rejectionReasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner)]),
          ) as BuiltList<AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner>;
          result.rejectionReasons.replace(valueDes);
          break;
        case r'busyExtraOptionsMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.busyExtraOptionsMin.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderOnBehalf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOnBehalfBuilder();
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


