//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_customer_test_account_dto.g.dart';

/// AdminSetCustomerTestAccountDto
///
/// Properties:
/// * [cityId]
/// * [flagged]
@BuiltValue()
abstract class AdminSetCustomerTestAccountDto
    implements
        Built<
          AdminSetCustomerTestAccountDto,
          AdminSetCustomerTestAccountDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'flagged')
  bool get flagged;

  AdminSetCustomerTestAccountDto._();

  factory AdminSetCustomerTestAccountDto([
    void updates(AdminSetCustomerTestAccountDtoBuilder b),
  ]) = _$AdminSetCustomerTestAccountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetCustomerTestAccountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetCustomerTestAccountDto> get serializer =>
      _$AdminSetCustomerTestAccountDtoSerializer();
}

class _$AdminSetCustomerTestAccountDtoSerializer
    implements PrimitiveSerializer<AdminSetCustomerTestAccountDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetCustomerTestAccountDto,
    _$AdminSetCustomerTestAccountDto,
  ];

  @override
  final String wireName = r'AdminSetCustomerTestAccountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetCustomerTestAccountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'flagged';
    yield serializers.serialize(
      object.flagged,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetCustomerTestAccountDto object, {
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
    required AdminSetCustomerTestAccountDtoBuilder result,
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
        case r'flagged':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.flagged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetCustomerTestAccountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetCustomerTestAccountDtoBuilder();
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
