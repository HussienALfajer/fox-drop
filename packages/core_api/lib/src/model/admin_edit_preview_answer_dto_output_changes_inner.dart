//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_preview_answer_dto_output_changes_inner.g.dart';

/// AdminEditPreviewAnswerDtoOutputChangesInner
///
/// Properties:
/// * [kind]
/// * [name]
/// * [options]
/// * [quantity]
/// * [quantityBefore] - quantity: the quantity before.
@BuiltValue()
abstract class AdminEditPreviewAnswerDtoOutputChangesInner
    implements
        Built<
          AdminEditPreviewAnswerDtoOutputChangesInner,
          AdminEditPreviewAnswerDtoOutputChangesInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum get kind;
  // enum kindEnum {  added,  removed,  quantity,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'options')
  BuiltList<String> get options;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  /// quantity: the quantity before.
  @BuiltValueField(wireName: r'quantityBefore')
  int? get quantityBefore;

  AdminEditPreviewAnswerDtoOutputChangesInner._();

  factory AdminEditPreviewAnswerDtoOutputChangesInner([
    void updates(AdminEditPreviewAnswerDtoOutputChangesInnerBuilder b),
  ]) = _$AdminEditPreviewAnswerDtoOutputChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditPreviewAnswerDtoOutputChangesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditPreviewAnswerDtoOutputChangesInner>
  get serializer => _$AdminEditPreviewAnswerDtoOutputChangesInnerSerializer();
}

class _$AdminEditPreviewAnswerDtoOutputChangesInnerSerializer
    implements
        PrimitiveSerializer<AdminEditPreviewAnswerDtoOutputChangesInner> {
  @override
  final Iterable<Type> types = const [
    AdminEditPreviewAnswerDtoOutputChangesInner,
    _$AdminEditPreviewAnswerDtoOutputChangesInner,
  ];

  @override
  final String wireName = r'AdminEditPreviewAnswerDtoOutputChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum,
      ),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    if (object.quantityBefore != null) {
      yield r'quantityBefore';
      yield serializers.serialize(
        object.quantityBefore,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputChangesInner object, {
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
    required AdminEditPreviewAnswerDtoOutputChangesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum,
                    ),
                  )
                  as AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.options.replace(valueDes);
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        case r'quantityBefore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.quantityBefore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditPreviewAnswerDtoOutputChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditPreviewAnswerDtoOutputChangesInnerBuilder();
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

class AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'added')
  static const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum added =
      _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_added;
  @BuiltValueEnumConst(wireName: r'removed')
  static const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum removed =
      _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_removed;
  @BuiltValueEnumConst(wireName: r'quantity')
  static const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum quantity =
      _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_quantity;

  static Serializer<AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum>
  get serializer =>
      _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnumSerializer;

  const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum>
  get values => _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnumValues;
  static AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum valueOf(
    String name,
  ) => _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnumValueOf(name);
}
