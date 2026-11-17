//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_ticket_money_preview_body_dto_affected_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_money_preview_body_dto.g.dart';

/// AdminTicketMoneyPreviewBodyDto
///
/// Properties:
/// * [cityId]
/// * [responsible]
/// * [affected] - The order's lines by position, each once, with how many were affected.
/// * [shortAmount]
/// * [code] - Whether the resolution is «كود تعويض».
/// * [redelivery] - Whether the resolution is «إعادة توصيل مجانية».
@BuiltValue()
abstract class AdminTicketMoneyPreviewBodyDto
    implements
        Built<
          AdminTicketMoneyPreviewBodyDto,
          AdminTicketMoneyPreviewBodyDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'responsible')
  AdminTicketMoneyPreviewBodyDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// The order's lines by position, each once, with how many were affected.
  @BuiltValueField(wireName: r'affected')
  BuiltList<AdminTicketMoneyPreviewBodyDtoAffectedInner> get affected;

  @BuiltValueField(wireName: r'shortAmount')
  String? get shortAmount;

  /// Whether the resolution is «كود تعويض».
  @BuiltValueField(wireName: r'code')
  bool get code;

  /// Whether the resolution is «إعادة توصيل مجانية».
  @BuiltValueField(wireName: r'redelivery')
  bool? get redelivery;

  AdminTicketMoneyPreviewBodyDto._();

  factory AdminTicketMoneyPreviewBodyDto([
    void updates(AdminTicketMoneyPreviewBodyDtoBuilder b),
  ]) = _$AdminTicketMoneyPreviewBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketMoneyPreviewBodyDtoBuilder b) =>
      b..redelivery = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketMoneyPreviewBodyDto> get serializer =>
      _$AdminTicketMoneyPreviewBodyDtoSerializer();
}

class _$AdminTicketMoneyPreviewBodyDtoSerializer
    implements PrimitiveSerializer<AdminTicketMoneyPreviewBodyDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketMoneyPreviewBodyDto,
    _$AdminTicketMoneyPreviewBodyDto,
  ];

  @override
  final String wireName = r'AdminTicketMoneyPreviewBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketMoneyPreviewBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(
        AdminTicketMoneyPreviewBodyDtoResponsibleEnum,
      ),
    );
    yield r'affected';
    yield serializers.serialize(
      object.affected,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminTicketMoneyPreviewBodyDtoAffectedInner),
      ]),
    );
    yield r'shortAmount';
    yield object.shortAmount == null
        ? null
        : serializers.serialize(
            object.shortAmount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(bool),
    );
    if (object.redelivery != null) {
      yield r'redelivery';
      yield serializers.serialize(
        object.redelivery,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketMoneyPreviewBodyDto object, {
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
    required AdminTicketMoneyPreviewBodyDtoBuilder result,
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
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketMoneyPreviewBodyDtoResponsibleEnum,
                    ),
                  )
                  as AdminTicketMoneyPreviewBodyDtoResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'affected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminTicketMoneyPreviewBodyDtoAffectedInner),
                    ]),
                  )
                  as BuiltList<AdminTicketMoneyPreviewBodyDtoAffectedInner>;
          result.affected.replace(valueDes);
          break;
        case r'shortAmount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.shortAmount = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.code = valueDes;
          break;
        case r'redelivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.redelivery = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketMoneyPreviewBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketMoneyPreviewBodyDtoBuilder();
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

class AdminTicketMoneyPreviewBodyDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketMoneyPreviewBodyDtoResponsibleEnum restaurant =
      _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminTicketMoneyPreviewBodyDtoResponsibleEnum captain =
      _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminTicketMoneyPreviewBodyDtoResponsibleEnum customer =
      _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminTicketMoneyPreviewBodyDtoResponsibleEnum platform =
      _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_platform;

  static Serializer<AdminTicketMoneyPreviewBodyDtoResponsibleEnum>
  get serializer => _$adminTicketMoneyPreviewBodyDtoResponsibleEnumSerializer;

  const AdminTicketMoneyPreviewBodyDtoResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminTicketMoneyPreviewBodyDtoResponsibleEnum> get values =>
      _$adminTicketMoneyPreviewBodyDtoResponsibleEnumValues;
  static AdminTicketMoneyPreviewBodyDtoResponsibleEnum valueOf(String name) =>
      _$adminTicketMoneyPreviewBodyDtoResponsibleEnumValueOf(name);
}
