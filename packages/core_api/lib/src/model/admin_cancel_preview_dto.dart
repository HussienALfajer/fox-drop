//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_preview_dto.g.dart';

/// AdminCancelPreviewDto
///
/// Properties:
/// * [cancellation] - Checked when given (400 unknown_reason).
/// * [responsible] - The responsible party (docs/domain/09): «المطعم», «الكابتن», «الزبون», «المنصة».
/// * [foodPrepared] - «تم تحضير الطعام؟». From accepted or ready with the restaurant not responsible, the merchant net is credited on platform.operating_cost; true on a placed order is 400 invalid_cancellation.
/// * [compensateCaptain] - «تعويض الكابتن»: the pay table's base pay for the captain's vehicle; only once the assigned captain reached the restaurant (409 compensation_not_allowed; 409 captain_pay_unset without a rate).
/// * [cash] - «هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
@BuiltValue()
abstract class AdminCancelPreviewDto
    implements Built<AdminCancelPreviewDto, AdminCancelPreviewDtoBuilder> {
  /// Checked when given (400 unknown_reason).
  @BuiltValueField(wireName: r'cancellation')
  String? get cancellation;

  /// The responsible party (docs/domain/09): «المطعم», «الكابتن», «الزبون», «المنصة».
  @BuiltValueField(wireName: r'responsible')
  AdminCancelPreviewDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// «تم تحضير الطعام؟». From accepted or ready with the restaurant not responsible, the merchant net is credited on platform.operating_cost; true on a placed order is 400 invalid_cancellation.
  @BuiltValueField(wireName: r'foodPrepared')
  bool get foodPrepared;

  /// «تعويض الكابتن»: the pay table's base pay for the captain's vehicle; only once the assigned captain reached the restaurant (409 compensation_not_allowed; 409 captain_pay_unset without a rate).
  @BuiltValueField(wireName: r'compensateCaptain')
  bool get compensateCaptain;

  /// «هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
  @BuiltValueField(wireName: r'cash')
  AdminCancelPreviewDtoCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  AdminCancelPreviewDto._();

  factory AdminCancelPreviewDto([
    void updates(AdminCancelPreviewDtoBuilder b),
  ]) = _$AdminCancelPreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancelPreviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelPreviewDto> get serializer =>
      _$AdminCancelPreviewDtoSerializer();
}

class _$AdminCancelPreviewDtoSerializer
    implements PrimitiveSerializer<AdminCancelPreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminCancelPreviewDto,
    _$AdminCancelPreviewDto,
  ];

  @override
  final String wireName = r'AdminCancelPreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelPreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cancellation != null) {
      yield r'cancellation';
      yield serializers.serialize(
        object.cancellation,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminCancelPreviewDtoResponsibleEnum),
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
            specifiedType: const FullType.nullable(
              AdminCancelPreviewDtoCashEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelPreviewDto object, {
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
    required AdminCancelPreviewDtoBuilder result,
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
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cancellation = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCancelPreviewDtoResponsibleEnum,
                    ),
                  )
                  as AdminCancelPreviewDtoResponsibleEnum;
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
                      AdminCancelPreviewDtoCashEnum,
                    ),
                  )
                  as AdminCancelPreviewDtoCashEnum?;
          if (valueDes == null) continue;
          result.cash = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCancelPreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelPreviewDtoBuilder();
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
class AdminCancelPreviewDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminCancelPreviewDtoResponsibleEnum restaurant =
      _$adminCancelPreviewDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCancelPreviewDtoResponsibleEnum captain =
      _$adminCancelPreviewDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminCancelPreviewDtoResponsibleEnum customer =
      _$adminCancelPreviewDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminCancelPreviewDtoResponsibleEnum platform =
      _$adminCancelPreviewDtoResponsibleEnum_platform;

  static Serializer<AdminCancelPreviewDtoResponsibleEnum> get serializer =>
      _$adminCancelPreviewDtoResponsibleEnumSerializer;

  const AdminCancelPreviewDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminCancelPreviewDtoResponsibleEnum> get values =>
      _$adminCancelPreviewDtoResponsibleEnumValues;
  static AdminCancelPreviewDtoResponsibleEnum valueOf(String name) =>
      _$adminCancelPreviewDtoResponsibleEnumValueOf(name);
}

/// «هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
class AdminCancelPreviewDtoCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const AdminCancelPreviewDtoCashEnum returned =
      _$adminCancelPreviewDtoCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const AdminCancelPreviewDtoCashEnum notReturned =
      _$adminCancelPreviewDtoCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const AdminCancelPreviewDtoCashEnum notPaid =
      _$adminCancelPreviewDtoCashEnum_notPaid;

  static Serializer<AdminCancelPreviewDtoCashEnum> get serializer =>
      _$adminCancelPreviewDtoCashEnumSerializer;

  const AdminCancelPreviewDtoCashEnum._(String name) : super(name);

  static BuiltSet<AdminCancelPreviewDtoCashEnum> get values =>
      _$adminCancelPreviewDtoCashEnumValues;
  static AdminCancelPreviewDtoCashEnum valueOf(String name) =>
      _$adminCancelPreviewDtoCashEnumValueOf(name);
}
