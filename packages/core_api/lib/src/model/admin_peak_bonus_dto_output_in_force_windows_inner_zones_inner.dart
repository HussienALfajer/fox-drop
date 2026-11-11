//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.g.dart';

/// The zone the point is in, the neighbourhood of an unsaved point.
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner
    implements
        Built<
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner._();

  factory AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner([
    void updates(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder b),
  ]) = _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner>
  get serializer =>
      _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerSerializer();
}

class _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
    _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
  ];

  @override
  final String wireName =
      r'AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner object, {
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
    required AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder();
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
