//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_basics_dto.g.dart';

/// AdminDraftBasicsDto
///
/// Properties:
/// * [cityId] - The city of a new draft; the same city for a saved one.
/// * [nameAr]
/// * [nameEn]
/// * [categoryIds] - Active categories of «التصنيفات», once each, in the chosen order.
/// * [description]
@BuiltValue()
abstract class AdminDraftBasicsDto
    implements Built<AdminDraftBasicsDto, AdminDraftBasicsDtoBuilder> {
  /// The city of a new draft; the same city for a saved one.
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  /// Active categories of «التصنيفات», once each, in the chosen order.
  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  @BuiltValueField(wireName: r'description')
  String? get description;

  AdminDraftBasicsDto._();

  factory AdminDraftBasicsDto([void updates(AdminDraftBasicsDtoBuilder b)]) =
      _$AdminDraftBasicsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftBasicsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftBasicsDto> get serializer =>
      _$AdminDraftBasicsDtoSerializer();
}

class _$AdminDraftBasicsDtoSerializer
    implements PrimitiveSerializer<AdminDraftBasicsDto> {
  @override
  final Iterable<Type> types = const [
    AdminDraftBasicsDto,
    _$AdminDraftBasicsDto,
  ];

  @override
  final String wireName = r'AdminDraftBasicsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftBasicsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'nameEn';
    yield object.nameEn == null
        ? null
        : serializers.serialize(
            object.nameEn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'categoryIds';
    yield serializers.serialize(
      object.categoryIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftBasicsDto object, {
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
    required AdminDraftBasicsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'nameEn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.nameEn = valueDes;
          break;
        case r'categoryIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.categoryIds.replace(valueDes);
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftBasicsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftBasicsDtoBuilder();
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
