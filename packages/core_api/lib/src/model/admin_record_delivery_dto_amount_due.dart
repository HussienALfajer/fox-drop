//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_delivery_dto_amount_due.g.dart';

/// The amount due the screen showed; another one now answers 409 amount_due_changed.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency] 
@BuiltValue()
abstract class AdminRecordDeliveryDtoAmountDue implements Built<AdminRecordDeliveryDtoAmountDue, AdminRecordDeliveryDtoAmountDueBuilder> {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminRecordDeliveryDtoAmountDue._();

  factory AdminRecordDeliveryDtoAmountDue([void updates(AdminRecordDeliveryDtoAmountDueBuilder b)]) = _$AdminRecordDeliveryDtoAmountDue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordDeliveryDtoAmountDueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordDeliveryDtoAmountDue> get serializer => _$AdminRecordDeliveryDtoAmountDueSerializer();
}

class _$AdminRecordDeliveryDtoAmountDueSerializer implements PrimitiveSerializer<AdminRecordDeliveryDtoAmountDue> {
  @override
  final Iterable<Type> types = const [AdminRecordDeliveryDtoAmountDue, _$AdminRecordDeliveryDtoAmountDue];

  @override
  final String wireName = r'AdminRecordDeliveryDtoAmountDue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordDeliveryDtoAmountDue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDeliveryDtoAmountDue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRecordDeliveryDtoAmountDueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRecordDeliveryDtoAmountDue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordDeliveryDtoAmountDueBuilder();
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


