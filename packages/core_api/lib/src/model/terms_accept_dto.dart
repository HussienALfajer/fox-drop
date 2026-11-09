//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'terms_accept_dto.g.dart';

/// TermsAcceptDto
///
/// Properties:
/// * [version] 
@BuiltValue()
abstract class TermsAcceptDto implements Built<TermsAcceptDto, TermsAcceptDtoBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  TermsAcceptDto._();

  factory TermsAcceptDto([void updates(TermsAcceptDtoBuilder b)]) = _$TermsAcceptDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TermsAcceptDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TermsAcceptDto> get serializer => _$TermsAcceptDtoSerializer();
}

class _$TermsAcceptDtoSerializer implements PrimitiveSerializer<TermsAcceptDto> {
  @override
  final Iterable<Type> types = const [TermsAcceptDto, _$TermsAcceptDto];

  @override
  final String wireName = r'TermsAcceptDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TermsAcceptDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TermsAcceptDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TermsAcceptDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TermsAcceptDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TermsAcceptDtoBuilder();
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


