//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_arrive_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_cannot_complete_dto.g.dart';

/// CaptainCannotCompleteDto
///
/// Properties:
/// * [location]
/// * [reason] - A code of the captain_cannot_complete list (GET /v1/captain/content): «عطل في المركبة», «حادث», «ظرف طارئ», «لا أملك المبلغ المطلوب للمطعم», «أخرى» (with note).
/// * [note] - The text of a reason that needs one («أخرى»), and only of it.
@BuiltValue()
abstract class CaptainCannotCompleteDto
    implements
        Built<CaptainCannotCompleteDto, CaptainCannotCompleteDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  CaptainArriveDtoLocation get location;

  /// A code of the captain_cannot_complete list (GET /v1/captain/content): «عطل في المركبة», «حادث», «ظرف طارئ», «لا أملك المبلغ المطلوب للمطعم», «أخرى» (with note).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The text of a reason that needs one («أخرى»), and only of it.
  @BuiltValueField(wireName: r'note')
  String? get note;

  CaptainCannotCompleteDto._();

  factory CaptainCannotCompleteDto([
    void updates(CaptainCannotCompleteDtoBuilder b),
  ]) = _$CaptainCannotCompleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCannotCompleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCannotCompleteDto> get serializer =>
      _$CaptainCannotCompleteDtoSerializer();
}

class _$CaptainCannotCompleteDtoSerializer
    implements PrimitiveSerializer<CaptainCannotCompleteDto> {
  @override
  final Iterable<Type> types = const [
    CaptainCannotCompleteDto,
    _$CaptainCannotCompleteDto,
  ];

  @override
  final String wireName = r'CaptainCannotCompleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCannotCompleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CaptainArriveDtoLocation),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCannotCompleteDto object, {
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
    required CaptainCannotCompleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainArriveDtoLocation),
                  )
                  as CaptainArriveDtoLocation;
          result.location.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCannotCompleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCannotCompleteDtoBuilder();
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
