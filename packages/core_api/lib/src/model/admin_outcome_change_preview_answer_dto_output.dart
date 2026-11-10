//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_captain_pay.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_entries_inner.dart';
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_loss.dart';
import 'package:core_api/src/model/admin_outcome_change_preview_answer_dto_output_dues.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_change_preview_answer_dto_output.g.dart';

/// AdminOutcomeChangePreviewAnswerDtoOutput
///
/// Properties:
/// * [status]
/// * [provisional] - With an amount to collect: the entries are posted from the payment recorded (AP §9.3.2), the custody line as the collection books it.
/// * [loss]
/// * [dues]
/// * [captainPay]
/// * [entries] - Every entry the outcome would post (AP §8.9 «Preview»).
/// * [reversed] - Every entry of the outcome in force reversed (AP §8.9 «Changing an outcome»), before the new outcome's entries; each carries the reversed journal's own reason, which names it, while the reversal is posted with the reason «تغيير النتيجة».
@BuiltValue()
abstract class AdminOutcomeChangePreviewAnswerDtoOutput
    implements
        Built<
          AdminOutcomeChangePreviewAnswerDtoOutput,
          AdminOutcomeChangePreviewAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum get status;
  // enum statusEnum {  delivered,  failed,  };

  /// With an amount to collect: the entries are posted from the payment recorded (AP §9.3.2), the custody line as the collection books it.
  @BuiltValueField(wireName: r'provisional')
  bool get provisional;

  @BuiltValueField(wireName: r'loss')
  AdminOutcomePreviewAnswerDtoOutputLoss get loss;

  @BuiltValueField(wireName: r'dues')
  AdminOutcomeChangePreviewAnswerDtoOutputDues? get dues;

  @BuiltValueField(wireName: r'captainPay')
  AdminOutcomePreviewAnswerDtoOutputCaptainPay get captainPay;

  /// Every entry the outcome would post (AP §8.9 «Preview»).
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get entries;

  /// Every entry of the outcome in force reversed (AP §8.9 «Changing an outcome»), before the new outcome's entries; each carries the reversed journal's own reason, which names it, while the reversal is posted with the reason «تغيير النتيجة».
  @BuiltValueField(wireName: r'reversed')
  BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get reversed;

  AdminOutcomeChangePreviewAnswerDtoOutput._();

  factory AdminOutcomeChangePreviewAnswerDtoOutput([
    void updates(AdminOutcomeChangePreviewAnswerDtoOutputBuilder b),
  ]) = _$AdminOutcomeChangePreviewAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOutcomeChangePreviewAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomeChangePreviewAnswerDtoOutput> get serializer =>
      _$AdminOutcomeChangePreviewAnswerDtoOutputSerializer();
}

class _$AdminOutcomeChangePreviewAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminOutcomeChangePreviewAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomeChangePreviewAnswerDtoOutput,
    _$AdminOutcomeChangePreviewAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminOutcomeChangePreviewAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomeChangePreviewAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum,
      ),
    );
    yield r'provisional';
    yield serializers.serialize(
      object.provisional,
      specifiedType: const FullType(bool),
    );
    yield r'loss';
    yield serializers.serialize(
      object.loss,
      specifiedType: const FullType(AdminOutcomePreviewAnswerDtoOutputLoss),
    );
    yield r'dues';
    yield object.dues == null
        ? null
        : serializers.serialize(
            object.dues,
            specifiedType: const FullType.nullable(
              AdminOutcomeChangePreviewAnswerDtoOutputDues,
            ),
          );
    yield r'captainPay';
    yield serializers.serialize(
      object.captainPay,
      specifiedType: const FullType(
        AdminOutcomePreviewAnswerDtoOutputCaptainPay,
      ),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOutcomePreviewAnswerDtoOutputEntriesInner),
      ]),
    );
    yield r'reversed';
    yield serializers.serialize(
      object.reversed,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOutcomePreviewAnswerDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomeChangePreviewAnswerDtoOutput object, {
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
    required AdminOutcomeChangePreviewAnswerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum,
                    ),
                  )
                  as AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'provisional':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.provisional = valueDes;
          break;
        case r'loss':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomePreviewAnswerDtoOutputLoss,
                    ),
                  )
                  as AdminOutcomePreviewAnswerDtoOutputLoss;
          result.loss.replace(valueDes);
          break;
        case r'dues':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOutcomeChangePreviewAnswerDtoOutputDues,
                    ),
                  )
                  as AdminOutcomeChangePreviewAnswerDtoOutputDues?;
          if (valueDes == null) continue;
          result.dues.replace(valueDes);
          break;
        case r'captainPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomePreviewAnswerDtoOutputCaptainPay,
                    ),
                  )
                  as AdminOutcomePreviewAnswerDtoOutputCaptainPay;
          result.captainPay.replace(valueDes);
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOutcomePreviewAnswerDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        case r'reversed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOutcomePreviewAnswerDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner>;
          result.reversed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOutcomeChangePreviewAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomeChangePreviewAnswerDtoOutputBuilder();
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

class AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum delivered =
      _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum failed =
      _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_failed;

  static Serializer<AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum>
  get serializer =>
      _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnumSerializer;

  const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum>
  get values => _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnumValues;
  static AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum valueOf(
    String name,
  ) => _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnumValueOf(name);
}
