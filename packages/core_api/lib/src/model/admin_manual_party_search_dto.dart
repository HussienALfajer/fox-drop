//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_party_search_dto.g.dart';

/// AdminManualPartySearchDto
///
/// Properties:
/// * [cityId]
/// * [party]
/// * [q] - A part of the name (captain, restaurant), or the number (captain, customer).
@BuiltValue()
abstract class AdminManualPartySearchDto
    implements
        Built<AdminManualPartySearchDto, AdminManualPartySearchDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'party')
  AdminManualPartySearchDtoPartyEnum get party;
  // enum partyEnum {  captain,  restaurant,  customer,  };

  /// A part of the name (captain, restaurant), or the number (captain, customer).
  @BuiltValueField(wireName: r'q')
  String get q;

  AdminManualPartySearchDto._();

  factory AdminManualPartySearchDto([
    void updates(AdminManualPartySearchDtoBuilder b),
  ]) = _$AdminManualPartySearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualPartySearchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualPartySearchDto> get serializer =>
      _$AdminManualPartySearchDtoSerializer();
}

class _$AdminManualPartySearchDtoSerializer
    implements PrimitiveSerializer<AdminManualPartySearchDto> {
  @override
  final Iterable<Type> types = const [
    AdminManualPartySearchDto,
    _$AdminManualPartySearchDto,
  ];

  @override
  final String wireName = r'AdminManualPartySearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualPartySearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(AdminManualPartySearchDtoPartyEnum),
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
    AdminManualPartySearchDto object, {
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
    required AdminManualPartySearchDtoBuilder result,
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
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminManualPartySearchDtoPartyEnum,
                    ),
                  )
                  as AdminManualPartySearchDtoPartyEnum;
          result.party = valueDes;
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
  AdminManualPartySearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualPartySearchDtoBuilder();
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

class AdminManualPartySearchDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminManualPartySearchDtoPartyEnum captain =
      _$adminManualPartySearchDtoPartyEnum_captain;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminManualPartySearchDtoPartyEnum restaurant =
      _$adminManualPartySearchDtoPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminManualPartySearchDtoPartyEnum customer =
      _$adminManualPartySearchDtoPartyEnum_customer;

  static Serializer<AdminManualPartySearchDtoPartyEnum> get serializer =>
      _$adminManualPartySearchDtoPartyEnumSerializer;

  const AdminManualPartySearchDtoPartyEnum._(String name) : super(name);

  static BuiltSet<AdminManualPartySearchDtoPartyEnum> get values =>
      _$adminManualPartySearchDtoPartyEnumValues;
  static AdminManualPartySearchDtoPartyEnum valueOf(String name) =>
      _$adminManualPartySearchDtoPartyEnumValueOf(name);
}
