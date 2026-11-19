//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output_types_regular_inner.g.dart';

/// AdminCaptainViolationsDtoOutputTypesRegularInner
///
/// Properties:
/// * [code]
/// * [label]
/// * [note]
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutputTypesRegularInner
    implements
        Built<
          AdminCaptainViolationsDtoOutputTypesRegularInner,
          AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'note')
  AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum get note;
  // enum noteEnum {  none,  optional,  required,  };

  AdminCaptainViolationsDtoOutputTypesRegularInner._();

  factory AdminCaptainViolationsDtoOutputTypesRegularInner([
    void updates(AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutputTypesRegularInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutputTypesRegularInner>
  get serializer =>
      _$AdminCaptainViolationsDtoOutputTypesRegularInnerSerializer();
}

class _$AdminCaptainViolationsDtoOutputTypesRegularInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainViolationsDtoOutputTypesRegularInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutputTypesRegularInner,
    _$AdminCaptainViolationsDtoOutputTypesRegularInner,
  ];

  @override
  final String wireName = r'AdminCaptainViolationsDtoOutputTypesRegularInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputTypesRegularInner object, {
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
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(
        AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputTypesRegularInner object, {
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
    required AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder result,
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
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainViolationsDtoOutputTypesRegularInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder();
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

class AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum none =
      _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_none;
  @BuiltValueEnumConst(wireName: r'optional')
  static const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
  optional =
      _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_optional;
  @BuiltValueEnumConst(wireName: r'required')
  static const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
  required_ =
      _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_required_;

  static Serializer<AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum>
  get serializer =>
      _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumSerializer;

  const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum>
  get values =>
      _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumValues;
  static AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum valueOf(
    String name,
  ) => _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumValueOf(name);
}
