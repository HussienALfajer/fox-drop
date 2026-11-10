//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_time_change.g.dart';

/// While accepted, ready or picked up: «تعديل الوقت» (AP §9.3.2).
///
/// Properties:
/// * [maxMin] - order.eta_change_max_min.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderTimeChange
    implements
        Built<
          AdminOrderDtoOutputOrderTimeChange,
          AdminOrderDtoOutputOrderTimeChangeBuilder
        > {
  /// order.eta_change_max_min.
  @BuiltValueField(wireName: r'maxMin')
  int get maxMin;

  AdminOrderDtoOutputOrderTimeChange._();

  factory AdminOrderDtoOutputOrderTimeChange([
    void updates(AdminOrderDtoOutputOrderTimeChangeBuilder b),
  ]) = _$AdminOrderDtoOutputOrderTimeChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderTimeChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderTimeChange> get serializer =>
      _$AdminOrderDtoOutputOrderTimeChangeSerializer();
}

class _$AdminOrderDtoOutputOrderTimeChangeSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderTimeChange> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderTimeChange,
    _$AdminOrderDtoOutputOrderTimeChange,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderTimeChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimeChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'maxMin';
    yield serializers.serialize(
      object.maxMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimeChange object, {
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
    required AdminOrderDtoOutputOrderTimeChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maxMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.maxMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderTimeChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderTimeChangeBuilder();
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
