//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_search_dto.g.dart';

/// AdminCustomerSearchDto
///
/// Properties:
/// * [cityId] - The panel's city, whose dues the status reads.
/// * [q] - A number in any usual form, or a part of a name.
@BuiltValue()
abstract class AdminCustomerSearchDto
    implements Built<AdminCustomerSearchDto, AdminCustomerSearchDtoBuilder> {
  /// The panel's city, whose dues the status reads.
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A number in any usual form, or a part of a name.
  @BuiltValueField(wireName: r'q')
  String get q;

  AdminCustomerSearchDto._();

  factory AdminCustomerSearchDto([
    void updates(AdminCustomerSearchDtoBuilder b),
  ]) = _$AdminCustomerSearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerSearchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerSearchDto> get serializer =>
      _$AdminCustomerSearchDtoSerializer();
}

class _$AdminCustomerSearchDtoSerializer
    implements PrimitiveSerializer<AdminCustomerSearchDto> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerSearchDto,
    _$AdminCustomerSearchDto,
  ];

  @override
  final String wireName = r'AdminCustomerSearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'q';
    yield serializers.serialize(
      object.q,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerSearchDto object, {
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
    required AdminCustomerSearchDtoBuilder result,
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
        case r'q':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.q = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerSearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerSearchDtoBuilder();
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
