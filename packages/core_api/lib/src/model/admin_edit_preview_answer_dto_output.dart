//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_before.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_entries_inner.dart';
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_changes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_preview_answer_dto_output.g.dart';

/// AdminEditPreviewAnswerDtoOutput
///
/// Properties:
/// * [currency]
/// * [before]
/// * [after]
/// * [changes]
/// * [addsItems] - The restaurant must acknowledge it before the pickup (RA §8.13).
/// * [backToPreparing] - A ready order goes back to «قيد التحضير».
/// * [promisedAt] - The new promised time when it moves.
/// * [afterPickup] - The order was picked up: the edit needs a responsible party (AP §9.3.3).
/// * [entries] - After the pickup, every entry the edit would post for the responsible party (docs/domain/09); empty before the pickup or until the party is chosen.
@BuiltValue()
abstract class AdminEditPreviewAnswerDtoOutput
    implements
        Built<
          AdminEditPreviewAnswerDtoOutput,
          AdminEditPreviewAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'before')
  AdminEditPreviewAnswerDtoOutputBefore get before;

  @BuiltValueField(wireName: r'after')
  AdminEditPreviewAnswerDtoOutputBefore get after;

  @BuiltValueField(wireName: r'changes')
  BuiltList<AdminEditPreviewAnswerDtoOutputChangesInner> get changes;

  /// The restaurant must acknowledge it before the pickup (RA §8.13).
  @BuiltValueField(wireName: r'addsItems')
  bool get addsItems;

  /// A ready order goes back to «قيد التحضير».
  @BuiltValueField(wireName: r'backToPreparing')
  bool get backToPreparing;

  /// The new promised time when it moves.
  @BuiltValueField(wireName: r'promisedAt')
  DateTime? get promisedAt;

  /// The order was picked up: the edit needs a responsible party (AP §9.3.3).
  @BuiltValueField(wireName: r'afterPickup')
  bool get afterPickup;

  /// After the pickup, every entry the edit would post for the responsible party (docs/domain/09); empty before the pickup or until the party is chosen.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminEditPreviewAnswerDtoOutputEntriesInner> get entries;

  AdminEditPreviewAnswerDtoOutput._();

  factory AdminEditPreviewAnswerDtoOutput([
    void updates(AdminEditPreviewAnswerDtoOutputBuilder b),
  ]) = _$AdminEditPreviewAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditPreviewAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditPreviewAnswerDtoOutput> get serializer =>
      _$AdminEditPreviewAnswerDtoOutputSerializer();
}

class _$AdminEditPreviewAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminEditPreviewAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminEditPreviewAnswerDtoOutput,
    _$AdminEditPreviewAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminEditPreviewAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'before';
    yield serializers.serialize(
      object.before,
      specifiedType: const FullType(AdminEditPreviewAnswerDtoOutputBefore),
    );
    yield r'after';
    yield serializers.serialize(
      object.after,
      specifiedType: const FullType(AdminEditPreviewAnswerDtoOutputBefore),
    );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditPreviewAnswerDtoOutputChangesInner),
      ]),
    );
    yield r'addsItems';
    yield serializers.serialize(
      object.addsItems,
      specifiedType: const FullType(bool),
    );
    yield r'backToPreparing';
    yield serializers.serialize(
      object.backToPreparing,
      specifiedType: const FullType(bool),
    );
    yield r'promisedAt';
    yield object.promisedAt == null
        ? null
        : serializers.serialize(
            object.promisedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'afterPickup';
    yield serializers.serialize(
      object.afterPickup,
      specifiedType: const FullType(bool),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditPreviewAnswerDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutput object, {
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
    required AdminEditPreviewAnswerDtoOutputBuilder result,
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
        case r'before':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminEditPreviewAnswerDtoOutputBefore,
                    ),
                  )
                  as AdminEditPreviewAnswerDtoOutputBefore;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminEditPreviewAnswerDtoOutputBefore,
                    ),
                  )
                  as AdminEditPreviewAnswerDtoOutputBefore;
          result.after.replace(valueDes);
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditPreviewAnswerDtoOutputChangesInner),
                    ]),
                  )
                  as BuiltList<AdminEditPreviewAnswerDtoOutputChangesInner>;
          result.changes.replace(valueDes);
          break;
        case r'addsItems':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.addsItems = valueDes;
          break;
        case r'backToPreparing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.backToPreparing = valueDes;
          break;
        case r'promisedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.promisedAt = valueDes;
          break;
        case r'afterPickup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.afterPickup = valueDes;
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditPreviewAnswerDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminEditPreviewAnswerDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditPreviewAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditPreviewAnswerDtoOutputBuilder();
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
