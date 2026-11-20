//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_manual_entries_dto_output_entries_inner.dart';
import 'package:core_api/src/model/admin_order_corrections_dto_output_accounts_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_corrections_dto_output.g.dart';

/// AdminOrderCorrectionsDtoOutput
///
/// Properties:
/// * [finished] - Only a finished order is corrected (AP §9.5).
/// * [canCorrect] - order_history.financial_correction (OWN, FIN) on a finished order.
/// * [entries] - The order's corrections, oldest first.
/// * [accounts] - What a correction may reach: the order's restaurant, customer (dues only where they have some) and every captain who held it; empty unless canCorrect.
@BuiltValue()
abstract class AdminOrderCorrectionsDtoOutput
    implements
        Built<
          AdminOrderCorrectionsDtoOutput,
          AdminOrderCorrectionsDtoOutputBuilder
        > {
  /// Only a finished order is corrected (AP §9.5).
  @BuiltValueField(wireName: r'finished')
  bool get finished;

  /// order_history.financial_correction (OWN, FIN) on a finished order.
  @BuiltValueField(wireName: r'canCorrect')
  bool get canCorrect;

  /// The order's corrections, oldest first.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminManualEntriesDtoOutputEntriesInner> get entries;

  /// What a correction may reach: the order's restaurant, customer (dues only where they have some) and every captain who held it; empty unless canCorrect.
  @BuiltValueField(wireName: r'accounts')
  BuiltList<AdminOrderCorrectionsDtoOutputAccountsInner> get accounts;

  AdminOrderCorrectionsDtoOutput._();

  factory AdminOrderCorrectionsDtoOutput([
    void updates(AdminOrderCorrectionsDtoOutputBuilder b),
  ]) = _$AdminOrderCorrectionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCorrectionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCorrectionsDtoOutput> get serializer =>
      _$AdminOrderCorrectionsDtoOutputSerializer();
}

class _$AdminOrderCorrectionsDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderCorrectionsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCorrectionsDtoOutput,
    _$AdminOrderCorrectionsDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderCorrectionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCorrectionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'finished';
    yield serializers.serialize(
      object.finished,
      specifiedType: const FullType(bool),
    );
    yield r'canCorrect';
    yield serializers.serialize(
      object.canCorrect,
      specifiedType: const FullType(bool),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminManualEntriesDtoOutputEntriesInner),
      ]),
    );
    yield r'accounts';
    yield serializers.serialize(
      object.accounts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderCorrectionsDtoOutputAccountsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCorrectionsDtoOutput object, {
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
    required AdminOrderCorrectionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'finished':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.finished = valueDes;
          break;
        case r'canCorrect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.canCorrect = valueDes;
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminManualEntriesDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminManualEntriesDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        case r'accounts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderCorrectionsDtoOutputAccountsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderCorrectionsDtoOutputAccountsInner>;
          result.accounts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCorrectionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCorrectionsDtoOutputBuilder();
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
