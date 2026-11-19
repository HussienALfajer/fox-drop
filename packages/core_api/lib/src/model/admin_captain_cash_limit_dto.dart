//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_cash_limit_dto.g.dart';

/// AdminCaptainCashLimitDto
///
/// Properties:
/// * [amount] - Minor units, above zero.
/// * [currency] - The city's base currency.
/// * [reason] - Kept in the audit log (AP §9.7.5: every action needs a reason).
@BuiltValue()
abstract class AdminCaptainCashLimitDto
    implements
        Built<AdminCaptainCashLimitDto, AdminCaptainCashLimitDtoBuilder> {
  /// Minor units, above zero.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// The city's base currency.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Kept in the audit log (AP §9.7.5: every action needs a reason).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCaptainCashLimitDto._();

  factory AdminCaptainCashLimitDto([
    void updates(AdminCaptainCashLimitDtoBuilder b),
  ]) = _$AdminCaptainCashLimitDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainCashLimitDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainCashLimitDto> get serializer =>
      _$AdminCaptainCashLimitDtoSerializer();
}

class _$AdminCaptainCashLimitDtoSerializer
    implements PrimitiveSerializer<AdminCaptainCashLimitDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainCashLimitDto,
    _$AdminCaptainCashLimitDto,
  ];

  @override
  final String wireName = r'AdminCaptainCashLimitDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainCashLimitDto object, {
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
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainCashLimitDto object, {
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
    required AdminCaptainCashLimitDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
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
  AdminCaptainCashLimitDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainCashLimitDtoBuilder();
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
