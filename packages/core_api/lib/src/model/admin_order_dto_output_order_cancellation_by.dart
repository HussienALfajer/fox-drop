//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_cancellation_by.g.dart';

/// Who cancelled.
///
/// Properties:
/// * [type]
/// * [id]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCancellationBy
    implements
        Built<
          AdminOrderDtoOutputOrderCancellationBy,
          AdminOrderDtoOutputOrderCancellationByBuilder
        > {
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'id')
  String? get id;

  AdminOrderDtoOutputOrderCancellationBy._();

  factory AdminOrderDtoOutputOrderCancellationBy([
    void updates(AdminOrderDtoOutputOrderCancellationByBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCancellationBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCancellationByBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCancellationBy> get serializer =>
      _$AdminOrderDtoOutputOrderCancellationBySerializer();
}

class _$AdminOrderDtoOutputOrderCancellationBySerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderCancellationBy> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCancellationBy,
    _$AdminOrderDtoOutputOrderCancellationBy,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCancellationBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancellationBy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield object.id == null
        ? null
        : serializers.serialize(
            object.id,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancellationBy object, {
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
    required AdminOrderDtoOutputOrderCancellationByBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderCancellationBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCancellationByBuilder();
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
