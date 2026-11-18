//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_checklist_dto_output_images_waiver.g.dart';

/// OWN's waiver of the image rule; null without one.
///
/// Properties:
/// * [at]
/// * [by]
@BuiltValue()
abstract class AdminChecklistDtoOutputImagesWaiver
    implements
        Built<
          AdminChecklistDtoOutputImagesWaiver,
          AdminChecklistDtoOutputImagesWaiverBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'by')
  String get by;

  AdminChecklistDtoOutputImagesWaiver._();

  factory AdminChecklistDtoOutputImagesWaiver([
    void updates(AdminChecklistDtoOutputImagesWaiverBuilder b),
  ]) = _$AdminChecklistDtoOutputImagesWaiver;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChecklistDtoOutputImagesWaiverBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChecklistDtoOutputImagesWaiver> get serializer =>
      _$AdminChecklistDtoOutputImagesWaiverSerializer();
}

class _$AdminChecklistDtoOutputImagesWaiverSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutputImagesWaiver> {
  @override
  final Iterable<Type> types = const [
    AdminChecklistDtoOutputImagesWaiver,
    _$AdminChecklistDtoOutputImagesWaiver,
  ];

  @override
  final String wireName = r'AdminChecklistDtoOutputImagesWaiver';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChecklistDtoOutputImagesWaiver object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'by';
    yield serializers.serialize(
      object.by,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutputImagesWaiver object, {
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
    required AdminChecklistDtoOutputImagesWaiverBuilder result,
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
        case r'by':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.by = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChecklistDtoOutputImagesWaiver deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChecklistDtoOutputImagesWaiverBuilder();
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
