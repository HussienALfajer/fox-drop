//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_accept_dto.g.dart';

/// AdminAcceptDto
///
/// Properties:
/// * [prepMin] - Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.
/// * [reason] - Required (AP §9.3.2).
@BuiltValue()
abstract class AdminAcceptDto
    implements Built<AdminAcceptDto, AdminAcceptDtoBuilder> {
  /// Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.
  @BuiltValueField(wireName: r'prepMin')
  int get prepMin;

  /// Required (AP §9.3.2).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminAcceptDto._();

  factory AdminAcceptDto([void updates(AdminAcceptDtoBuilder b)]) =
      _$AdminAcceptDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAcceptDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAcceptDto> get serializer =>
      _$AdminAcceptDtoSerializer();
}

class _$AdminAcceptDtoSerializer
    implements PrimitiveSerializer<AdminAcceptDto> {
  @override
  final Iterable<Type> types = const [AdminAcceptDto, _$AdminAcceptDto];

  @override
  final String wireName = r'AdminAcceptDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAcceptDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'prepMin';
    yield serializers.serialize(
      object.prepMin,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAcceptDto object, {
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
    required AdminAcceptDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'prepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepMin = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAcceptDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAcceptDtoBuilder();
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
