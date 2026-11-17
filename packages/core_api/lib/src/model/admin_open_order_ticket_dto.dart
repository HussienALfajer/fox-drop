//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_open_order_ticket_dto.g.dart';

/// AdminOpenOrderTicketDto
///
/// Properties:
/// * [party]
/// * [typeCode] - From the party's list (AP Appendix B).
/// * [description]
@BuiltValue()
abstract class AdminOpenOrderTicketDto
    implements Built<AdminOpenOrderTicketDto, AdminOpenOrderTicketDtoBuilder> {
  @BuiltValueField(wireName: r'party')
  AdminOpenOrderTicketDtoPartyEnum get party;
  // enum partyEnum {  customer,  restaurant,  captain,  };

  /// From the party's list (AP Appendix B).
  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  @BuiltValueField(wireName: r'description')
  String get description;

  AdminOpenOrderTicketDto._();

  factory AdminOpenOrderTicketDto([
    void updates(AdminOpenOrderTicketDtoBuilder b),
  ]) = _$AdminOpenOrderTicketDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOpenOrderTicketDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOpenOrderTicketDto> get serializer =>
      _$AdminOpenOrderTicketDtoSerializer();
}

class _$AdminOpenOrderTicketDtoSerializer
    implements PrimitiveSerializer<AdminOpenOrderTicketDto> {
  @override
  final Iterable<Type> types = const [
    AdminOpenOrderTicketDto,
    _$AdminOpenOrderTicketDto,
  ];

  @override
  final String wireName = r'AdminOpenOrderTicketDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOpenOrderTicketDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(AdminOpenOrderTicketDtoPartyEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenOrderTicketDto object, {
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
    required AdminOpenOrderTicketDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOpenOrderTicketDtoPartyEnum,
                    ),
                  )
                  as AdminOpenOrderTicketDtoPartyEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOpenOrderTicketDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOpenOrderTicketDtoBuilder();
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

class AdminOpenOrderTicketDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOpenOrderTicketDtoPartyEnum customer =
      _$adminOpenOrderTicketDtoPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOpenOrderTicketDtoPartyEnum restaurant =
      _$adminOpenOrderTicketDtoPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOpenOrderTicketDtoPartyEnum captain =
      _$adminOpenOrderTicketDtoPartyEnum_captain;

  static Serializer<AdminOpenOrderTicketDtoPartyEnum> get serializer =>
      _$adminOpenOrderTicketDtoPartyEnumSerializer;

  const AdminOpenOrderTicketDtoPartyEnum._(String name) : super(name);

  static BuiltSet<AdminOpenOrderTicketDtoPartyEnum> get values =>
      _$adminOpenOrderTicketDtoPartyEnumValues;
  static AdminOpenOrderTicketDtoPartyEnum valueOf(String name) =>
      _$adminOpenOrderTicketDtoPartyEnumValueOf(name);
}
