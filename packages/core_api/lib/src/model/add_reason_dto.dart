//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'add_reason_dto.g.dart';

/// AddReasonDto
///
/// Properties:
/// * [label]
/// * [customerText] - Only in the lists with customer texts; null shows the generic apology.
/// * [needsText] - «أخرى»: the choice needs its text.
@BuiltValue()
abstract class AddReasonDto
    implements Built<AddReasonDto, AddReasonDtoBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  /// Only in the lists with customer texts; null shows the generic apology.
  @BuiltValueField(wireName: r'customerText')
  String? get customerText;

  /// «أخرى»: the choice needs its text.
  @BuiltValueField(wireName: r'needsText')
  bool get needsText;

  AddReasonDto._();

  factory AddReasonDto([void updates(AddReasonDtoBuilder b)]) = _$AddReasonDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AddReasonDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AddReasonDto> get serializer => _$AddReasonDtoSerializer();
}

class _$AddReasonDtoSerializer implements PrimitiveSerializer<AddReasonDto> {
  @override
  final Iterable<Type> types = const [AddReasonDto, _$AddReasonDto];

  @override
  final String wireName = r'AddReasonDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AddReasonDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'customerText';
    yield object.customerText == null
        ? null
        : serializers.serialize(
            object.customerText,
            specifiedType: const FullType.nullable(String),
          );
    yield r'needsText';
    yield serializers.serialize(
      object.needsText,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AddReasonDto object, {
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
    required AddReasonDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'customerText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customerText = valueDes;
          break;
        case r'needsText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.needsText = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AddReasonDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AddReasonDtoBuilder();
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
