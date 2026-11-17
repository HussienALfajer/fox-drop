//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_cancel_dto_compensation_value.dart';
import 'package:core_api/src/model/admin_ticket_resolve_dto_code_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_resolve_dto_code.g.dart';

/// «كود تعويض»: its value and reason; null for the wrong change, whose code is M.
///
/// Properties:
/// * [value]
/// * [reason]
@BuiltValue()
abstract class AdminTicketResolveDtoCode
    implements
        Built<AdminTicketResolveDtoCode, AdminTicketResolveDtoCodeBuilder> {
  @BuiltValueField(wireName: r'value')
  AdminCancelDtoCompensationValue get value;

  @BuiltValueField(wireName: r'reason')
  AdminTicketResolveDtoCodeReason get reason;

  AdminTicketResolveDtoCode._();

  factory AdminTicketResolveDtoCode([
    void updates(AdminTicketResolveDtoCodeBuilder b),
  ]) = _$AdminTicketResolveDtoCode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketResolveDtoCodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketResolveDtoCode> get serializer =>
      _$AdminTicketResolveDtoCodeSerializer();
}

class _$AdminTicketResolveDtoCodeSerializer
    implements PrimitiveSerializer<AdminTicketResolveDtoCode> {
  @override
  final Iterable<Type> types = const [
    AdminTicketResolveDtoCode,
    _$AdminTicketResolveDtoCode,
  ];

  @override
  final String wireName = r'AdminTicketResolveDtoCode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketResolveDtoCode object, {
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
      specifiedType: const FullType(AdminTicketResolveDtoCodeReason),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketResolveDtoCode object, {
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
    required AdminTicketResolveDtoCodeBuilder result,
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
                      AdminTicketResolveDtoCodeReason,
                    ),
                  )
                  as AdminTicketResolveDtoCodeReason;
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
  AdminTicketResolveDtoCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketResolveDtoCodeBuilder();
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
