//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_update_contact_dto.g.dart';

/// AdminUpdateContactDto
///
/// Properties:
/// * [phone] - E.164, or null to hide «اتصال بالدعم».
/// * [whatsapp] - E.164, or null to hide «واتساب الدعم».
@BuiltValue()
abstract class AdminUpdateContactDto implements Built<AdminUpdateContactDto, AdminUpdateContactDtoBuilder> {
  /// E.164, or null to hide «اتصال بالدعم».
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  /// E.164, or null to hide «واتساب الدعم».
  @BuiltValueField(wireName: r'whatsapp')
  String? get whatsapp;

  AdminUpdateContactDto._();

  factory AdminUpdateContactDto([void updates(AdminUpdateContactDtoBuilder b)]) = _$AdminUpdateContactDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUpdateContactDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUpdateContactDto> get serializer => _$AdminUpdateContactDtoSerializer();
}

class _$AdminUpdateContactDtoSerializer implements PrimitiveSerializer<AdminUpdateContactDto> {
  @override
  final Iterable<Type> types = const [AdminUpdateContactDto, _$AdminUpdateContactDto];

  @override
  final String wireName = r'AdminUpdateContactDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUpdateContactDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'whatsapp';
    yield object.whatsapp == null ? null : serializers.serialize(
      object.whatsapp,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUpdateContactDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUpdateContactDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'whatsapp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.whatsapp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUpdateContactDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUpdateContactDtoBuilder();
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


