//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_party_search_dto.g.dart';

/// AdminTicketPartySearchDto
///
/// Properties:
/// * [cityId]
/// * [party]
/// * [q] - A part of the name, or the number.
@BuiltValue()
abstract class AdminTicketPartySearchDto
    implements
        Built<AdminTicketPartySearchDto, AdminTicketPartySearchDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'party')
  AdminTicketPartySearchDtoPartyEnum get party;
  // enum partyEnum {  customer,  restaurant,  captain,  };

  /// A part of the name, or the number.
  @BuiltValueField(wireName: r'q')
  String get q;

  AdminTicketPartySearchDto._();

  factory AdminTicketPartySearchDto([
    void updates(AdminTicketPartySearchDtoBuilder b),
  ]) = _$AdminTicketPartySearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPartySearchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPartySearchDto> get serializer =>
      _$AdminTicketPartySearchDtoSerializer();
}

class _$AdminTicketPartySearchDtoSerializer
    implements PrimitiveSerializer<AdminTicketPartySearchDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPartySearchDto,
    _$AdminTicketPartySearchDto,
  ];

  @override
  final String wireName = r'AdminTicketPartySearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPartySearchDto object, {
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
      specifiedType: const FullType(AdminTicketPartySearchDtoPartyEnum),
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
    AdminTicketPartySearchDto object, {
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
    required AdminTicketPartySearchDtoBuilder result,
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
                      AdminTicketPartySearchDtoPartyEnum,
                    ),
                  )
                  as AdminTicketPartySearchDtoPartyEnum;
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
  AdminTicketPartySearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPartySearchDtoBuilder();
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

class AdminTicketPartySearchDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminTicketPartySearchDtoPartyEnum customer =
      _$adminTicketPartySearchDtoPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketPartySearchDtoPartyEnum restaurant =
      _$adminTicketPartySearchDtoPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminTicketPartySearchDtoPartyEnum captain =
      _$adminTicketPartySearchDtoPartyEnum_captain;

  static Serializer<AdminTicketPartySearchDtoPartyEnum> get serializer =>
      _$adminTicketPartySearchDtoPartyEnumSerializer;

  const AdminTicketPartySearchDtoPartyEnum._(String name) : super(name);

  static BuiltSet<AdminTicketPartySearchDtoPartyEnum> get values =>
      _$adminTicketPartySearchDtoPartyEnumValues;
  static AdminTicketPartySearchDtoPartyEnum valueOf(String name) =>
      _$adminTicketPartySearchDtoPartyEnumValueOf(name);
}
