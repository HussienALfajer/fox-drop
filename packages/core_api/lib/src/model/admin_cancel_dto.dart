//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_dto.g.dart';

/// AdminCancelDto
///
/// Properties:
/// * [cancellation] - A code of Content's ops_cancel list (AP Appendix B); 400 unknown_reason otherwise.
/// * [responsible] - The responsible party (docs/domain/09): «المطعم», «الكابتن», «الزبون», «المنصة».
/// * [foodPrepared] - «تم تحضير الطعام؟». From accepted or ready with the restaurant not responsible, the merchant net is credited on platform.operating_cost; true on a placed order is 400 invalid_cancellation.
/// * [compensateCaptain] - «تعويض الكابتن»: the pay table's base pay for the captain's vehicle; only once the assigned captain reached the restaurant (409 compensation_not_allowed; 409 captain_pay_unset without a rate).
/// * [cash] - «هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
/// * [reason] - Required (AP §9.3.2): the internal note, never shown to the apps.
@BuiltValue()
abstract class AdminCancelDto
    implements Built<AdminCancelDto, AdminCancelDtoBuilder> {
  /// A code of Content's ops_cancel list (AP Appendix B); 400 unknown_reason otherwise.
  @BuiltValueField(wireName: r'cancellation')
  String get cancellation;

  /// The responsible party (docs/domain/09): «المطعم», «الكابتن», «الزبون», «المنصة».
  @BuiltValueField(wireName: r'responsible')
  AdminCancelDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// «تم تحضير الطعام؟». From accepted or ready with the restaurant not responsible, the merchant net is credited on platform.operating_cost; true on a placed order is 400 invalid_cancellation.
  @BuiltValueField(wireName: r'foodPrepared')
  bool get foodPrepared;

  /// «تعويض الكابتن»: the pay table's base pay for the captain's vehicle; only once the assigned captain reached the restaurant (409 compensation_not_allowed; 409 captain_pay_unset without a rate).
  @BuiltValueField(wireName: r'compensateCaptain')
  bool get compensateCaptain;

  /// «هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
  @BuiltValueField(wireName: r'cash')
  AdminCancelDtoCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  /// Required (AP §9.3.2): the internal note, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCancelDto._();

  factory AdminCancelDto([void updates(AdminCancelDtoBuilder b)]) =
      _$AdminCancelDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancelDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelDto> get serializer =>
      _$AdminCancelDtoSerializer();
}

class _$AdminCancelDtoSerializer
    implements PrimitiveSerializer<AdminCancelDto> {
  @override
  final Iterable<Type> types = const [AdminCancelDto, _$AdminCancelDto];

  @override
  final String wireName = r'AdminCancelDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cancellation';
    yield serializers.serialize(
      object.cancellation,
      specifiedType: const FullType(String),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminCancelDtoResponsibleEnum),
    );
    yield r'foodPrepared';
    yield serializers.serialize(
      object.foodPrepared,
      specifiedType: const FullType(bool),
    );
    yield r'compensateCaptain';
    yield serializers.serialize(
      object.compensateCaptain,
      specifiedType: const FullType(bool),
    );
    yield r'cash';
    yield object.cash == null
        ? null
        : serializers.serialize(
            object.cash,
            specifiedType: const FullType.nullable(AdminCancelDtoCashEnum),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelDto object, {
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
    required AdminCancelDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cancellation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cancellation = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCancelDtoResponsibleEnum,
                    ),
                  )
                  as AdminCancelDtoResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'foodPrepared':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.foodPrepared = valueDes;
          break;
        case r'compensateCaptain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.compensateCaptain = valueDes;
          break;
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCancelDtoCashEnum,
                    ),
                  )
                  as AdminCancelDtoCashEnum?;
          if (valueDes == null) continue;
          result.cash = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCancelDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelDtoBuilder();
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

/// The responsible party (docs/domain/09): «المطعم», «الكابتن», «الزبون», «المنصة».
class AdminCancelDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminCancelDtoResponsibleEnum restaurant =
      _$adminCancelDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCancelDtoResponsibleEnum captain =
      _$adminCancelDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminCancelDtoResponsibleEnum customer =
      _$adminCancelDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminCancelDtoResponsibleEnum platform =
      _$adminCancelDtoResponsibleEnum_platform;

  static Serializer<AdminCancelDtoResponsibleEnum> get serializer =>
      _$adminCancelDtoResponsibleEnumSerializer;

  const AdminCancelDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminCancelDtoResponsibleEnum> get values =>
      _$adminCancelDtoResponsibleEnumValues;
  static AdminCancelDtoResponsibleEnum valueOf(String name) =>
      _$adminCancelDtoResponsibleEnumValueOf(name);
}

/// «هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
class AdminCancelDtoCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const AdminCancelDtoCashEnum returned =
      _$adminCancelDtoCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const AdminCancelDtoCashEnum notReturned =
      _$adminCancelDtoCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const AdminCancelDtoCashEnum notPaid =
      _$adminCancelDtoCashEnum_notPaid;

  static Serializer<AdminCancelDtoCashEnum> get serializer =>
      _$adminCancelDtoCashEnumSerializer;

  const AdminCancelDtoCashEnum._(String name) : super(name);

  static BuiltSet<AdminCancelDtoCashEnum> get values =>
      _$adminCancelDtoCashEnumValues;
  static AdminCancelDtoCashEnum valueOf(String name) =>
      _$adminCancelDtoCashEnumValueOf(name);
}
