//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_cancel_dto_compensation_value.dart';
import 'package:core_api/src/model/admin_cancel_dto_compensation_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_dto_compensation.g.dart';

/// AP §9.3.2 «may add compensation» (slice 2.22b): «تعويض الزبون» as the order's own route takes it, issued within the admin's cap or sent to OWN, in the cancellation's transaction; needs operations.compensate (403). 400 invalid_compensation (its value or reason); 409 no_base_currency, currency_changed.
///
/// Properties:
/// * [value]
/// * [reason]
@BuiltValue()
abstract class AdminCancelDtoCompensation
    implements
        Built<AdminCancelDtoCompensation, AdminCancelDtoCompensationBuilder> {
  @BuiltValueField(wireName: r'value')
  AdminCancelDtoCompensationValue get value;

  @BuiltValueField(wireName: r'reason')
  AdminCancelDtoCompensationReason get reason;

  AdminCancelDtoCompensation._();

  factory AdminCancelDtoCompensation([
    void updates(AdminCancelDtoCompensationBuilder b),
  ]) = _$AdminCancelDtoCompensation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancelDtoCompensationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelDtoCompensation> get serializer =>
      _$AdminCancelDtoCompensationSerializer();
}

class _$AdminCancelDtoCompensationSerializer
    implements PrimitiveSerializer<AdminCancelDtoCompensation> {
  @override
  final Iterable<Type> types = const [
    AdminCancelDtoCompensation,
    _$AdminCancelDtoCompensation,
  ];

  @override
  final String wireName = r'AdminCancelDtoCompensation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelDtoCompensation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(AdminCancelDtoCompensationValue),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(AdminCancelDtoCompensationReason),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelDtoCompensation object, {
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
    required AdminCancelDtoCompensationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCancelDtoCompensationValue,
                    ),
                  )
                  as AdminCancelDtoCompensationValue;
          result.value.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCancelDtoCompensationReason,
                    ),
                  )
                  as AdminCancelDtoCompensationReason;
          result.reason.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCancelDtoCompensation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelDtoCompensationBuilder();
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
