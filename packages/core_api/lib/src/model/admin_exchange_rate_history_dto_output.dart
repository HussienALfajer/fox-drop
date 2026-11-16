//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_exchange_rate_history_dto_output_versions_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_exchange_rate_history_dto_output.g.dart';

/// AdminExchangeRateHistoryDtoOutput
///
/// Properties:
/// * [versions] - Newest first, at most 100.
@BuiltValue()
abstract class AdminExchangeRateHistoryDtoOutput
    implements
        Built<
          AdminExchangeRateHistoryDtoOutput,
          AdminExchangeRateHistoryDtoOutputBuilder
        > {
  /// Newest first, at most 100.
  @BuiltValueField(wireName: r'versions')
  BuiltList<AdminExchangeRateHistoryDtoOutputVersionsInner> get versions;

  AdminExchangeRateHistoryDtoOutput._();

  factory AdminExchangeRateHistoryDtoOutput([
    void updates(AdminExchangeRateHistoryDtoOutputBuilder b),
  ]) = _$AdminExchangeRateHistoryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminExchangeRateHistoryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminExchangeRateHistoryDtoOutput> get serializer =>
      _$AdminExchangeRateHistoryDtoOutputSerializer();
}

class _$AdminExchangeRateHistoryDtoOutputSerializer
    implements PrimitiveSerializer<AdminExchangeRateHistoryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminExchangeRateHistoryDtoOutput,
    _$AdminExchangeRateHistoryDtoOutput,
  ];

  @override
  final String wireName = r'AdminExchangeRateHistoryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminExchangeRateHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminExchangeRateHistoryDtoOutputVersionsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminExchangeRateHistoryDtoOutput object, {
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
    required AdminExchangeRateHistoryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'versions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminExchangeRateHistoryDtoOutputVersionsInner),
                    ]),
                  )
                  as BuiltList<AdminExchangeRateHistoryDtoOutputVersionsInner>;
          result.versions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminExchangeRateHistoryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminExchangeRateHistoryDtoOutputBuilder();
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
