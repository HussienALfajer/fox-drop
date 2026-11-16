//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_entries_dto_output_entries_inner_reversed_by.g.dart';

/// AdminManualEntriesDtoOutputEntriesInnerReversedBy
///
/// Properties:
/// * [journalId]
/// * [manualEntryId]
/// * [at]
@BuiltValue()
abstract class AdminManualEntriesDtoOutputEntriesInnerReversedBy
    implements
        Built<
          AdminManualEntriesDtoOutputEntriesInnerReversedBy,
          AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder
        > {
  @BuiltValueField(wireName: r'journalId')
  String get journalId;

  @BuiltValueField(wireName: r'manualEntryId')
  String? get manualEntryId;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminManualEntriesDtoOutputEntriesInnerReversedBy._();

  factory AdminManualEntriesDtoOutputEntriesInnerReversedBy([
    void updates(AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder b),
  ]) = _$AdminManualEntriesDtoOutputEntriesInnerReversedBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualEntriesDtoOutputEntriesInnerReversedBy>
  get serializer =>
      _$AdminManualEntriesDtoOutputEntriesInnerReversedBySerializer();
}

class _$AdminManualEntriesDtoOutputEntriesInnerReversedBySerializer
    implements
        PrimitiveSerializer<AdminManualEntriesDtoOutputEntriesInnerReversedBy> {
  @override
  final Iterable<Type> types = const [
    AdminManualEntriesDtoOutputEntriesInnerReversedBy,
    _$AdminManualEntriesDtoOutputEntriesInnerReversedBy,
  ];

  @override
  final String wireName = r'AdminManualEntriesDtoOutputEntriesInnerReversedBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerReversedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'journalId';
    yield serializers.serialize(
      object.journalId,
      specifiedType: const FullType(String),
    );
    yield r'manualEntryId';
    yield object.manualEntryId == null
        ? null
        : serializers.serialize(
            object.manualEntryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerReversedBy object, {
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
    required AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder result,
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
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualEntriesDtoOutputEntriesInnerReversedBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder();
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
