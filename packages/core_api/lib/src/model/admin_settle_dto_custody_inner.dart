//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settle_dto_custody_inner.g.dart';

/// AdminSettleDtoCustodyInner
///
/// Properties:
/// * [currency]
/// * [balance]
@BuiltValue()
abstract class AdminSettleDtoCustodyInner
    implements
        Built<AdminSettleDtoCustodyInner, AdminSettleDtoCustodyInnerBuilder> {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'balance')
  String get balance;

  AdminSettleDtoCustodyInner._();

  factory AdminSettleDtoCustodyInner([
    void updates(AdminSettleDtoCustodyInnerBuilder b),
  ]) = _$AdminSettleDtoCustodyInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettleDtoCustodyInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettleDtoCustodyInner> get serializer =>
      _$AdminSettleDtoCustodyInnerSerializer();
}

class _$AdminSettleDtoCustodyInnerSerializer
    implements PrimitiveSerializer<AdminSettleDtoCustodyInner> {
  @override
  final Iterable<Type> types = const [
    AdminSettleDtoCustodyInner,
    _$AdminSettleDtoCustodyInner,
  ];

  @override
  final String wireName = r'AdminSettleDtoCustodyInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettleDtoCustodyInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettleDtoCustodyInner object, {
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
    required AdminSettleDtoCustodyInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'balance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.balance = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettleDtoCustodyInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettleDtoCustodyInnerBuilder();
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
