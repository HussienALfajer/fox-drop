//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_office_hours_inner.g.dart';

/// CaptainAvailabilityDtoOutputOfficeHoursInner
///
/// Properties:
/// * [weekday] - 0 Sunday to 6 Saturday.
/// * [opensAt] - Minutes after midnight on the city clock.
/// * [closesAt] - Minutes after midnight; at or before the opening it runs past midnight.
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputOfficeHoursInner
    implements
        Built<
          CaptainAvailabilityDtoOutputOfficeHoursInner,
          CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder
        > {
  /// 0 Sunday to 6 Saturday.
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  /// Minutes after midnight on the city clock.
  @BuiltValueField(wireName: r'opensAt')
  int get opensAt;

  /// Minutes after midnight; at or before the opening it runs past midnight.
  @BuiltValueField(wireName: r'closesAt')
  int get closesAt;

  CaptainAvailabilityDtoOutputOfficeHoursInner._();

  factory CaptainAvailabilityDtoOutputOfficeHoursInner([
    void updates(CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder b),
  ]) = _$CaptainAvailabilityDtoOutputOfficeHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputOfficeHoursInner>
  get serializer => _$CaptainAvailabilityDtoOutputOfficeHoursInnerSerializer();
}

class _$CaptainAvailabilityDtoOutputOfficeHoursInnerSerializer
    implements
        PrimitiveSerializer<CaptainAvailabilityDtoOutputOfficeHoursInner> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputOfficeHoursInner,
    _$CaptainAvailabilityDtoOutputOfficeHoursInner,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputOfficeHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputOfficeHoursInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    yield r'opensAt';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(int),
    );
    yield r'closesAt';
    yield serializers.serialize(
      object.closesAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputOfficeHoursInner object, {
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
    required CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.weekday = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputOfficeHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder();
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
