//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_mass_push_audience_dto_output.g.dart';

/// AdminMassPushAudienceDtoOutput
///
/// Properties:
/// * [size] - The customers in the audience now.
@BuiltValue()
abstract class AdminMassPushAudienceDtoOutput
    implements
        Built<
          AdminMassPushAudienceDtoOutput,
          AdminMassPushAudienceDtoOutputBuilder
        > {
  /// The customers in the audience now.
  @BuiltValueField(wireName: r'size')
  int get size;

  AdminMassPushAudienceDtoOutput._();

  factory AdminMassPushAudienceDtoOutput([
    void updates(AdminMassPushAudienceDtoOutputBuilder b),
  ]) = _$AdminMassPushAudienceDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMassPushAudienceDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMassPushAudienceDtoOutput> get serializer =>
      _$AdminMassPushAudienceDtoOutputSerializer();
}

class _$AdminMassPushAudienceDtoOutputSerializer
    implements PrimitiveSerializer<AdminMassPushAudienceDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMassPushAudienceDtoOutput,
    _$AdminMassPushAudienceDtoOutput,
  ];

  @override
  final String wireName = r'AdminMassPushAudienceDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMassPushAudienceDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMassPushAudienceDtoOutput object, {
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
    required AdminMassPushAudienceDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'size':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.size = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMassPushAudienceDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMassPushAudienceDtoOutputBuilder();
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
