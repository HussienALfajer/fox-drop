//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_clear_customer_strikes_dto.g.dart';

/// AdminClearCustomerStrikesDto
///
/// Properties:
/// * [cityId]
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminClearCustomerStrikesDto
    implements
        Built<
          AdminClearCustomerStrikesDto,
          AdminClearCustomerStrikesDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminClearCustomerStrikesDto._();

  factory AdminClearCustomerStrikesDto([
    void updates(AdminClearCustomerStrikesDtoBuilder b),
  ]) = _$AdminClearCustomerStrikesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminClearCustomerStrikesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminClearCustomerStrikesDto> get serializer =>
      _$AdminClearCustomerStrikesDtoSerializer();
}

class _$AdminClearCustomerStrikesDtoSerializer
    implements PrimitiveSerializer<AdminClearCustomerStrikesDto> {
  @override
  final Iterable<Type> types = const [
    AdminClearCustomerStrikesDto,
    _$AdminClearCustomerStrikesDto,
  ];

  @override
  final String wireName = r'AdminClearCustomerStrikesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminClearCustomerStrikesDto object, {
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
    AdminClearCustomerStrikesDto object, {
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
    required AdminClearCustomerStrikesDtoBuilder result,
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
  AdminClearCustomerStrikesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminClearCustomerStrikesDtoBuilder();
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
