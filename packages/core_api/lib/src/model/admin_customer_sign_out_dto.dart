//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_sign_out_dto.g.dart';

/// AdminCustomerSignOutDto
///
/// Properties:
/// * [cityId]
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminCustomerSignOutDto
    implements Built<AdminCustomerSignOutDto, AdminCustomerSignOutDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminCustomerSignOutDto._();

  factory AdminCustomerSignOutDto([
    void updates(AdminCustomerSignOutDtoBuilder b),
  ]) = _$AdminCustomerSignOutDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerSignOutDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerSignOutDto> get serializer =>
      _$AdminCustomerSignOutDtoSerializer();
}

class _$AdminCustomerSignOutDtoSerializer
    implements PrimitiveSerializer<AdminCustomerSignOutDto> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerSignOutDto,
    _$AdminCustomerSignOutDto,
  ];

  @override
  final String wireName = r'AdminCustomerSignOutDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerSignOutDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
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
    AdminCustomerSignOutDto object, {
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
    required AdminCustomerSignOutDtoBuilder result,
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
  AdminCustomerSignOutDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerSignOutDtoBuilder();
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
