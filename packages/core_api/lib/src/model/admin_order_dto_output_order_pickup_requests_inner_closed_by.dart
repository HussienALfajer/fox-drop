//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_pickup_requests_inner_closed_by.g.dart';

/// AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy
///
/// Properties:
/// * [type] 
/// * [id] 
/// * [device] - The restaurant's app installation.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy implements Built<AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy, AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder> {
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'id')
  String? get id;

  /// The restaurant's app installation.
  @BuiltValueField(wireName: r'device')
  String? get device;

  AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy._();

  factory AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy([void updates(AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder b)]) = _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy> get serializer => _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBySerializer();
}

class _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBySerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy, _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield object.id == null ? null : serializers.serialize(
      object.id,
      specifiedType: const FullType.nullable(String),
    );
    yield r'device';
    yield object.device == null ? null : serializers.serialize(
      object.device,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.device = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder();
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


