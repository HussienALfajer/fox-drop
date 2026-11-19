//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_violations_dto_output_violations_inner_appeal.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output_violations_inner.g.dart';

/// AdminCaptainViolationsDtoOutputViolationsInner
///
/// Properties:
/// * [id]
/// * [recordedAt]
/// * [typeCode]
/// * [typeLabel]
/// * [typeNote]
/// * [severe]
/// * [suggestedStep]
/// * [step]
/// * [orderId]
/// * [orderNumber]
/// * [reason]
/// * [suspendedUntil]
/// * [recordedByName]
/// * [appeal]
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutputViolationsInner
    implements
        Built<
          AdminCaptainViolationsDtoOutputViolationsInner,
          AdminCaptainViolationsDtoOutputViolationsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  @BuiltValueField(wireName: r'typeLabel')
  String get typeLabel;

  @BuiltValueField(wireName: r'typeNote')
  String? get typeNote;

  @BuiltValueField(wireName: r'severe')
  bool get severe;

  @BuiltValueField(wireName: r'suggestedStep')
  AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  get suggestedStep;
  // enum suggestedStepEnum {  warning,  suspension_1d,  suspension_7d,  termination,  };

  @BuiltValueField(wireName: r'step')
  AdminCaptainViolationsDtoOutputViolationsInnerStepEnum get step;
  // enum stepEnum {  warning,  suspension_1d,  suspension_7d,  termination,  };

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'suspendedUntil')
  DateTime? get suspendedUntil;

  @BuiltValueField(wireName: r'recordedByName')
  String? get recordedByName;

  @BuiltValueField(wireName: r'appeal')
  AdminCaptainViolationsDtoOutputViolationsInnerAppeal? get appeal;

  AdminCaptainViolationsDtoOutputViolationsInner._();

  factory AdminCaptainViolationsDtoOutputViolationsInner([
    void updates(AdminCaptainViolationsDtoOutputViolationsInnerBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutputViolationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainViolationsDtoOutputViolationsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutputViolationsInner>
  get serializer =>
      _$AdminCaptainViolationsDtoOutputViolationsInnerSerializer();
}

class _$AdminCaptainViolationsDtoOutputViolationsInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainViolationsDtoOutputViolationsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutputViolationsInner,
    _$AdminCaptainViolationsDtoOutputViolationsInner,
  ];

  @override
  final String wireName = r'AdminCaptainViolationsDtoOutputViolationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputViolationsInner object, {
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
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'typeLabel';
    yield serializers.serialize(
      object.typeLabel,
      specifiedType: const FullType(String),
    );
    yield r'typeNote';
    yield object.typeNote == null
        ? null
        : serializers.serialize(
            object.typeNote,
            specifiedType: const FullType.nullable(String),
          );
    yield r'severe';
    yield serializers.serialize(
      object.severe,
      specifiedType: const FullType(bool),
    );
    yield r'suggestedStep';
    yield serializers.serialize(
      object.suggestedStep,
      specifiedType: const FullType(
        AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum,
      ),
    );
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(
        AdminCaptainViolationsDtoOutputViolationsInnerStepEnum,
      ),
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
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'suspendedUntil';
    yield object.suspendedUntil == null
        ? null
        : serializers.serialize(
            object.suspendedUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'recordedByName';
    yield object.recordedByName == null
        ? null
        : serializers.serialize(
            object.recordedByName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'appeal';
    yield object.appeal == null
        ? null
        : serializers.serialize(
            object.appeal,
            specifiedType: const FullType.nullable(
              AdminCaptainViolationsDtoOutputViolationsInnerAppeal,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputViolationsInner object, {
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
    required AdminCaptainViolationsDtoOutputViolationsInnerBuilder result,
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
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
          break;
        case r'typeLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeLabel = valueDes;
          break;
        case r'typeNote':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.typeNote = valueDes;
          break;
        case r'severe':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.severe = valueDes;
          break;
        case r'suggestedStep':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum;
          result.suggestedStep = valueDes;
          break;
        case r'step':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputViolationsInnerStepEnum,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputViolationsInnerStepEnum;
          result.step = valueDes;
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
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
        case r'recordedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.recordedByName = valueDes;
          break;
        case r'appeal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainViolationsDtoOutputViolationsInnerAppeal,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputViolationsInnerAppeal?;
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
  AdminCaptainViolationsDtoOutputViolationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainViolationsDtoOutputViolationsInnerBuilder();
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

class AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  warning =
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum_warning;
  @BuiltValueEnumConst(wireName: r'suspension_1d')
  static const AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  suspension1d =
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum_suspension1d;
  @BuiltValueEnumConst(wireName: r'suspension_7d')
  static const AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  suspension7d =
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum_suspension7d;
  @BuiltValueEnumConst(wireName: r'termination')
  static const AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  termination =
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum_termination;

  static Serializer<
    AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  >
  get serializer =>
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnumSerializer;

  const AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  >
  get values =>
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnumValues;
  static AdminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnum
  valueOf(String name) =>
      _$adminCaptainViolationsDtoOutputViolationsInnerSuggestedStepEnumValueOf(
        name,
      );
}

class AdminCaptainViolationsDtoOutputViolationsInnerStepEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminCaptainViolationsDtoOutputViolationsInnerStepEnum warning =
      _$adminCaptainViolationsDtoOutputViolationsInnerStepEnum_warning;
  @BuiltValueEnumConst(wireName: r'suspension_1d')
  static const AdminCaptainViolationsDtoOutputViolationsInnerStepEnum
  suspension1d =
      _$adminCaptainViolationsDtoOutputViolationsInnerStepEnum_suspension1d;
  @BuiltValueEnumConst(wireName: r'suspension_7d')
  static const AdminCaptainViolationsDtoOutputViolationsInnerStepEnum
  suspension7d =
      _$adminCaptainViolationsDtoOutputViolationsInnerStepEnum_suspension7d;
  @BuiltValueEnumConst(wireName: r'termination')
  static const AdminCaptainViolationsDtoOutputViolationsInnerStepEnum
  termination =
      _$adminCaptainViolationsDtoOutputViolationsInnerStepEnum_termination;

  static Serializer<AdminCaptainViolationsDtoOutputViolationsInnerStepEnum>
  get serializer =>
      _$adminCaptainViolationsDtoOutputViolationsInnerStepEnumSerializer;

  const AdminCaptainViolationsDtoOutputViolationsInnerStepEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainViolationsDtoOutputViolationsInnerStepEnum>
  get values => _$adminCaptainViolationsDtoOutputViolationsInnerStepEnumValues;
  static AdminCaptainViolationsDtoOutputViolationsInnerStepEnum valueOf(
    String name,
  ) => _$adminCaptainViolationsDtoOutputViolationsInnerStepEnumValueOf(name);
}
