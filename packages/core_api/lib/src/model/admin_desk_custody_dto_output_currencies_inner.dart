//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_custody_dto_output_currencies_inner.g.dart';

/// AdminDeskCustodyDtoOutputCurrenciesInner
///
/// Properties:
/// * [currency]
/// * [balance] - + the captain hands in, − the office owes them.
/// * [closedDue]
/// * [today]
/// * [balanceInBase]
@BuiltValue()
abstract class AdminDeskCustodyDtoOutputCurrenciesInner
    implements
        Built<
          AdminDeskCustodyDtoOutputCurrenciesInner,
          AdminDeskCustodyDtoOutputCurrenciesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// + the captain hands in, − the office owes them.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'closedDue')
  String get closedDue;

  @BuiltValueField(wireName: r'today')
  String get today;

  @BuiltValueField(wireName: r'balanceInBase')
  String get balanceInBase;

  AdminDeskCustodyDtoOutputCurrenciesInner._();

  factory AdminDeskCustodyDtoOutputCurrenciesInner([
    void updates(AdminDeskCustodyDtoOutputCurrenciesInnerBuilder b),
  ]) = _$AdminDeskCustodyDtoOutputCurrenciesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCustodyDtoOutputCurrenciesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCustodyDtoOutputCurrenciesInner> get serializer =>
      _$AdminDeskCustodyDtoOutputCurrenciesInnerSerializer();
}

class _$AdminDeskCustodyDtoOutputCurrenciesInnerSerializer
    implements PrimitiveSerializer<AdminDeskCustodyDtoOutputCurrenciesInner> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCustodyDtoOutputCurrenciesInner,
    _$AdminDeskCustodyDtoOutputCurrenciesInner,
  ];

  @override
  final String wireName = r'AdminDeskCustodyDtoOutputCurrenciesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCustodyDtoOutputCurrenciesInner object, {
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
    yield r'closedDue';
    yield serializers.serialize(
      object.closedDue,
      specifiedType: const FullType(String),
    );
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(String),
    );
    yield r'balanceInBase';
    yield serializers.serialize(
      object.balanceInBase,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCustodyDtoOutputCurrenciesInner object, {
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
    required AdminDeskCustodyDtoOutputCurrenciesInnerBuilder result,
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
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.closedDue = valueDes;
          break;
        case r'today':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.today = valueDes;
          break;
        case r'balanceInBase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.balanceInBase = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeskCustodyDtoOutputCurrenciesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCustodyDtoOutputCurrenciesInnerBuilder();
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
