//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_cancel_choices_reasons_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_cancel_choices.g.dart';

/// While placed, accepted or ready: the choices of «إلغاء الطلب» (AP §9.3.2).
///
/// Properties:
/// * [reasons] - Content's active ops_cancel reasons, in order (AP Appendix B).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCancelChoices
    implements
        Built<
          AdminOrderDtoOutputOrderCancelChoices,
          AdminOrderDtoOutputOrderCancelChoicesBuilder
        > {
  /// Content's active ops_cancel reasons, in order (AP Appendix B).
  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminOrderDtoOutputOrderCancelChoicesReasonsInner> get reasons;

  AdminOrderDtoOutputOrderCancelChoices._();

  factory AdminOrderDtoOutputOrderCancelChoices([
    void updates(AdminOrderDtoOutputOrderCancelChoicesBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCancelChoices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCancelChoicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCancelChoices> get serializer =>
      _$AdminOrderDtoOutputOrderCancelChoicesSerializer();
}

class _$AdminOrderDtoOutputOrderCancelChoicesSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderCancelChoices> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCancelChoices,
    _$AdminOrderDtoOutputOrderCancelChoices,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCancelChoices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancelChoices object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderCancelChoicesReasonsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancelChoices object, {
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
    required AdminOrderDtoOutputOrderCancelChoicesBuilder result,
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
                        AdminOrderDtoOutputOrderCancelChoicesReasonsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderDtoOutputOrderCancelChoicesReasonsInner
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
  AdminOrderDtoOutputOrderCancelChoices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCancelChoicesBuilder();
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
