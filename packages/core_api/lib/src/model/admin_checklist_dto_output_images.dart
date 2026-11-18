//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_checklist_dto_output_images.g.dart';

/// AdminChecklistDtoOutputImages
///
/// Properties:
/// * [withPhoto]
/// * [total] - The visible items of the visible categories.
/// * [requiredPct]
@BuiltValue()
abstract class AdminChecklistDtoOutputImages
    implements
        Built<
          AdminChecklistDtoOutputImages,
          AdminChecklistDtoOutputImagesBuilder
        > {
  @BuiltValueField(wireName: r'withPhoto')
  int get withPhoto;

  /// The visible items of the visible categories.
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'requiredPct')
  int get requiredPct;

  AdminChecklistDtoOutputImages._();

  factory AdminChecklistDtoOutputImages([
    void updates(AdminChecklistDtoOutputImagesBuilder b),
  ]) = _$AdminChecklistDtoOutputImages;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChecklistDtoOutputImagesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChecklistDtoOutputImages> get serializer =>
      _$AdminChecklistDtoOutputImagesSerializer();
}

class _$AdminChecklistDtoOutputImagesSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutputImages> {
  @override
  final Iterable<Type> types = const [
    AdminChecklistDtoOutputImages,
    _$AdminChecklistDtoOutputImages,
  ];

  @override
  final String wireName = r'AdminChecklistDtoOutputImages';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChecklistDtoOutputImages object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'withPhoto';
    yield serializers.serialize(
      object.withPhoto,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'requiredPct';
    yield serializers.serialize(
      object.requiredPct,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutputImages object, {
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
    required AdminChecklistDtoOutputImagesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'withPhoto':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.withPhoto = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.total = valueDes;
          break;
        case r'requiredPct':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.requiredPct = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChecklistDtoOutputImages deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChecklistDtoOutputImagesBuilder();
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
