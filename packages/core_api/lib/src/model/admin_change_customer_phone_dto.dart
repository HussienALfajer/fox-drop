//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_customer_phone_dto.g.dart';

/// AdminChangeCustomerPhoneDto
///
/// Properties:
/// * [cityId]
/// * [phone] - The new Syrian or Turkish mobile, in any usual form.
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminChangeCustomerPhoneDto
    implements
        Built<AdminChangeCustomerPhoneDto, AdminChangeCustomerPhoneDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The new Syrian or Turkish mobile, in any usual form.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminChangeCustomerPhoneDto._();

  factory AdminChangeCustomerPhoneDto([
    void updates(AdminChangeCustomerPhoneDtoBuilder b),
  ]) = _$AdminChangeCustomerPhoneDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeCustomerPhoneDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeCustomerPhoneDto> get serializer =>
      _$AdminChangeCustomerPhoneDtoSerializer();
}

class _$AdminChangeCustomerPhoneDtoSerializer
    implements PrimitiveSerializer<AdminChangeCustomerPhoneDto> {
  @override
  final Iterable<Type> types = const [
    AdminChangeCustomerPhoneDto,
    _$AdminChangeCustomerPhoneDto,
  ];

  @override
  final String wireName = r'AdminChangeCustomerPhoneDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeCustomerPhoneDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeCustomerPhoneDto object, {
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
    required AdminChangeCustomerPhoneDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeCustomerPhoneDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeCustomerPhoneDtoBuilder();
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
