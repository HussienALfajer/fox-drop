//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_switched_off_output.g.dart';

/// AdminMenuSwitchedOffOutput
///
/// Properties:
/// * [until] - «حتى الغد» ends at the next business-day cutoff; null is «حتى أعيده».
@BuiltValue()
abstract class AdminMenuSwitchedOffOutput
    implements
        Built<AdminMenuSwitchedOffOutput, AdminMenuSwitchedOffOutputBuilder> {
  /// «حتى الغد» ends at the next business-day cutoff; null is «حتى أعيده».
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  AdminMenuSwitchedOffOutput._();

  factory AdminMenuSwitchedOffOutput([
    void updates(AdminMenuSwitchedOffOutputBuilder b),
  ]) = _$AdminMenuSwitchedOffOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuSwitchedOffOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuSwitchedOffOutput> get serializer =>
      _$AdminMenuSwitchedOffOutputSerializer();
}

class _$AdminMenuSwitchedOffOutputSerializer
    implements PrimitiveSerializer<AdminMenuSwitchedOffOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuSwitchedOffOutput,
    _$AdminMenuSwitchedOffOutput,
  ];

  @override
  final String wireName = r'AdminMenuSwitchedOffOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuSwitchedOffOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuSwitchedOffOutput object, {
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
    required AdminMenuSwitchedOffOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuSwitchedOffOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuSwitchedOffOutputBuilder();
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
