//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_preview_dto_output_custody_inner.g.dart';

/// AdminSettlementPreviewDtoOutputCustodyInner
///
/// Properties:
/// * [currency]
/// * [balance] - + the captain hands in, − the office owes them.
/// * [balanceInBase]
@BuiltValue()
abstract class AdminSettlementPreviewDtoOutputCustodyInner
    implements
        Built<
          AdminSettlementPreviewDtoOutputCustodyInner,
          AdminSettlementPreviewDtoOutputCustodyInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// + the captain hands in, − the office owes them.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'balanceInBase')
  String get balanceInBase;

  AdminSettlementPreviewDtoOutputCustodyInner._();

  factory AdminSettlementPreviewDtoOutputCustodyInner([
    void updates(AdminSettlementPreviewDtoOutputCustodyInnerBuilder b),
  ]) = _$AdminSettlementPreviewDtoOutputCustodyInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementPreviewDtoOutputCustodyInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementPreviewDtoOutputCustodyInner>
  get serializer => _$AdminSettlementPreviewDtoOutputCustodyInnerSerializer();
}

class _$AdminSettlementPreviewDtoOutputCustodyInnerSerializer
    implements
        PrimitiveSerializer<AdminSettlementPreviewDtoOutputCustodyInner> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementPreviewDtoOutputCustodyInner,
    _$AdminSettlementPreviewDtoOutputCustodyInner,
  ];

  @override
  final String wireName = r'AdminSettlementPreviewDtoOutputCustodyInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputCustodyInner object, {
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
    yield r'balanceInBase';
    yield serializers.serialize(
      object.balanceInBase,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputCustodyInner object, {
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
    required AdminSettlementPreviewDtoOutputCustodyInnerBuilder result,
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
  AdminSettlementPreviewDtoOutputCustodyInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementPreviewDtoOutputCustodyInnerBuilder();
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
