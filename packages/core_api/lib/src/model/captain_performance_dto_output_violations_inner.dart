//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_performance_dto_output_violations_inner_appeal.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_performance_dto_output_violations_inner.g.dart';

/// CaptainPerformanceDtoOutputViolationsInner
///
/// Properties:
/// * [id]
/// * [recordedAt]
/// * [type] - The type as chosen, with the text of «أخرى».
/// * [step]
/// * [orderNumber]
/// * [suspendedUntil]
/// * [appeal]
@BuiltValue()
abstract class CaptainPerformanceDtoOutputViolationsInner
    implements
        Built<
          CaptainPerformanceDtoOutputViolationsInner,
          CaptainPerformanceDtoOutputViolationsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  /// The type as chosen, with the text of «أخرى».
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'step')
  CaptainPerformanceDtoOutputViolationsInnerStepEnum get step;
  // enum stepEnum {  warning,  suspension_1d,  suspension_7d,  termination,  };

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  @BuiltValueField(wireName: r'suspendedUntil')
  DateTime? get suspendedUntil;

  @BuiltValueField(wireName: r'appeal')
  CaptainPerformanceDtoOutputViolationsInnerAppeal? get appeal;

  CaptainPerformanceDtoOutputViolationsInner._();

  factory CaptainPerformanceDtoOutputViolationsInner([
    void updates(CaptainPerformanceDtoOutputViolationsInnerBuilder b),
  ]) = _$CaptainPerformanceDtoOutputViolationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPerformanceDtoOutputViolationsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPerformanceDtoOutputViolationsInner>
  get serializer => _$CaptainPerformanceDtoOutputViolationsInnerSerializer();
}

class _$CaptainPerformanceDtoOutputViolationsInnerSerializer
    implements PrimitiveSerializer<CaptainPerformanceDtoOutputViolationsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainPerformanceDtoOutputViolationsInner,
    _$CaptainPerformanceDtoOutputViolationsInner,
  ];

  @override
  final String wireName = r'CaptainPerformanceDtoOutputViolationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPerformanceDtoOutputViolationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'recordedAt';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(
        CaptainPerformanceDtoOutputViolationsInnerStepEnum,
      ),
    );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'suspendedUntil';
    yield object.suspendedUntil == null
        ? null
        : serializers.serialize(
            object.suspendedUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'appeal';
    yield object.appeal == null
        ? null
        : serializers.serialize(
            object.appeal,
            specifiedType: const FullType.nullable(
              CaptainPerformanceDtoOutputViolationsInnerAppeal,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputViolationsInner object, {
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
    required CaptainPerformanceDtoOutputViolationsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'recordedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.recordedAt = valueDes;
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
        case r'step':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainPerformanceDtoOutputViolationsInnerStepEnum,
                    ),
                  )
                  as CaptainPerformanceDtoOutputViolationsInnerStepEnum;
          result.step = valueDes;
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
        case r'suspendedUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.suspendedUntil = valueDes;
          break;
        case r'appeal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainPerformanceDtoOutputViolationsInnerAppeal,
                    ),
                  )
                  as CaptainPerformanceDtoOutputViolationsInnerAppeal?;
          if (valueDes == null) continue;
          result.appeal.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPerformanceDtoOutputViolationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPerformanceDtoOutputViolationsInnerBuilder();
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

class CaptainPerformanceDtoOutputViolationsInnerStepEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const CaptainPerformanceDtoOutputViolationsInnerStepEnum warning =
      _$captainPerformanceDtoOutputViolationsInnerStepEnum_warning;
  @BuiltValueEnumConst(wireName: r'suspension_1d')
  static const CaptainPerformanceDtoOutputViolationsInnerStepEnum suspension1d =
      _$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension1d;
  @BuiltValueEnumConst(wireName: r'suspension_7d')
  static const CaptainPerformanceDtoOutputViolationsInnerStepEnum suspension7d =
      _$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension7d;
  @BuiltValueEnumConst(wireName: r'termination')
  static const CaptainPerformanceDtoOutputViolationsInnerStepEnum termination =
      _$captainPerformanceDtoOutputViolationsInnerStepEnum_termination;

  static Serializer<CaptainPerformanceDtoOutputViolationsInnerStepEnum>
  get serializer =>
      _$captainPerformanceDtoOutputViolationsInnerStepEnumSerializer;

  const CaptainPerformanceDtoOutputViolationsInnerStepEnum._(String name)
    : super(name);

  static BuiltSet<CaptainPerformanceDtoOutputViolationsInnerStepEnum>
  get values => _$captainPerformanceDtoOutputViolationsInnerStepEnumValues;
  static CaptainPerformanceDtoOutputViolationsInnerStepEnum valueOf(
    String name,
  ) => _$captainPerformanceDtoOutputViolationsInnerStepEnumValueOf(name);
}
