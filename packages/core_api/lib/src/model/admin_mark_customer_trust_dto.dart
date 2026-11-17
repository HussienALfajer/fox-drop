//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_mark_customer_trust_dto.g.dart';

/// AdminMarkCustomerTrustDto
///
/// Properties:
/// * [cityId]
/// * [trusted] - «توثيق» (true) or «إزالة الثقة» (false).
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminMarkCustomerTrustDto
    implements
        Built<AdminMarkCustomerTrustDto, AdminMarkCustomerTrustDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// «توثيق» (true) or «إزالة الثقة» (false).
  @BuiltValueField(wireName: r'trusted')
  bool get trusted;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminMarkCustomerTrustDto._();

  factory AdminMarkCustomerTrustDto([
    void updates(AdminMarkCustomerTrustDtoBuilder b),
  ]) = _$AdminMarkCustomerTrustDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMarkCustomerTrustDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMarkCustomerTrustDto> get serializer =>
      _$AdminMarkCustomerTrustDtoSerializer();
}

class _$AdminMarkCustomerTrustDtoSerializer
    implements PrimitiveSerializer<AdminMarkCustomerTrustDto> {
  @override
  final Iterable<Type> types = const [
    AdminMarkCustomerTrustDto,
    _$AdminMarkCustomerTrustDto,
  ];

  @override
  final String wireName = r'AdminMarkCustomerTrustDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMarkCustomerTrustDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'trusted';
    yield serializers.serialize(
      object.trusted,
      specifiedType: const FullType(bool),
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
    AdminMarkCustomerTrustDto object, {
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
    required AdminMarkCustomerTrustDtoBuilder result,
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
        case r'trusted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.trusted = valueDes;
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
  AdminMarkCustomerTrustDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMarkCustomerTrustDtoBuilder();
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
