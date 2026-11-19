//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_template_dto_output.g.dart';

/// AdminMenuImportTemplateDtoOutput
///
/// Properties:
/// * [fileName]
/// * [contentBase64] - The .xlsx workbook, filled with the current menu.
@BuiltValue()
abstract class AdminMenuImportTemplateDtoOutput
    implements
        Built<
          AdminMenuImportTemplateDtoOutput,
          AdminMenuImportTemplateDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  /// The .xlsx workbook, filled with the current menu.
  @BuiltValueField(wireName: r'contentBase64')
  String get contentBase64;

  AdminMenuImportTemplateDtoOutput._();

  factory AdminMenuImportTemplateDtoOutput([
    void updates(AdminMenuImportTemplateDtoOutputBuilder b),
  ]) = _$AdminMenuImportTemplateDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportTemplateDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportTemplateDtoOutput> get serializer =>
      _$AdminMenuImportTemplateDtoOutputSerializer();
}

class _$AdminMenuImportTemplateDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuImportTemplateDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportTemplateDtoOutput,
    _$AdminMenuImportTemplateDtoOutput,
  ];

  @override
  final String wireName = r'AdminMenuImportTemplateDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportTemplateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'contentBase64';
    yield serializers.serialize(
      object.contentBase64,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportTemplateDtoOutput object, {
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
    required AdminMenuImportTemplateDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fileName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fileName = valueDes;
          break;
        case r'contentBase64':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.contentBase64 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuImportTemplateDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportTemplateDtoOutputBuilder();
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
