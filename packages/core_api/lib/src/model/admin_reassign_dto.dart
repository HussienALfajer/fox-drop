//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reassign_dto.g.dart';

/// AdminReassignDto
///
/// Properties:
/// * [reassignment] - A code of Content's reassignment list (AP Appendix B); 400 unknown_reason otherwise.
/// * [captainFault] - «بخطأ من الكابتن» (counts as a captain cancellation, CA §11.2; no charge in V1) or «دون خطأ»; the dialog prefills the reason's default.
/// * [cash] - Required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
/// * [reason] - Required (AP §9.3.2): the internal note, never shown to the apps.
@BuiltValue()
abstract class AdminReassignDto
    implements Built<AdminReassignDto, AdminReassignDtoBuilder> {
  /// A code of Content's reassignment list (AP Appendix B); 400 unknown_reason otherwise.
  @BuiltValueField(wireName: r'reassignment')
  String get reassignment;

  /// «بخطأ من الكابتن» (counts as a captain cancellation, CA §11.2; no charge in V1) or «دون خطأ»; the dialog prefills the reason's default.
  @BuiltValueField(wireName: r'captainFault')
  bool get captainFault;

  /// Required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
  @BuiltValueField(wireName: r'cash')
  AdminReassignDtoCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  /// Required (AP §9.3.2): the internal note, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminReassignDto._();

  factory AdminReassignDto([void updates(AdminReassignDtoBuilder b)]) =
      _$AdminReassignDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReassignDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReassignDto> get serializer =>
      _$AdminReassignDtoSerializer();
}

class _$AdminReassignDtoSerializer
    implements PrimitiveSerializer<AdminReassignDto> {
  @override
  final Iterable<Type> types = const [AdminReassignDto, _$AdminReassignDto];

  @override
  final String wireName = r'AdminReassignDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReassignDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reassignment';
    yield serializers.serialize(
      object.reassignment,
      specifiedType: const FullType(String),
    );
    yield r'captainFault';
    yield serializers.serialize(
      object.captainFault,
      specifiedType: const FullType(bool),
    );
    yield r'cash';
    yield object.cash == null
        ? null
        : serializers.serialize(
            object.cash,
            specifiedType: const FullType.nullable(AdminReassignDtoCashEnum),
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
    AdminReassignDto object, {
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
    required AdminReassignDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reassignment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reassignment = valueDes;
          break;
        case r'captainFault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.captainFault = valueDes;
          break;
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminReassignDtoCashEnum,
                    ),
                  )
                  as AdminReassignDtoCashEnum?;
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
  AdminReassignDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReassignDtoBuilder();
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

/// Required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
class AdminReassignDtoCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const AdminReassignDtoCashEnum returned =
      _$adminReassignDtoCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const AdminReassignDtoCashEnum notReturned =
      _$adminReassignDtoCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const AdminReassignDtoCashEnum notPaid =
      _$adminReassignDtoCashEnum_notPaid;

  static Serializer<AdminReassignDtoCashEnum> get serializer =>
      _$adminReassignDtoCashEnumSerializer;

  const AdminReassignDtoCashEnum._(String name) : super(name);

  static BuiltSet<AdminReassignDtoCashEnum> get values =>
      _$adminReassignDtoCashEnumValues;
  static AdminReassignDtoCashEnum valueOf(String name) =>
      _$adminReassignDtoCashEnumValueOf(name);
}
