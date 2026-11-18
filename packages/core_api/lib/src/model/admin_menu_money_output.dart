//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_money_output.g.dart';

/// AdminMenuMoneyOutput
///
/// Properties:
/// * [amount] - Integer minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class AdminMenuMoneyOutput
    implements Built<AdminMenuMoneyOutput, AdminMenuMoneyOutputBuilder> {
  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminMenuMoneyOutput._();

  factory AdminMenuMoneyOutput([void updates(AdminMenuMoneyOutputBuilder b)]) =
      _$AdminMenuMoneyOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuMoneyOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuMoneyOutput> get serializer =>
      _$AdminMenuMoneyOutputSerializer();
}

class _$AdminMenuMoneyOutputSerializer
    implements PrimitiveSerializer<AdminMenuMoneyOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuMoneyOutput,
    _$AdminMenuMoneyOutput,
  ];

  @override
  final String wireName = r'AdminMenuMoneyOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuMoneyOutput object, {
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
    AdminMenuMoneyOutput object, {
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
    required AdminMenuMoneyOutputBuilder result,
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
  AdminMenuMoneyOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuMoneyOutputBuilder();
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
