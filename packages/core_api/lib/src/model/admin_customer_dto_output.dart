//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_tickets_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_late_cancels.dart';
import 'package:core_api/src/model/date.dart';
import 'package:core_api/src/model/admin_customer_dto_output_block_reasons_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_review_stop.dart';
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_notes_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_codes_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_block.dart';
import 'package:core_api/src/model/admin_customer_dto_output_orders.dart';
import 'package:core_api/src/model/admin_customer_dto_output_trust_mark.dart';
import 'package:core_api/src/model/admin_customer_dto_output_blocks_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_dues.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output.g.dart';

/// AdminCustomerDtoOutput
///
/// Properties:
/// * [id]
/// * [firstName]
/// * [lastName]
/// * [gender]
/// * [birthday]
/// * [maskedPhone]
/// * [status] - «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).
/// * [block]
/// * [reviewStop]
/// * [trusted] - «موثوق» by D23 and the latest mark.
/// * [delivered] - The normal deliveries that count toward the trust.
/// * [trustedAfter]
/// * [trustMark]
/// * [lateCancels]
/// * [fakeOrders]
/// * [dues]
/// * [blocks]
/// * [blockReasons] - Content's active customer_block reasons (AP Appendix B).
/// * [orders]
/// * [tickets]
/// * [codes] - The codes used in the city, newest first.
/// * [addresses]
/// * [notes]
@BuiltValue()
abstract class AdminCustomerDtoOutput
    implements Built<AdminCustomerDtoOutput, AdminCustomerDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'firstName')
  String? get firstName;

  @BuiltValueField(wireName: r'lastName')
  String? get lastName;

  @BuiltValueField(wireName: r'gender')
  AdminCustomerDtoOutputGenderEnum? get gender;
  // enum genderEnum {  male,  female,  };

  @BuiltValueField(wireName: r'birthday')
  Date? get birthday;

  @BuiltValueField(wireName: r'maskedPhone')
  String? get maskedPhone;

  /// «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).
  @BuiltValueField(wireName: r'status')
  AdminCustomerDtoOutputStatusEnum get status;
  // enum statusEnum {  active,  blocked,  dues_unpaid,  review_stop,  };

  @BuiltValueField(wireName: r'block')
  AdminCustomerDtoOutputBlock? get block;

  @BuiltValueField(wireName: r'reviewStop')
  AdminCustomerDtoOutputReviewStop? get reviewStop;

  /// «موثوق» by D23 and the latest mark.
  @BuiltValueField(wireName: r'trusted')
  bool get trusted;

  /// The normal deliveries that count toward the trust.
  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  @BuiltValueField(wireName: r'trustedAfter')
  int get trustedAfter;

  @BuiltValueField(wireName: r'trustMark')
  AdminCustomerDtoOutputTrustMark? get trustMark;

  @BuiltValueField(wireName: r'lateCancels')
  AdminCustomerDtoOutputLateCancels get lateCancels;

  @BuiltValueField(wireName: r'fakeOrders')
  int get fakeOrders;

  @BuiltValueField(wireName: r'dues')
  AdminCustomerDtoOutputDues get dues;

  @BuiltValueField(wireName: r'blocks')
  BuiltList<AdminCustomerDtoOutputBlocksInner> get blocks;

  /// Content's active customer_block reasons (AP Appendix B).
  @BuiltValueField(wireName: r'blockReasons')
  BuiltList<AdminCustomerDtoOutputBlockReasonsInner> get blockReasons;

  @BuiltValueField(wireName: r'orders')
  AdminCustomerDtoOutputOrders get orders;

  @BuiltValueField(wireName: r'tickets')
  BuiltList<AdminCustomerDtoOutputTicketsInner> get tickets;

  /// The codes used in the city, newest first.
  @BuiltValueField(wireName: r'codes')
  BuiltList<AdminCustomerDtoOutputCodesInner> get codes;

  @BuiltValueField(wireName: r'addresses')
  BuiltList<AdminCustomerDtoOutputAddressesInner> get addresses;

  @BuiltValueField(wireName: r'notes')
  BuiltList<AdminCustomerDtoOutputNotesInner> get notes;

  AdminCustomerDtoOutput._();

  factory AdminCustomerDtoOutput([
    void updates(AdminCustomerDtoOutputBuilder b),
  ]) = _$AdminCustomerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutput> get serializer =>
      _$AdminCustomerDtoOutputSerializer();
}

class _$AdminCustomerDtoOutputSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutput,
    _$AdminCustomerDtoOutput,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'firstName';
    yield object.firstName == null
        ? null
        : serializers.serialize(
            object.firstName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'lastName';
    yield object.lastName == null
        ? null
        : serializers.serialize(
            object.lastName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'gender';
    yield object.gender == null
        ? null
        : serializers.serialize(
            object.gender,
            specifiedType: const FullType.nullable(
              AdminCustomerDtoOutputGenderEnum,
            ),
          );
    yield r'birthday';
    yield object.birthday == null
        ? null
        : serializers.serialize(
            object.birthday,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'maskedPhone';
    yield object.maskedPhone == null
        ? null
        : serializers.serialize(
            object.maskedPhone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminCustomerDtoOutputStatusEnum),
    );
    yield r'block';
    yield object.block == null
        ? null
        : serializers.serialize(
            object.block,
            specifiedType: const FullType.nullable(AdminCustomerDtoOutputBlock),
          );
    yield r'reviewStop';
    yield object.reviewStop == null
        ? null
        : serializers.serialize(
            object.reviewStop,
            specifiedType: const FullType.nullable(
              AdminCustomerDtoOutputReviewStop,
            ),
          );
    yield r'trusted';
    yield serializers.serialize(
      object.trusted,
      specifiedType: const FullType(bool),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
    yield r'trustedAfter';
    yield serializers.serialize(
      object.trustedAfter,
      specifiedType: const FullType(int),
    );
    yield r'trustMark';
    yield object.trustMark == null
        ? null
        : serializers.serialize(
            object.trustMark,
            specifiedType: const FullType.nullable(
              AdminCustomerDtoOutputTrustMark,
            ),
          );
    yield r'lateCancels';
    yield serializers.serialize(
      object.lateCancels,
      specifiedType: const FullType(AdminCustomerDtoOutputLateCancels),
    );
    yield r'fakeOrders';
    yield serializers.serialize(
      object.fakeOrders,
      specifiedType: const FullType(int),
    );
    yield r'dues';
    yield serializers.serialize(
      object.dues,
      specifiedType: const FullType(AdminCustomerDtoOutputDues),
    );
    yield r'blocks';
    yield serializers.serialize(
      object.blocks,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputBlocksInner),
      ]),
    );
    yield r'blockReasons';
    yield serializers.serialize(
      object.blockReasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputBlockReasonsInner),
      ]),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(AdminCustomerDtoOutputOrders),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputTicketsInner),
      ]),
    );
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputCodesInner),
      ]),
    );
    yield r'addresses';
    yield serializers.serialize(
      object.addresses,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputAddressesInner),
      ]),
    );
    yield r'notes';
    yield serializers.serialize(
      object.notes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputNotesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutput object, {
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
    required AdminCustomerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'firstName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.lastName = valueDes;
          break;
        case r'gender':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCustomerDtoOutputGenderEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputGenderEnum?;
          if (valueDes == null) continue;
          result.gender = valueDes;
          break;
        case r'birthday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.birthday = valueDes;
          break;
        case r'maskedPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maskedPhone = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputStatusEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'block':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCustomerDtoOutputBlock,
                    ),
                  )
                  as AdminCustomerDtoOutputBlock?;
          if (valueDes == null) continue;
          result.block.replace(valueDes);
          break;
        case r'reviewStop':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCustomerDtoOutputReviewStop,
                    ),
                  )
                  as AdminCustomerDtoOutputReviewStop?;
          if (valueDes == null) continue;
          result.reviewStop.replace(valueDes);
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
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        case r'trustedAfter':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.trustedAfter = valueDes;
          break;
        case r'trustMark':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCustomerDtoOutputTrustMark,
                    ),
                  )
                  as AdminCustomerDtoOutputTrustMark?;
          if (valueDes == null) continue;
          result.trustMark.replace(valueDes);
          break;
        case r'lateCancels':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputLateCancels,
                    ),
                  )
                  as AdminCustomerDtoOutputLateCancels;
          result.lateCancels.replace(valueDes);
          break;
        case r'fakeOrders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.fakeOrders = valueDes;
          break;
        case r'dues':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminCustomerDtoOutputDues),
                  )
                  as AdminCustomerDtoOutputDues;
          result.dues.replace(valueDes);
          break;
        case r'blocks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputBlocksInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputBlocksInner>;
          result.blocks.replace(valueDes);
          break;
        case r'blockReasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputBlockReasonsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputBlockReasonsInner>;
          result.blockReasons.replace(valueDes);
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminCustomerDtoOutputOrders),
                  )
                  as AdminCustomerDtoOutputOrders;
          result.orders.replace(valueDes);
          break;
        case r'tickets':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputTicketsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputCodesInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputCodesInner>;
          result.codes.replace(valueDes);
          break;
        case r'addresses':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputAddressesInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputAddressesInner>;
          result.addresses.replace(valueDes);
          break;
        case r'notes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputNotesInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputNotesInner>;
          result.notes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputBuilder();
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

class AdminCustomerDtoOutputGenderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'male')
  static const AdminCustomerDtoOutputGenderEnum male =
      _$adminCustomerDtoOutputGenderEnum_male;
  @BuiltValueEnumConst(wireName: r'female')
  static const AdminCustomerDtoOutputGenderEnum female =
      _$adminCustomerDtoOutputGenderEnum_female;

  static Serializer<AdminCustomerDtoOutputGenderEnum> get serializer =>
      _$adminCustomerDtoOutputGenderEnumSerializer;

  const AdminCustomerDtoOutputGenderEnum._(String name) : super(name);

  static BuiltSet<AdminCustomerDtoOutputGenderEnum> get values =>
      _$adminCustomerDtoOutputGenderEnumValues;
  static AdminCustomerDtoOutputGenderEnum valueOf(String name) =>
      _$adminCustomerDtoOutputGenderEnumValueOf(name);
}

/// «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).
class AdminCustomerDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCustomerDtoOutputStatusEnum active =
      _$adminCustomerDtoOutputStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'blocked')
  static const AdminCustomerDtoOutputStatusEnum blocked =
      _$adminCustomerDtoOutputStatusEnum_blocked;
  @BuiltValueEnumConst(wireName: r'dues_unpaid')
  static const AdminCustomerDtoOutputStatusEnum duesUnpaid =
      _$adminCustomerDtoOutputStatusEnum_duesUnpaid;
  @BuiltValueEnumConst(wireName: r'review_stop')
  static const AdminCustomerDtoOutputStatusEnum reviewStop =
      _$adminCustomerDtoOutputStatusEnum_reviewStop;

  static Serializer<AdminCustomerDtoOutputStatusEnum> get serializer =>
      _$adminCustomerDtoOutputStatusEnumSerializer;

  const AdminCustomerDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminCustomerDtoOutputStatusEnum> get values =>
      _$adminCustomerDtoOutputStatusEnumValues;
  static AdminCustomerDtoOutputStatusEnum valueOf(String name) =>
      _$adminCustomerDtoOutputStatusEnumValueOf(name);
}
