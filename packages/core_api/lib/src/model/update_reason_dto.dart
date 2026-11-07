//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_reason_dto.g.dart';

/// UpdateReasonDto
///
/// Properties:
/// * [label]
/// * [customerText] - Only in the lists with customer texts; null shows the generic apology.
/// * [needsText] - «أخرى»: the choice needs its text.
/// * [active] - False removes it from the list.
@BuiltValue()
abstract class UpdateReasonDto
    implements Built<UpdateReasonDto, UpdateReasonDtoBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  /// Only in the lists with customer texts; null shows the generic apology.
  @BuiltValueField(wireName: r'customerText')
  String? get customerText;

  /// «أخرى»: the choice needs its text.
  @BuiltValueField(wireName: r'needsText')
  bool get needsText;

  /// False removes it from the list.
  @BuiltValueField(wireName: r'active')
  bool get active;

  UpdateReasonDto._();

  factory UpdateReasonDto([void updates(UpdateReasonDtoBuilder b)]) =
      _$UpdateReasonDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateReasonDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateReasonDto> get serializer =>
      _$UpdateReasonDtoSerializer();
}

class _$UpdateReasonDtoSerializer
    implements PrimitiveSerializer<UpdateReasonDto> {
  @override
  final Iterable<Type> types = const [UpdateReasonDto, _$UpdateReasonDto];

  @override
  final String wireName = r'UpdateReasonDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateReasonDto object, {
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
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateReasonDto object, {
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
    required UpdateReasonDtoBuilder result,
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
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateReasonDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateReasonDtoBuilder();
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
