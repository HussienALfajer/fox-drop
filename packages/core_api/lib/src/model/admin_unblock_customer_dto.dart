//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_unblock_customer_dto.g.dart';

/// AdminUnblockCustomerDto
///
/// Properties:
/// * [cityId]
/// * [blockId] - The block in force the panel showed.
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminUnblockCustomerDto
    implements Built<AdminUnblockCustomerDto, AdminUnblockCustomerDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The block in force the panel showed.
  @BuiltValueField(wireName: r'blockId')
  String get blockId;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminUnblockCustomerDto._();

  factory AdminUnblockCustomerDto([
    void updates(AdminUnblockCustomerDtoBuilder b),
  ]) = _$AdminUnblockCustomerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUnblockCustomerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUnblockCustomerDto> get serializer =>
      _$AdminUnblockCustomerDtoSerializer();
}

class _$AdminUnblockCustomerDtoSerializer
    implements PrimitiveSerializer<AdminUnblockCustomerDto> {
  @override
  final Iterable<Type> types = const [
    AdminUnblockCustomerDto,
    _$AdminUnblockCustomerDto,
  ];

  @override
  final String wireName = r'AdminUnblockCustomerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUnblockCustomerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'blockId';
    yield serializers.serialize(
      object.blockId,
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
    AdminUnblockCustomerDto object, {
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
    required AdminUnblockCustomerDtoBuilder result,
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
        case r'blockId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.blockId = valueDes;
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
  AdminUnblockCustomerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUnblockCustomerDtoBuilder();
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
