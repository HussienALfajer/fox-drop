//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_refresh_dto.g.dart';

/// CaptainRefreshDto
///
/// Properties:
/// * [refreshToken] 
@BuiltValue()
abstract class CaptainRefreshDto implements Built<CaptainRefreshDto, CaptainRefreshDtoBuilder> {
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  CaptainRefreshDto._();

  factory CaptainRefreshDto([void updates(CaptainRefreshDtoBuilder b)]) = _$CaptainRefreshDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainRefreshDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainRefreshDto> get serializer => _$CaptainRefreshDtoSerializer();
}

class _$CaptainRefreshDtoSerializer implements PrimitiveSerializer<CaptainRefreshDto> {
  @override
  final Iterable<Type> types = const [CaptainRefreshDto, _$CaptainRefreshDto];

  @override
  final String wireName = r'CaptainRefreshDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainRefreshDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainRefreshDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainRefreshDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainRefreshDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainRefreshDtoBuilder();
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


