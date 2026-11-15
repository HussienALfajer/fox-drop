//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_preview_request_dto.g.dart';

/// AdminSettlementPreviewRequestDto
///
/// Properties:
/// * [captainId]
/// * [payoutCurrency] - Null for the base currency.
@BuiltValue()
abstract class AdminSettlementPreviewRequestDto
    implements
        Built<
          AdminSettlementPreviewRequestDto,
          AdminSettlementPreviewRequestDtoBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// Null for the base currency.
  @BuiltValueField(wireName: r'payoutCurrency')
  String? get payoutCurrency;

  AdminSettlementPreviewRequestDto._();

  factory AdminSettlementPreviewRequestDto([
    void updates(AdminSettlementPreviewRequestDtoBuilder b),
  ]) = _$AdminSettlementPreviewRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementPreviewRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementPreviewRequestDto> get serializer =>
      _$AdminSettlementPreviewRequestDtoSerializer();
}

class _$AdminSettlementPreviewRequestDtoSerializer
    implements PrimitiveSerializer<AdminSettlementPreviewRequestDto> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementPreviewRequestDto,
    _$AdminSettlementPreviewRequestDto,
  ];

  @override
  final String wireName = r'AdminSettlementPreviewRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementPreviewRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'payoutCurrency';
    yield object.payoutCurrency == null
        ? null
        : serializers.serialize(
            object.payoutCurrency,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementPreviewRequestDto object, {
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
    required AdminSettlementPreviewRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'payoutCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.payoutCurrency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettlementPreviewRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementPreviewRequestDtoBuilder();
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
