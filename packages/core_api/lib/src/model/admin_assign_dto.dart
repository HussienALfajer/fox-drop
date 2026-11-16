//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_assign_dto.g.dart';

/// AdminAssignDto
///
/// Properties:
/// * [captainId] - An eligible captain from the assignment picker.
@BuiltValue()
abstract class AdminAssignDto implements Built<AdminAssignDto, AdminAssignDtoBuilder> {
  /// An eligible captain from the assignment picker.
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  AdminAssignDto._();

  factory AdminAssignDto([void updates(AdminAssignDtoBuilder b)]) = _$AdminAssignDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAssignDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAssignDto> get serializer => _$AdminAssignDtoSerializer();
}

class _$AdminAssignDtoSerializer implements PrimitiveSerializer<AdminAssignDto> {
  @override
  final Iterable<Type> types = const [AdminAssignDto, _$AdminAssignDto];

  @override
  final String wireName = r'AdminAssignDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAssignDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAssignDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAssignDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.captainId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAssignDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAssignDtoBuilder();
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


