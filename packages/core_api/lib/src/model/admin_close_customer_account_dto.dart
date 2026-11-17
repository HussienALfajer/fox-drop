//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_close_customer_account_dto.g.dart';

/// AdminCloseCustomerAccountDto
///
/// Properties:
/// * [cityId]
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminCloseCustomerAccountDto
    implements
        Built<
          AdminCloseCustomerAccountDto,
          AdminCloseCustomerAccountDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminCloseCustomerAccountDto._();

  factory AdminCloseCustomerAccountDto([
    void updates(AdminCloseCustomerAccountDtoBuilder b),
  ]) = _$AdminCloseCustomerAccountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCloseCustomerAccountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCloseCustomerAccountDto> get serializer =>
      _$AdminCloseCustomerAccountDtoSerializer();
}

class _$AdminCloseCustomerAccountDtoSerializer
    implements PrimitiveSerializer<AdminCloseCustomerAccountDto> {
  @override
  final Iterable<Type> types = const [
    AdminCloseCustomerAccountDto,
    _$AdminCloseCustomerAccountDto,
  ];

  @override
  final String wireName = r'AdminCloseCustomerAccountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCloseCustomerAccountDto object, {
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
    AdminCloseCustomerAccountDto object, {
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
    required AdminCloseCustomerAccountDtoBuilder result,
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
  AdminCloseCustomerAccountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCloseCustomerAccountDtoBuilder();
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
