//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_open_ticket_dto.g.dart';

/// AdminOpenTicketDto
///
/// Properties:
/// * [cityId]
/// * [party]
/// * [typeCode] - From the party's list (AP Appendix B).
/// * [description]
/// * [partyId]
/// * [restaurantId] - «سعر مختلف عن المحل» (typeCode price_difference): the restaurant it is about.
@BuiltValue()
abstract class AdminOpenTicketDto
    implements Built<AdminOpenTicketDto, AdminOpenTicketDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'party')
  AdminOpenTicketDtoPartyEnum get party;
  // enum partyEnum {  customer,  restaurant,  captain,  };

  /// From the party's list (AP Appendix B).
  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  /// «سعر مختلف عن المحل» (typeCode price_difference): the restaurant it is about.
  @BuiltValueField(wireName: r'restaurantId')
  String? get restaurantId;

  AdminOpenTicketDto._();

  factory AdminOpenTicketDto([void updates(AdminOpenTicketDtoBuilder b)]) =
      _$AdminOpenTicketDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOpenTicketDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOpenTicketDto> get serializer =>
      _$AdminOpenTicketDtoSerializer();
}

class _$AdminOpenTicketDtoSerializer
    implements PrimitiveSerializer<AdminOpenTicketDto> {
  @override
  final Iterable<Type> types = const [AdminOpenTicketDto, _$AdminOpenTicketDto];

  @override
  final String wireName = r'AdminOpenTicketDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOpenTicketDto object, {
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
      specifiedType: const FullType(AdminOpenTicketDtoPartyEnum),
    );
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    if (object.restaurantId != null) {
      yield r'restaurantId';
      yield serializers.serialize(
        object.restaurantId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenTicketDto object, {
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
    required AdminOpenTicketDtoBuilder result,
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
                    specifiedType: const FullType(AdminOpenTicketDtoPartyEnum),
                  )
                  as AdminOpenTicketDtoPartyEnum;
          result.party = valueDes;
          break;
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.description = valueDes;
          break;
        case r'partyId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyId = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOpenTicketDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOpenTicketDtoBuilder();
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

class AdminOpenTicketDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOpenTicketDtoPartyEnum customer =
      _$adminOpenTicketDtoPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOpenTicketDtoPartyEnum restaurant =
      _$adminOpenTicketDtoPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOpenTicketDtoPartyEnum captain =
      _$adminOpenTicketDtoPartyEnum_captain;

  static Serializer<AdminOpenTicketDtoPartyEnum> get serializer =>
      _$adminOpenTicketDtoPartyEnumSerializer;

  const AdminOpenTicketDtoPartyEnum._(String name) : super(name);

  static BuiltSet<AdminOpenTicketDtoPartyEnum> get values =>
      _$adminOpenTicketDtoPartyEnumValues;
  static AdminOpenTicketDtoPartyEnum valueOf(String name) =>
      _$adminOpenTicketDtoPartyEnumValueOf(name);
}
