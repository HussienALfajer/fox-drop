//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_action_done_dto_output.g.dart';

/// AdminCaptainActionDoneDtoOutput
///
/// Properties:
/// * [done]
@BuiltValue()
abstract class AdminCaptainActionDoneDtoOutput
    implements
        Built<
          AdminCaptainActionDoneDtoOutput,
          AdminCaptainActionDoneDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'done')
  AdminCaptainActionDoneDtoOutputDoneEnum get done;
  // enum doneEnum {  true,  };

  AdminCaptainActionDoneDtoOutput._();

  factory AdminCaptainActionDoneDtoOutput([
    void updates(AdminCaptainActionDoneDtoOutputBuilder b),
  ]) = _$AdminCaptainActionDoneDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainActionDoneDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainActionDoneDtoOutput> get serializer =>
      _$AdminCaptainActionDoneDtoOutputSerializer();
}

class _$AdminCaptainActionDoneDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainActionDoneDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainActionDoneDtoOutput,
    _$AdminCaptainActionDoneDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainActionDoneDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainActionDoneDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'done';
    yield serializers.serialize(
      object.done,
      specifiedType: const FullType(AdminCaptainActionDoneDtoOutputDoneEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainActionDoneDtoOutput object, {
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
    required AdminCaptainActionDoneDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'done':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainActionDoneDtoOutputDoneEnum,
                    ),
                  )
                  as AdminCaptainActionDoneDtoOutputDoneEnum;
          result.done = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainActionDoneDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainActionDoneDtoOutputBuilder();
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

class AdminCaptainActionDoneDtoOutputDoneEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const AdminCaptainActionDoneDtoOutputDoneEnum true_ =
      _$adminCaptainActionDoneDtoOutputDoneEnum_true_;

  static Serializer<AdminCaptainActionDoneDtoOutputDoneEnum> get serializer =>
      _$adminCaptainActionDoneDtoOutputDoneEnumSerializer;

  const AdminCaptainActionDoneDtoOutputDoneEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainActionDoneDtoOutputDoneEnum> get values =>
      _$adminCaptainActionDoneDtoOutputDoneEnumValues;
  static AdminCaptainActionDoneDtoOutputDoneEnum valueOf(String name) =>
      _$adminCaptainActionDoneDtoOutputDoneEnumValueOf(name);
}
