//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_personal_dto.g.dart';

/// CaptainApplicationPersonalDto
///
/// Properties:
/// * [fullName] - Three parts at least, 80 characters at most.
/// * [birthDate] - A calendar day, YYYY-MM-DD.
/// * [zoneId] - One of GET /v1/captain/application/zones.
@BuiltValue()
abstract class CaptainApplicationPersonalDto
    implements
        Built<
          CaptainApplicationPersonalDto,
          CaptainApplicationPersonalDtoBuilder
        > {
  /// Three parts at least, 80 characters at most.
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  /// A calendar day, YYYY-MM-DD.
  @BuiltValueField(wireName: r'birthDate')
  Date get birthDate;

  /// One of GET /v1/captain/application/zones.
  @BuiltValueField(wireName: r'zoneId')
  String get zoneId;

  CaptainApplicationPersonalDto._();

  factory CaptainApplicationPersonalDto([
    void updates(CaptainApplicationPersonalDtoBuilder b),
  ]) = _$CaptainApplicationPersonalDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationPersonalDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationPersonalDto> get serializer =>
      _$CaptainApplicationPersonalDtoSerializer();
}

class _$CaptainApplicationPersonalDtoSerializer
    implements PrimitiveSerializer<CaptainApplicationPersonalDto> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationPersonalDto,
    _$CaptainApplicationPersonalDto,
  ];

  @override
  final String wireName = r'CaptainApplicationPersonalDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationPersonalDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'birthDate';
    yield serializers.serialize(
      object.birthDate,
      specifiedType: const FullType(Date),
    );
    yield r'zoneId';
    yield serializers.serialize(
      object.zoneId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationPersonalDto object, {
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
    required CaptainApplicationPersonalDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fullName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fullName = valueDes;
          break;
        case r'birthDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.birthDate = valueDes;
          break;
        case r'zoneId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.zoneId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationPersonalDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationPersonalDtoBuilder();
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
