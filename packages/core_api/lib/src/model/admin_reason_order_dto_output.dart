//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_reason_lists_dto_output_lists_inner_reasons_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reason_order_dto_output.g.dart';

/// AdminReasonOrderDtoOutput
///
/// Properties:
/// * [reasons] 
@BuiltValue()
abstract class AdminReasonOrderDtoOutput implements Built<AdminReasonOrderDtoOutput, AdminReasonOrderDtoOutputBuilder> {
  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminReasonListsDtoOutputListsInnerReasonsInner> get reasons;

  AdminReasonOrderDtoOutput._();

  factory AdminReasonOrderDtoOutput([void updates(AdminReasonOrderDtoOutputBuilder b)]) = _$AdminReasonOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReasonOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReasonOrderDtoOutput> get serializer => _$AdminReasonOrderDtoOutputSerializer();
}

class _$AdminReasonOrderDtoOutputSerializer implements PrimitiveSerializer<AdminReasonOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminReasonOrderDtoOutput, _$AdminReasonOrderDtoOutput];

  @override
  final String wireName = r'AdminReasonOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReasonOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(AdminReasonListsDtoOutputListsInnerReasonsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReasonOrderDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReasonListsDtoOutputListsInnerReasonsInner)]),
          ) as BuiltList<AdminReasonListsDtoOutputListsInnerReasonsInner>;
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
  AdminReasonOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReasonOrderDtoOutputBuilder();
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


