//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_money_output.g.dart';

/// AdminDraftMoneyOutput
///
/// Properties:
/// * [amount] - Integer minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class AdminDraftMoneyOutput
    implements Built<AdminDraftMoneyOutput, AdminDraftMoneyOutputBuilder> {
  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminDraftMoneyOutput._();

  factory AdminDraftMoneyOutput([
    void updates(AdminDraftMoneyOutputBuilder b),
  ]) = _$AdminDraftMoneyOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftMoneyOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftMoneyOutput> get serializer =>
      _$AdminDraftMoneyOutputSerializer();
}

class _$AdminDraftMoneyOutputSerializer
    implements PrimitiveSerializer<AdminDraftMoneyOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDraftMoneyOutput,
    _$AdminDraftMoneyOutput,
  ];

  @override
  final String wireName = r'AdminDraftMoneyOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftMoneyOutput object, {
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
    AdminDraftMoneyOutput object, {
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
    required AdminDraftMoneyOutputBuilder result,
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
  AdminDraftMoneyOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftMoneyOutputBuilder();
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
