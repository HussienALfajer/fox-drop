//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_captain_pay.dart';
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_entries_inner.dart';
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_loss.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_preview_answer_dto_output.g.dart';

/// AdminOutcomePreviewAnswerDtoOutput
///
/// Properties:
/// * [status]
/// * [provisional] - With an amount to collect: the entries are posted from the payment recorded (AP §9.3.2), the custody line as the collection books it.
/// * [loss]
/// * [dues]
/// * [captainPay]
/// * [entries] - Every entry the outcome would post (AP §8.9 «Preview»).
@BuiltValue()
abstract class AdminOutcomePreviewAnswerDtoOutput
    implements
        Built<
          AdminOutcomePreviewAnswerDtoOutput,
          AdminOutcomePreviewAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  AdminOutcomePreviewAnswerDtoOutputStatusEnum get status;
  // enum statusEnum {  delivered,  failed,  };

  /// With an amount to collect: the entries are posted from the payment recorded (AP §9.3.2), the custody line as the collection books it.
  @BuiltValueField(wireName: r'provisional')
  bool get provisional;

  @BuiltValueField(wireName: r'loss')
  AdminOutcomePreviewAnswerDtoOutputLoss get loss;

  @BuiltValueField(wireName: r'dues')
  CaptainWentOfflineDtoOutputHandIn? get dues;

  @BuiltValueField(wireName: r'captainPay')
  AdminOutcomePreviewAnswerDtoOutputCaptainPay get captainPay;

  /// Every entry the outcome would post (AP §8.9 «Preview»).
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get entries;

  AdminOutcomePreviewAnswerDtoOutput._();

  factory AdminOutcomePreviewAnswerDtoOutput([
    void updates(AdminOutcomePreviewAnswerDtoOutputBuilder b),
  ]) = _$AdminOutcomePreviewAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOutcomePreviewAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomePreviewAnswerDtoOutput> get serializer =>
      _$AdminOutcomePreviewAnswerDtoOutputSerializer();
}

class _$AdminOutcomePreviewAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminOutcomePreviewAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomePreviewAnswerDtoOutput,
    _$AdminOutcomePreviewAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminOutcomePreviewAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOutcomePreviewAnswerDtoOutputStatusEnum,
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
              CaptainWentOfflineDtoOutputHandIn,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutput object, {
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
    required AdminOutcomePreviewAnswerDtoOutputBuilder result,
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
                      AdminOutcomePreviewAnswerDtoOutputStatusEnum,
                    ),
                  )
                  as AdminOutcomePreviewAnswerDtoOutputStatusEnum;
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
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOutcomePreviewAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomePreviewAnswerDtoOutputBuilder();
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

class AdminOutcomePreviewAnswerDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOutcomePreviewAnswerDtoOutputStatusEnum delivered =
      _$adminOutcomePreviewAnswerDtoOutputStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOutcomePreviewAnswerDtoOutputStatusEnum failed =
      _$adminOutcomePreviewAnswerDtoOutputStatusEnum_failed;

  static Serializer<AdminOutcomePreviewAnswerDtoOutputStatusEnum>
  get serializer => _$adminOutcomePreviewAnswerDtoOutputStatusEnumSerializer;

  const AdminOutcomePreviewAnswerDtoOutputStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOutcomePreviewAnswerDtoOutputStatusEnum> get values =>
      _$adminOutcomePreviewAnswerDtoOutputStatusEnumValues;
  static AdminOutcomePreviewAnswerDtoOutputStatusEnum valueOf(String name) =>
      _$adminOutcomePreviewAnswerDtoOutputStatusEnumValueOf(name);
}
