//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_manual_entries_dto_output_entries_inner_journal_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_entries_dto_output_entries_inner_journal.g.dart';

/// The journal the entry posted.
///
/// Properties:
/// * [journalId]
/// * [type] - The ledger journal type, such as earn.adjustment.
/// * [reason]
/// * [createdAt]
/// * [lines]
/// * [orderId]
/// * [orderNumber]
/// * [manualEntryId] - The manual entry that posted it, if one did.
@BuiltValue()
abstract class AdminManualEntriesDtoOutputEntriesInnerJournal
    implements
        Built<
          AdminManualEntriesDtoOutputEntriesInnerJournal,
          AdminManualEntriesDtoOutputEntriesInnerJournalBuilder
        > {
  @BuiltValueField(wireName: r'journalId')
  String get journalId;

  /// The ledger journal type, such as earn.adjustment.
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner> get lines;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// The manual entry that posted it, if one did.
  @BuiltValueField(wireName: r'manualEntryId')
  String? get manualEntryId;

  AdminManualEntriesDtoOutputEntriesInnerJournal._();

  factory AdminManualEntriesDtoOutputEntriesInnerJournal([
    void updates(AdminManualEntriesDtoOutputEntriesInnerJournalBuilder b),
  ]) = _$AdminManualEntriesDtoOutputEntriesInnerJournal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminManualEntriesDtoOutputEntriesInnerJournalBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualEntriesDtoOutputEntriesInnerJournal>
  get serializer =>
      _$AdminManualEntriesDtoOutputEntriesInnerJournalSerializer();
}

class _$AdminManualEntriesDtoOutputEntriesInnerJournalSerializer
    implements
        PrimitiveSerializer<AdminManualEntriesDtoOutputEntriesInnerJournal> {
  @override
  final Iterable<Type> types = const [
    AdminManualEntriesDtoOutputEntriesInnerJournal,
    _$AdminManualEntriesDtoOutputEntriesInnerJournal,
  ];

  @override
  final String wireName = r'AdminManualEntriesDtoOutputEntriesInnerJournal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerJournal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'journalId';
    yield serializers.serialize(
      object.journalId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner),
      ]),
    );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'manualEntryId';
    yield object.manualEntryId == null
        ? null
        : serializers.serialize(
            object.manualEntryId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerJournal object, {
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
    required AdminManualEntriesDtoOutputEntriesInnerJournalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'journalId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.journalId = valueDes;
          break;
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.type = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner
                  >;
          result.lines.replace(valueDes);
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'manualEntryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.manualEntryId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualEntriesDtoOutputEntriesInnerJournal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualEntriesDtoOutputEntriesInnerJournalBuilder();
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
