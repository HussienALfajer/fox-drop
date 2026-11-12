//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_office.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody.dart';
import 'package:core_api/src/model/captain_availability_dto_output_availability.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output.g.dart';

/// CaptainAvailabilityDtoOutput
///
/// Properties:
/// * [availability]
/// * [office]
/// * [custody]
@BuiltValue()
abstract class CaptainAvailabilityDtoOutput
    implements
        Built<
          CaptainAvailabilityDtoOutput,
          CaptainAvailabilityDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'availability')
  CaptainAvailabilityDtoOutputAvailability get availability;

  @BuiltValueField(wireName: r'office')
  CaptainAvailabilityDtoOutputOffice? get office;

  @BuiltValueField(wireName: r'custody')
  CaptainAvailabilityDtoOutputCustody get custody;

  CaptainAvailabilityDtoOutput._();

  factory CaptainAvailabilityDtoOutput([
    void updates(CaptainAvailabilityDtoOutputBuilder b),
  ]) = _$CaptainAvailabilityDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAvailabilityDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutput> get serializer =>
      _$CaptainAvailabilityDtoOutputSerializer();
}

class _$CaptainAvailabilityDtoOutputSerializer
    implements PrimitiveSerializer<CaptainAvailabilityDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutput,
    _$CaptainAvailabilityDtoOutput,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'availability';
    yield serializers.serialize(
      object.availability,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputAvailability),
    );
    yield r'office';
    yield object.office == null
        ? null
        : serializers.serialize(
            object.office,
            specifiedType: const FullType.nullable(
              CaptainAvailabilityDtoOutputOffice,
            ),
          );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustody),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutput object, {
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
    required CaptainAvailabilityDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'availability':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputAvailability,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputAvailability;
          result.availability.replace(valueDes);
          break;
        case r'office':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainAvailabilityDtoOutputOffice,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputOffice?;
          if (valueDes == null) continue;
          result.office.replace(valueDes);
          break;
        case r'custody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustody,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustody;
          result.custody.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputBuilder();
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
