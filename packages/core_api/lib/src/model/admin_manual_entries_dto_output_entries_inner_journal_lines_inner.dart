//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_entries_dto_output_entries_inner_journal_lines_inner.g.dart';

/// AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner
///
/// Properties:
/// * [purpose] - The party account, such as captain.earnings.
/// * [currency]
/// * [amount] - From the party's view: custody + the captain hands in, earnings + the platform owes them, the restaurant account − it owes, dues + the customer owes.
@BuiltValue()
abstract class AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner
    implements
        Built<
          AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner,
          AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder
        > {
  /// The party account, such as captain.earnings.
  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// From the party's view: custody + the captain hands in, earnings + the platform owes them, the restaurant account − it owes, dues + the customer owes.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner._();

  factory AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner([
    void updates(
      AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder b,
    ),
  ]) = _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner>
  get serializer =>
      _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerSerializer();
}

class _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner,
    _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner,
  ];

  @override
  final String wireName =
      r'AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner object, {
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
    required AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'purpose':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.purpose = valueDes;
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
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder();
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
