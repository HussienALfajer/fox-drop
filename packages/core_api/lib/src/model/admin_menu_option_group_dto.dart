//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_option_group_dto.g.dart';

/// AdminMenuOptionGroupDto
///
/// Properties:
/// * [name]
/// * [minChoices] - 0: an add-on group; 1 or more: required.
/// * [maxChoices] - At least the minimum; once it has options, at most their count.
@BuiltValue()
abstract class AdminMenuOptionGroupDto
    implements Built<AdminMenuOptionGroupDto, AdminMenuOptionGroupDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// 0: an add-on group; 1 or more: required.
  @BuiltValueField(wireName: r'minChoices')
  int get minChoices;

  /// At least the minimum; once it has options, at most their count.
  @BuiltValueField(wireName: r'maxChoices')
  int get maxChoices;

  AdminMenuOptionGroupDto._();

  factory AdminMenuOptionGroupDto([
    void updates(AdminMenuOptionGroupDtoBuilder b),
  ]) = _$AdminMenuOptionGroupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuOptionGroupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuOptionGroupDto> get serializer =>
      _$AdminMenuOptionGroupDtoSerializer();
}

class _$AdminMenuOptionGroupDtoSerializer
    implements PrimitiveSerializer<AdminMenuOptionGroupDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuOptionGroupDto,
    _$AdminMenuOptionGroupDto,
  ];

  @override
  final String wireName = r'AdminMenuOptionGroupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuOptionGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'minChoices';
    yield serializers.serialize(
      object.minChoices,
      specifiedType: const FullType(int),
    );
    yield r'maxChoices';
    yield serializers.serialize(
      object.maxChoices,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuOptionGroupDto object, {
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
    required AdminMenuOptionGroupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'minChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.minChoices = valueDes;
          break;
        case r'maxChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.maxChoices = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuOptionGroupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuOptionGroupDtoBuilder();
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
