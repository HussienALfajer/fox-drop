//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_peak_bonus_dto_output_zones_inner.g.dart';

/// AdminPeakBonusDtoOutputZonesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [active]
@BuiltValue()
abstract class AdminPeakBonusDtoOutputZonesInner
    implements
        Built<
          AdminPeakBonusDtoOutputZonesInner,
          AdminPeakBonusDtoOutputZonesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'active')
  bool get active;

  AdminPeakBonusDtoOutputZonesInner._();

  factory AdminPeakBonusDtoOutputZonesInner([
    void updates(AdminPeakBonusDtoOutputZonesInnerBuilder b),
  ]) = _$AdminPeakBonusDtoOutputZonesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPeakBonusDtoOutputZonesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPeakBonusDtoOutputZonesInner> get serializer =>
      _$AdminPeakBonusDtoOutputZonesInnerSerializer();
}

class _$AdminPeakBonusDtoOutputZonesInnerSerializer
    implements PrimitiveSerializer<AdminPeakBonusDtoOutputZonesInner> {
  @override
  final Iterable<Type> types = const [
    AdminPeakBonusDtoOutputZonesInner,
    _$AdminPeakBonusDtoOutputZonesInner,
  ];

  @override
  final String wireName = r'AdminPeakBonusDtoOutputZonesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPeakBonusDtoOutputZonesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPeakBonusDtoOutputZonesInner object, {
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
    required AdminPeakBonusDtoOutputZonesInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPeakBonusDtoOutputZonesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPeakBonusDtoOutputZonesInnerBuilder();
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
