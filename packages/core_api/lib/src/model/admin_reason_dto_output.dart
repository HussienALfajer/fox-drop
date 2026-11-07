//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reason_dto_output.g.dart';

/// AdminReasonDtoOutput
///
/// Properties:
/// * [code]
/// * [label]
/// * [customerText]
/// * [note] - Whether the choice takes a note: none, optional, required.
/// * [fixed] - The code acts on it: it cannot be removed.
/// * [active] - False once removed: hidden from new choices, kept on orders.
@BuiltValue()
abstract class AdminReasonDtoOutput
    implements Built<AdminReasonDtoOutput, AdminReasonDtoOutputBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'customerText')
  String? get customerText;

  /// Whether the choice takes a note: none, optional, required.
  @BuiltValueField(wireName: r'note')
  AdminReasonDtoOutputNoteEnum get note;
  // enum noteEnum {  none,  optional,  required,  };

  /// The code acts on it: it cannot be removed.
  @BuiltValueField(wireName: r'fixed')
  bool get fixed;

  /// False once removed: hidden from new choices, kept on orders.
  @BuiltValueField(wireName: r'active')
  bool get active;

  AdminReasonDtoOutput._();

  factory AdminReasonDtoOutput([void updates(AdminReasonDtoOutputBuilder b)]) =
      _$AdminReasonDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReasonDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReasonDtoOutput> get serializer =>
      _$AdminReasonDtoOutputSerializer();
}

class _$AdminReasonDtoOutputSerializer
    implements PrimitiveSerializer<AdminReasonDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminReasonDtoOutput,
    _$AdminReasonDtoOutput,
  ];

  @override
  final String wireName = r'AdminReasonDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReasonDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'customerText';
    yield object.customerText == null
        ? null
        : serializers.serialize(
            object.customerText,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(AdminReasonDtoOutputNoteEnum),
    );
    yield r'fixed';
    yield serializers.serialize(
      object.fixed,
      specifiedType: const FullType(bool),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonDtoOutput object, {
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
    required AdminReasonDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'customerText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customerText = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminReasonDtoOutputNoteEnum),
                  )
                  as AdminReasonDtoOutputNoteEnum;
          result.note = valueDes;
          break;
        case r'fixed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.fixed = valueDes;
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReasonDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReasonDtoOutputBuilder();
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

/// Whether the choice takes a note: none, optional, required.
class AdminReasonDtoOutputNoteEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const AdminReasonDtoOutputNoteEnum none =
      _$adminReasonDtoOutputNoteEnum_none;
  @BuiltValueEnumConst(wireName: r'optional')
  static const AdminReasonDtoOutputNoteEnum optional =
      _$adminReasonDtoOutputNoteEnum_optional;
  @BuiltValueEnumConst(wireName: r'required')
  static const AdminReasonDtoOutputNoteEnum required_ =
      _$adminReasonDtoOutputNoteEnum_required_;

  static Serializer<AdminReasonDtoOutputNoteEnum> get serializer =>
      _$adminReasonDtoOutputNoteEnumSerializer;

  const AdminReasonDtoOutputNoteEnum._(String name) : super(name);

  static BuiltSet<AdminReasonDtoOutputNoteEnum> get values =>
      _$adminReasonDtoOutputNoteEnumValues;
  static AdminReasonDtoOutputNoteEnum valueOf(String name) =>
      _$adminReasonDtoOutputNoteEnumValueOf(name);
}
