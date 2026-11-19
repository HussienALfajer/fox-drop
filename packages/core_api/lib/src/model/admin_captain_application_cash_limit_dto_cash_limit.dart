//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_cash_limit_dto_cash_limit.g.dart';

/// In the city's base currency.
///
/// Properties:
/// * [amount] - Minor units.
/// * [currency]
@BuiltValue()
abstract class AdminCaptainApplicationCashLimitDtoCashLimit
    implements
        Built<
          AdminCaptainApplicationCashLimitDtoCashLimit,
          AdminCaptainApplicationCashLimitDtoCashLimitBuilder
        > {
  /// Minor units.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminCaptainApplicationCashLimitDtoCashLimit._();

  factory AdminCaptainApplicationCashLimitDtoCashLimit([
    void updates(AdminCaptainApplicationCashLimitDtoCashLimitBuilder b),
  ]) = _$AdminCaptainApplicationCashLimitDtoCashLimit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationCashLimitDtoCashLimitBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationCashLimitDtoCashLimit>
  get serializer => _$AdminCaptainApplicationCashLimitDtoCashLimitSerializer();
}

class _$AdminCaptainApplicationCashLimitDtoCashLimitSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationCashLimitDtoCashLimit> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationCashLimitDtoCashLimit,
    _$AdminCaptainApplicationCashLimitDtoCashLimit,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationCashLimitDtoCashLimit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationCashLimitDtoCashLimit object, {
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
    AdminCaptainApplicationCashLimitDtoCashLimit object, {
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
    required AdminCaptainApplicationCashLimitDtoCashLimitBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationCashLimitDtoCashLimit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationCashLimitDtoCashLimitBuilder();
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
