//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_draft_location_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_location_dto.g.dart';

/// AdminDraftLocationDto
///
/// Properties:
/// * [location]
/// * [address]
/// * [phone] - The restaurant's number in E.164.
/// * [ownerName]
/// * [ownerPhone] - The owner's number in E.164 (a contact).
@BuiltValue()
abstract class AdminDraftLocationDto
    implements Built<AdminDraftLocationDto, AdminDraftLocationDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  AdminDraftLocationDtoLocation get location;

  @BuiltValueField(wireName: r'address')
  String? get address;

  /// The restaurant's number in E.164.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'ownerName')
  String? get ownerName;

  /// The owner's number in E.164 (a contact).
  @BuiltValueField(wireName: r'ownerPhone')
  String? get ownerPhone;

  AdminDraftLocationDto._();

  factory AdminDraftLocationDto([
    void updates(AdminDraftLocationDtoBuilder b),
  ]) = _$AdminDraftLocationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftLocationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftLocationDto> get serializer =>
      _$AdminDraftLocationDtoSerializer();
}

class _$AdminDraftLocationDtoSerializer
    implements PrimitiveSerializer<AdminDraftLocationDto> {
  @override
  final Iterable<Type> types = const [
    AdminDraftLocationDto,
    _$AdminDraftLocationDto,
  ];

  @override
  final String wireName = r'AdminDraftLocationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftLocationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(AdminDraftLocationDtoLocation),
    );
    yield r'address';
    yield object.address == null
        ? null
        : serializers.serialize(
            object.address,
            specifiedType: const FullType.nullable(String),
          );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ownerName';
    yield object.ownerName == null
        ? null
        : serializers.serialize(
            object.ownerName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ownerPhone';
    yield object.ownerPhone == null
        ? null
        : serializers.serialize(
            object.ownerPhone,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftLocationDto object, {
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
    required AdminDraftLocationDtoBuilder result,
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
                    specifiedType: const FullType(
                      AdminDraftLocationDtoLocation,
                    ),
                  )
                  as AdminDraftLocationDtoLocation;
          result.location.replace(valueDes);
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'ownerName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.ownerName = valueDes;
          break;
        case r'ownerPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.ownerPhone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftLocationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftLocationDtoBuilder();
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
