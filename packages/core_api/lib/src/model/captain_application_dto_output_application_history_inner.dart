//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_dto_output_application_history_inner.g.dart';

/// CaptainApplicationDtoOutputApplicationHistoryInner
///
/// Properties:
/// * [stage]
/// * [at]
@BuiltValue()
abstract class CaptainApplicationDtoOutputApplicationHistoryInner
    implements
        Built<
          CaptainApplicationDtoOutputApplicationHistoryInner,
          CaptainApplicationDtoOutputApplicationHistoryInnerBuilder
        > {
  @BuiltValueField(wireName: r'stage')
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum get stage;
  // enum stageEnum {  draft,  new,  under_review,  interview,  awaiting_kit,  active,  waitlist,  rejected,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainApplicationDtoOutputApplicationHistoryInner._();

  factory CaptainApplicationDtoOutputApplicationHistoryInner([
    void updates(CaptainApplicationDtoOutputApplicationHistoryInnerBuilder b),
  ]) = _$CaptainApplicationDtoOutputApplicationHistoryInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainApplicationDtoOutputApplicationHistoryInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDtoOutputApplicationHistoryInner>
  get serializer =>
      _$CaptainApplicationDtoOutputApplicationHistoryInnerSerializer();
}

class _$CaptainApplicationDtoOutputApplicationHistoryInnerSerializer
    implements
        PrimitiveSerializer<
          CaptainApplicationDtoOutputApplicationHistoryInner
        > {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDtoOutputApplicationHistoryInner,
    _$CaptainApplicationDtoOutputApplicationHistoryInner,
  ];

  @override
  final String wireName = r'CaptainApplicationDtoOutputApplicationHistoryInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationHistoryInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stage';
    yield serializers.serialize(
      object.stage,
      specifiedType: const FullType(
        CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum,
      ),
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
    CaptainApplicationDtoOutputApplicationHistoryInner object, {
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
    required CaptainApplicationDtoOutputApplicationHistoryInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum;
          result.stage = valueDes;
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
  CaptainApplicationDtoOutputApplicationHistoryInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationDtoOutputApplicationHistoryInnerBuilder();
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

class CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  draft = _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_draft;
  @BuiltValueEnumConst(wireName: r'new')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  new_ = _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_new_;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  underReview =
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_underReview;
  @BuiltValueEnumConst(wireName: r'interview')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  interview =
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_interview;
  @BuiltValueEnumConst(wireName: r'awaiting_kit')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  awaitingKit =
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_awaitingKit;
  @BuiltValueEnumConst(wireName: r'active')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  active = _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_active;
  @BuiltValueEnumConst(wireName: r'waitlist')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  waitlist =
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_waitlist;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
  rejected =
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_rejected;

  static Serializer<CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum>
  get serializer =>
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnumSerializer;

  const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum>
  get values =>
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnumValues;
  static CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum valueOf(
    String name,
  ) => _$captainApplicationDtoOutputApplicationHistoryInnerStageEnumValueOf(
    name,
  );
}
