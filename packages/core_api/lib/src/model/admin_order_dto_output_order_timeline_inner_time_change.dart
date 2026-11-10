//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_timeline_inner_time_change.g.dart';

/// order.time_changed: the minutes added and the new promised time.
///
/// Properties:
/// * [addMin]
/// * [promisedAt]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderTimelineInnerTimeChange
    implements
        Built<
          AdminOrderDtoOutputOrderTimelineInnerTimeChange,
          AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder
        > {
  @BuiltValueField(wireName: r'addMin')
  int get addMin;

  @BuiltValueField(wireName: r'promisedAt')
  DateTime get promisedAt;

  AdminOrderDtoOutputOrderTimelineInnerTimeChange._();

  factory AdminOrderDtoOutputOrderTimelineInnerTimeChange([
    void updates(AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder b),
  ]) = _$AdminOrderDtoOutputOrderTimelineInnerTimeChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderTimelineInnerTimeChange>
  get serializer =>
      _$AdminOrderDtoOutputOrderTimelineInnerTimeChangeSerializer();
}

class _$AdminOrderDtoOutputOrderTimelineInnerTimeChangeSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderTimelineInnerTimeChange> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderTimelineInnerTimeChange,
    _$AdminOrderDtoOutputOrderTimelineInnerTimeChange,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderTimelineInnerTimeChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInnerTimeChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'addMin';
    yield serializers.serialize(
      object.addMin,
      specifiedType: const FullType(int),
    );
    yield r'promisedAt';
    yield serializers.serialize(
      object.promisedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInnerTimeChange object, {
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
    required AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'addMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.addMin = valueDes;
          break;
        case r'promisedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.promisedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderTimelineInnerTimeChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder();
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
