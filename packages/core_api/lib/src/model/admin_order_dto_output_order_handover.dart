//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_handover_handovers_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_handover.g.dart';

/// AP §9.3.1, §9.3.2 «تسليم لكابتن آخر» (slice 2.12b).
///
/// Properties:
/// * [allowed] - «تسليم لكابتن آخر» is offered: picked up or arrived with a captain, no handover open, no outcome waiting.
/// * [handovers] - Every handover of the order, oldest first.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderHandover
    implements
        Built<
          AdminOrderDtoOutputOrderHandover,
          AdminOrderDtoOutputOrderHandoverBuilder
        > {
  /// «تسليم لكابتن آخر» is offered: picked up or arrived with a captain, no handover open, no outcome waiting.
  @BuiltValueField(wireName: r'allowed')
  bool get allowed;

  /// Every handover of the order, oldest first.
  @BuiltValueField(wireName: r'handovers')
  BuiltList<AdminOrderDtoOutputOrderHandoverHandoversInner> get handovers;

  AdminOrderDtoOutputOrderHandover._();

  factory AdminOrderDtoOutputOrderHandover([
    void updates(AdminOrderDtoOutputOrderHandoverBuilder b),
  ]) = _$AdminOrderDtoOutputOrderHandover;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderHandoverBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderHandover> get serializer =>
      _$AdminOrderDtoOutputOrderHandoverSerializer();
}

class _$AdminOrderDtoOutputOrderHandoverSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderHandover> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderHandover,
    _$AdminOrderDtoOutputOrderHandover,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderHandover';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderHandover object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'allowed';
    yield serializers.serialize(
      object.allowed,
      specifiedType: const FullType(bool),
    );
    yield r'handovers';
    yield serializers.serialize(
      object.handovers,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderHandoverHandoversInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderHandover object, {
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
    required AdminOrderDtoOutputOrderHandoverBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'allowed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.allowed = valueDes;
          break;
        case r'handovers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderHandoverHandoversInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderHandoverHandoversInner>;
          result.handovers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderHandover deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderHandoverBuilder();
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
