//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_bulk_preview_dto_output_rows_inner.g.dart';

/// AdminMenuBulkPreviewDtoOutputRowsInner
///
/// Properties:
/// * [itemId]
/// * [code]
/// * [name]
/// * [categoryId]
/// * [before] - Integer minor units of the currency, as a string.
/// * [after] - Integer minor units of the currency, as a string.
@BuiltValue()
abstract class AdminMenuBulkPreviewDtoOutputRowsInner
    implements
        Built<
          AdminMenuBulkPreviewDtoOutputRowsInner,
          AdminMenuBulkPreviewDtoOutputRowsInnerBuilder
        > {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'before')
  String get before;

  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'after')
  String? get after;

  AdminMenuBulkPreviewDtoOutputRowsInner._();

  factory AdminMenuBulkPreviewDtoOutputRowsInner([
    void updates(AdminMenuBulkPreviewDtoOutputRowsInnerBuilder b),
  ]) = _$AdminMenuBulkPreviewDtoOutputRowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuBulkPreviewDtoOutputRowsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuBulkPreviewDtoOutputRowsInner> get serializer =>
      _$AdminMenuBulkPreviewDtoOutputRowsInnerSerializer();
}

class _$AdminMenuBulkPreviewDtoOutputRowsInnerSerializer
    implements PrimitiveSerializer<AdminMenuBulkPreviewDtoOutputRowsInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuBulkPreviewDtoOutputRowsInner,
    _$AdminMenuBulkPreviewDtoOutputRowsInner,
  ];

  @override
  final String wireName = r'AdminMenuBulkPreviewDtoOutputRowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuBulkPreviewDtoOutputRowsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'before';
    yield serializers.serialize(
      object.before,
      specifiedType: const FullType(String),
    );
    yield r'after';
    yield object.after == null
        ? null
        : serializers.serialize(
            object.after,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkPreviewDtoOutputRowsInner object, {
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
    required AdminMenuBulkPreviewDtoOutputRowsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemId = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
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
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryId = valueDes;
          break;
        case r'before':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.before = valueDes;
          break;
        case r'after':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.after = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuBulkPreviewDtoOutputRowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuBulkPreviewDtoOutputRowsInnerBuilder();
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
