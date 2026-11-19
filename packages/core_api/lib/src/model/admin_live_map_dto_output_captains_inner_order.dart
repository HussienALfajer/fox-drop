//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_captains_inner_order.g.dart';

/// The active order the captain carries.
///
/// Properties:
/// * [id]
/// * [number]
@BuiltValue()
abstract class AdminLiveMapDtoOutputCaptainsInnerOrder
    implements
        Built<
          AdminLiveMapDtoOutputCaptainsInnerOrder,
          AdminLiveMapDtoOutputCaptainsInnerOrderBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  AdminLiveMapDtoOutputCaptainsInnerOrder._();

  factory AdminLiveMapDtoOutputCaptainsInnerOrder([
    void updates(AdminLiveMapDtoOutputCaptainsInnerOrderBuilder b),
  ]) = _$AdminLiveMapDtoOutputCaptainsInnerOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputCaptainsInnerOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputCaptainsInnerOrder> get serializer =>
      _$AdminLiveMapDtoOutputCaptainsInnerOrderSerializer();
}

class _$AdminLiveMapDtoOutputCaptainsInnerOrderSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputCaptainsInnerOrder> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputCaptainsInnerOrder,
    _$AdminLiveMapDtoOutputCaptainsInnerOrder,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputCaptainsInnerOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputCaptainsInnerOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputCaptainsInnerOrder object, {
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
    required AdminLiveMapDtoOutputCaptainsInnerOrderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLiveMapDtoOutputCaptainsInnerOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputCaptainsInnerOrderBuilder();
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
