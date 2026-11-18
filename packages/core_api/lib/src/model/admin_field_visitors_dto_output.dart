//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_field_visitors_dto_output.g.dart';

/// AdminFieldVisitorsDtoOutput
///
/// Properties:
/// * [visitors]
@BuiltValue()
abstract class AdminFieldVisitorsDtoOutput
    implements
        Built<AdminFieldVisitorsDtoOutput, AdminFieldVisitorsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'visitors')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get visitors;

  AdminFieldVisitorsDtoOutput._();

  factory AdminFieldVisitorsDtoOutput([
    void updates(AdminFieldVisitorsDtoOutputBuilder b),
  ]) = _$AdminFieldVisitorsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFieldVisitorsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFieldVisitorsDtoOutput> get serializer =>
      _$AdminFieldVisitorsDtoOutputSerializer();
}

class _$AdminFieldVisitorsDtoOutputSerializer
    implements PrimitiveSerializer<AdminFieldVisitorsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminFieldVisitorsDtoOutput,
    _$AdminFieldVisitorsDtoOutput,
  ];

  @override
  final String wireName = r'AdminFieldVisitorsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFieldVisitorsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'visitors';
    yield serializers.serialize(
      object.visitors,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminFieldVisitorsDtoOutput object, {
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
    required AdminFieldVisitorsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'visitors':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>;
          result.visitors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminFieldVisitorsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFieldVisitorsDtoOutputBuilder();
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
