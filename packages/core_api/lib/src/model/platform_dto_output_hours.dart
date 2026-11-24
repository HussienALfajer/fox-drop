//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_dto_output_hours.g.dart';

/// The customer app only, given a point: the platform hours of the point's city (CU §4.7).
///
/// Properties:
/// * [open] - Whether the platform takes orders now (platform.hours).
/// * [opensAt] - While closed, the next opening; null when open or when none is scheduled.
@BuiltValue()
abstract class PlatformDtoOutputHours
    implements Built<PlatformDtoOutputHours, PlatformDtoOutputHoursBuilder> {
  /// Whether the platform takes orders now (platform.hours).
  @BuiltValueField(wireName: r'open')
  bool get open;

  /// While closed, the next opening; null when open or when none is scheduled.
  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  PlatformDtoOutputHours._();

  factory PlatformDtoOutputHours([
    void updates(PlatformDtoOutputHoursBuilder b),
  ]) = _$PlatformDtoOutputHours;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformDtoOutputHoursBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformDtoOutputHours> get serializer =>
      _$PlatformDtoOutputHoursSerializer();
}

class _$PlatformDtoOutputHoursSerializer
    implements PrimitiveSerializer<PlatformDtoOutputHours> {
  @override
  final Iterable<Type> types = const [
    PlatformDtoOutputHours,
    _$PlatformDtoOutputHours,
  ];

  @override
  final String wireName = r'PlatformDtoOutputHours';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformDtoOutputHours object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'open';
    yield serializers.serialize(
      object.open,
      specifiedType: const FullType(bool),
    );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformDtoOutputHours object, {
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
    required PlatformDtoOutputHoursBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'open':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.open = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformDtoOutputHours deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformDtoOutputHoursBuilder();
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
