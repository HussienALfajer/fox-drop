//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_reassign_choices_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_reassign_choices.g.dart';

/// While accepted or ready with a captain: the choices of «سحب وإعادة تعيين» (AP §9.3.2); refused with 409 pickup_request_open while a request is open.
///
/// Properties:
/// * [reasons] - Content's active reassignment reasons, in order (AP Appendix B).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderReassignChoices
    implements
        Built<
          AdminOrderDtoOutputOrderReassignChoices,
          AdminOrderDtoOutputOrderReassignChoicesBuilder
        > {
  /// Content's active reassignment reasons, in order (AP Appendix B).
  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminOrderDtoOutputOrderReassignChoicesReasonsInner> get reasons;

  AdminOrderDtoOutputOrderReassignChoices._();

  factory AdminOrderDtoOutputOrderReassignChoices([
    void updates(AdminOrderDtoOutputOrderReassignChoicesBuilder b),
  ]) = _$AdminOrderDtoOutputOrderReassignChoices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderReassignChoicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderReassignChoices> get serializer =>
      _$AdminOrderDtoOutputOrderReassignChoicesSerializer();
}

class _$AdminOrderDtoOutputOrderReassignChoicesSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderReassignChoices> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderReassignChoices,
    _$AdminOrderDtoOutputOrderReassignChoices,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderReassignChoices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignChoices object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderReassignChoicesReasonsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignChoices object, {
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
    required AdminOrderDtoOutputOrderReassignChoicesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderDtoOutputOrderReassignChoicesReasonsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderDtoOutputOrderReassignChoicesReasonsInner
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
  AdminOrderDtoOutputOrderReassignChoices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderReassignChoicesBuilder();
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
