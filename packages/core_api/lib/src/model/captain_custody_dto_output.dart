//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_custody_dto_output_entries_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_custody_dto_output_total.dart';
import 'package:core_api/src/model/captain_custody_dto_output_limit.dart';
import 'package:core_api/src/model/captain_custody_dto_output_closed_due.dart';
import 'package:core_api/src/model/captain_custody_dto_output_receipts_inner.dart';
import 'package:core_api/src/model/captain_custody_dto_output_currencies_inner.dart';
import 'package:core_api/src/model/captain_custody_dto_output_usage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_custody_dto_output.g.dart';

/// CaptainCustodyDtoOutput
///
/// Properties:
/// * [usage]
/// * [limit]
/// * [warn] - At captain.custody_warn_pct of the limit or more.
/// * [total]
/// * [closedDue]
/// * [lastCutoff]
/// * [handInGraceUntil] - A hand-in grace running now (AP §8.5.4): until when; null otherwise.
/// * [currencies] - Each currency held, the base first (AP §8.6).
/// * [entries] - Every entry, newest first, the latest 100.
/// * [receipts] - Every desk receipt, newest first, the latest 50.
@BuiltValue()
abstract class CaptainCustodyDtoOutput
    implements Built<CaptainCustodyDtoOutput, CaptainCustodyDtoOutputBuilder> {
  @BuiltValueField(wireName: r'usage')
  CaptainCustodyDtoOutputUsage get usage;

  @BuiltValueField(wireName: r'limit')
  CaptainCustodyDtoOutputLimit get limit;

  /// At captain.custody_warn_pct of the limit or more.
  @BuiltValueField(wireName: r'warn')
  bool get warn;

  @BuiltValueField(wireName: r'total')
  CaptainCustodyDtoOutputTotal get total;

  @BuiltValueField(wireName: r'closedDue')
  CaptainCustodyDtoOutputClosedDue get closedDue;

  @BuiltValueField(wireName: r'lastCutoff')
  DateTime get lastCutoff;

  /// A hand-in grace running now (AP §8.5.4): until when; null otherwise.
  @BuiltValueField(wireName: r'handInGraceUntil')
  DateTime? get handInGraceUntil;

  /// Each currency held, the base first (AP §8.6).
  @BuiltValueField(wireName: r'currencies')
  BuiltList<CaptainCustodyDtoOutputCurrenciesInner> get currencies;

  /// Every entry, newest first, the latest 100.
  @BuiltValueField(wireName: r'entries')
  BuiltList<CaptainCustodyDtoOutputEntriesInner> get entries;

  /// Every desk receipt, newest first, the latest 50.
  @BuiltValueField(wireName: r'receipts')
  BuiltList<CaptainCustodyDtoOutputReceiptsInner> get receipts;

  CaptainCustodyDtoOutput._();

  factory CaptainCustodyDtoOutput([
    void updates(CaptainCustodyDtoOutputBuilder b),
  ]) = _$CaptainCustodyDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCustodyDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustodyDtoOutput> get serializer =>
      _$CaptainCustodyDtoOutputSerializer();
}

class _$CaptainCustodyDtoOutputSerializer
    implements PrimitiveSerializer<CaptainCustodyDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainCustodyDtoOutput,
    _$CaptainCustodyDtoOutput,
  ];

  @override
  final String wireName = r'CaptainCustodyDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustodyDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(CaptainCustodyDtoOutputUsage),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(CaptainCustodyDtoOutputLimit),
    );
    yield r'warn';
    yield serializers.serialize(
      object.warn,
      specifiedType: const FullType(bool),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(CaptainCustodyDtoOutputTotal),
    );
    yield r'closedDue';
    yield serializers.serialize(
      object.closedDue,
      specifiedType: const FullType(CaptainCustodyDtoOutputClosedDue),
    );
    yield r'lastCutoff';
    yield serializers.serialize(
      object.lastCutoff,
      specifiedType: const FullType(DateTime),
    );
    yield r'handInGraceUntil';
    yield object.handInGraceUntil == null
        ? null
        : serializers.serialize(
            object.handInGraceUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainCustodyDtoOutputCurrenciesInner),
      ]),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainCustodyDtoOutputEntriesInner),
      ]),
    );
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainCustodyDtoOutputReceiptsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustodyDtoOutput object, {
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
    required CaptainCustodyDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainCustodyDtoOutputUsage),
                  )
                  as CaptainCustodyDtoOutputUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainCustodyDtoOutputLimit),
                  )
                  as CaptainCustodyDtoOutputLimit;
          result.limit.replace(valueDes);
          break;
        case r'warn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.warn = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainCustodyDtoOutputTotal),
                  )
                  as CaptainCustodyDtoOutputTotal;
          result.total.replace(valueDes);
          break;
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCustodyDtoOutputClosedDue,
                    ),
                  )
                  as CaptainCustodyDtoOutputClosedDue;
          result.closedDue.replace(valueDes);
          break;
        case r'lastCutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastCutoff = valueDes;
          break;
        case r'handInGraceUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.handInGraceUntil = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainCustodyDtoOutputCurrenciesInner),
                    ]),
                  )
                  as BuiltList<CaptainCustodyDtoOutputCurrenciesInner>;
          result.currencies.replace(valueDes);
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainCustodyDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<CaptainCustodyDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        case r'receipts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainCustodyDtoOutputReceiptsInner),
                    ]),
                  )
                  as BuiltList<CaptainCustodyDtoOutputReceiptsInner>;
          result.receipts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCustodyDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCustodyDtoOutputBuilder();
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
