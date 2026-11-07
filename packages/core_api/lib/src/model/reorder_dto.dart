//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reorder_dto.g.dart';

/// ReorderDto
///
/// Properties:
/// * [codes] - Every code of the list.
@BuiltValue()
abstract class ReorderDto implements Built<ReorderDto, ReorderDtoBuilder> {
  /// Every code of the list.
  @BuiltValueField(wireName: r'codes')
  BuiltList<String> get codes;

  ReorderDto._();

  factory ReorderDto([void updates(ReorderDtoBuilder b)]) = _$ReorderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReorderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReorderDto> get serializer => _$ReorderDtoSerializer();
}

class _$ReorderDtoSerializer implements PrimitiveSerializer<ReorderDto> {
  @override
  final Iterable<Type> types = const [ReorderDto, _$ReorderDto];

  @override
  final String wireName = r'ReorderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReorderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReorderDto object, {
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
    required ReorderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.codes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReorderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReorderDtoBuilder();
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
