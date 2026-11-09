//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_dispatch_state_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dispatch_state_dto_output.g.dart';

/// AdminDispatchStateDtoOutput
///
/// Properties:
/// * [order] 
@BuiltValue()
abstract class AdminDispatchStateDtoOutput implements Built<AdminDispatchStateDtoOutput, AdminDispatchStateDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  AdminDispatchStateDtoOutputOrder get order;

  AdminDispatchStateDtoOutput._();

  factory AdminDispatchStateDtoOutput([void updates(AdminDispatchStateDtoOutputBuilder b)]) = _$AdminDispatchStateDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDispatchStateDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDispatchStateDtoOutput> get serializer => _$AdminDispatchStateDtoOutputSerializer();
}

class _$AdminDispatchStateDtoOutputSerializer implements PrimitiveSerializer<AdminDispatchStateDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminDispatchStateDtoOutput, _$AdminDispatchStateDtoOutput];

  @override
  final String wireName = r'AdminDispatchStateDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDispatchStateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(AdminDispatchStateDtoOutputOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDispatchStateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDispatchStateDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDispatchStateDtoOutputOrder),
          ) as AdminDispatchStateDtoOutputOrder;
          result.order.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDispatchStateDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDispatchStateDtoOutputBuilder();
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


