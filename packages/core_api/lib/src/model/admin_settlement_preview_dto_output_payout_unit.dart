//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_preview_dto_output_payout_unit.g.dart';

/// AdminSettlementPreviewDtoOutputPayoutUnit
///
/// Properties:
/// * [from]
/// * [to]
/// * [value]
@BuiltValue()
abstract class AdminSettlementPreviewDtoOutputPayoutUnit
    implements
        Built<
          AdminSettlementPreviewDtoOutputPayoutUnit,
          AdminSettlementPreviewDtoOutputPayoutUnitBuilder
        > {
  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'value')
  String get value;

  AdminSettlementPreviewDtoOutputPayoutUnit._();

  factory AdminSettlementPreviewDtoOutputPayoutUnit([
    void updates(AdminSettlementPreviewDtoOutputPayoutUnitBuilder b),
  ]) = _$AdminSettlementPreviewDtoOutputPayoutUnit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementPreviewDtoOutputPayoutUnitBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementPreviewDtoOutputPayoutUnit> get serializer =>
      _$AdminSettlementPreviewDtoOutputPayoutUnitSerializer();
}

class _$AdminSettlementPreviewDtoOutputPayoutUnitSerializer
    implements PrimitiveSerializer<AdminSettlementPreviewDtoOutputPayoutUnit> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementPreviewDtoOutputPayoutUnit,
    _$AdminSettlementPreviewDtoOutputPayoutUnit,
  ];

  @override
  final String wireName = r'AdminSettlementPreviewDtoOutputPayoutUnit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputPayoutUnit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputPayoutUnit object, {
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
    required AdminSettlementPreviewDtoOutputPayoutUnitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettlementPreviewDtoOutputPayoutUnit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementPreviewDtoOutputPayoutUnitBuilder();
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
