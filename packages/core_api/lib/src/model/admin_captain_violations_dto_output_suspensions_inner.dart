//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output_suspensions_inner.g.dart';

/// AdminCaptainViolationsDtoOutputSuspensionsInner
///
/// Properties:
/// * [at]
/// * [status]
/// * [until]
/// * [reason]
/// * [actorName]
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutputSuspensionsInner
    implements
        Built<
          AdminCaptainViolationsDtoOutputSuspensionsInner,
          AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'status')
  AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum get status;
  // enum statusEnum {  active,  suspended,  terminated,  };

  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'actorName')
  String? get actorName;

  AdminCaptainViolationsDtoOutputSuspensionsInner._();

  factory AdminCaptainViolationsDtoOutputSuspensionsInner([
    void updates(AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutputSuspensionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutputSuspensionsInner>
  get serializer =>
      _$AdminCaptainViolationsDtoOutputSuspensionsInnerSerializer();
}

class _$AdminCaptainViolationsDtoOutputSuspensionsInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainViolationsDtoOutputSuspensionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutputSuspensionsInner,
    _$AdminCaptainViolationsDtoOutputSuspensionsInner,
  ];

  @override
  final String wireName = r'AdminCaptainViolationsDtoOutputSuspensionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputSuspensionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum,
      ),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'actorName';
    yield object.actorName == null
        ? null
        : serializers.serialize(
            object.actorName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputSuspensionsInner object, {
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
    required AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
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
        case r'actorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.actorName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainViolationsDtoOutputSuspensionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder();
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

class AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
  active = _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
  suspended =
      _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
  terminated =
      _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_terminated;

  static Serializer<AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum>
  get serializer =>
      _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumSerializer;

  const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum>
  get values =>
      _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumValues;
  static AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumValueOf(name);
}
