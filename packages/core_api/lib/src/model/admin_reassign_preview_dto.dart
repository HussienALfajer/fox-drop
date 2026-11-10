//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reassign_preview_dto.g.dart';

/// AdminReassignPreviewDto
///
/// Properties:
/// * [cash] - Required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
@BuiltValue()
abstract class AdminReassignPreviewDto
    implements Built<AdminReassignPreviewDto, AdminReassignPreviewDtoBuilder> {
  /// Required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».
  @BuiltValueField(wireName: r'cash')
  AdminReassignPreviewDtoCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  AdminReassignPreviewDto._();

  factory AdminReassignPreviewDto([
    void updates(AdminReassignPreviewDtoBuilder b),
  ]) = _$AdminReassignPreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReassignPreviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReassignPreviewDto> get serializer =>
      _$AdminReassignPreviewDtoSerializer();
}

class _$AdminReassignPreviewDtoSerializer
    implements PrimitiveSerializer<AdminReassignPreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminReassignPreviewDto,
    _$AdminReassignPreviewDto,
  ];

  @override
  final String wireName = r'AdminReassignPreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReassignPreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cash';
    yield object.cash == null
        ? null
        : serializers.serialize(
            object.cash,
            specifiedType: const FullType.nullable(
              AdminReassignPreviewDtoCashEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReassignPreviewDto object, {
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
    required AdminReassignPreviewDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminReassignPreviewDtoCashEnum,
                    ),
                  )
                  as AdminReassignPreviewDtoCashEnum?;
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
  AdminReassignPreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReassignPreviewDtoBuilder();
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
class AdminReassignPreviewDtoCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const AdminReassignPreviewDtoCashEnum returned =
      _$adminReassignPreviewDtoCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const AdminReassignPreviewDtoCashEnum notReturned =
      _$adminReassignPreviewDtoCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const AdminReassignPreviewDtoCashEnum notPaid =
      _$adminReassignPreviewDtoCashEnum_notPaid;

  static Serializer<AdminReassignPreviewDtoCashEnum> get serializer =>
      _$adminReassignPreviewDtoCashEnumSerializer;

  const AdminReassignPreviewDtoCashEnum._(String name) : super(name);

  static BuiltSet<AdminReassignPreviewDtoCashEnum> get values =>
      _$adminReassignPreviewDtoCashEnumValues;
  static AdminReassignPreviewDtoCashEnum valueOf(String name) =>
      _$adminReassignPreviewDtoCashEnumValueOf(name);
}
