//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_banners_dto_output_codes_inner.g.dart';

/// AdminBannersDtoOutputCodesInner
///
/// Properties:
/// * [id]
/// * [code]
@BuiltValue()
abstract class AdminBannersDtoOutputCodesInner
    implements
        Built<
          AdminBannersDtoOutputCodesInner,
          AdminBannersDtoOutputCodesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  AdminBannersDtoOutputCodesInner._();

  factory AdminBannersDtoOutputCodesInner([
    void updates(AdminBannersDtoOutputCodesInnerBuilder b),
  ]) = _$AdminBannersDtoOutputCodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBannersDtoOutputCodesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBannersDtoOutputCodesInner> get serializer =>
      _$AdminBannersDtoOutputCodesInnerSerializer();
}

class _$AdminBannersDtoOutputCodesInnerSerializer
    implements PrimitiveSerializer<AdminBannersDtoOutputCodesInner> {
  @override
  final Iterable<Type> types = const [
    AdminBannersDtoOutputCodesInner,
    _$AdminBannersDtoOutputCodesInner,
  ];

  @override
  final String wireName = r'AdminBannersDtoOutputCodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBannersDtoOutputCodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBannersDtoOutputCodesInner object, {
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
    required AdminBannersDtoOutputCodesInnerBuilder result,
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBannersDtoOutputCodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBannersDtoOutputCodesInnerBuilder();
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
