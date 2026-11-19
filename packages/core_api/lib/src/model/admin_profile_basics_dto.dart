//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_profile_basics_dto.g.dart';

/// AdminProfileBasicsDto
///
/// Properties:
/// * [nameAr]
/// * [nameEn]
/// * [categoryIds] - Active categories of «التصنيفات», once each, in the chosen order.
/// * [description]
@BuiltValue()
abstract class AdminProfileBasicsDto
    implements Built<AdminProfileBasicsDto, AdminProfileBasicsDtoBuilder> {
  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  /// Active categories of «التصنيفات», once each, in the chosen order.
  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  @BuiltValueField(wireName: r'description')
  String? get description;

  AdminProfileBasicsDto._();

  factory AdminProfileBasicsDto([
    void updates(AdminProfileBasicsDtoBuilder b),
  ]) = _$AdminProfileBasicsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminProfileBasicsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminProfileBasicsDto> get serializer =>
      _$AdminProfileBasicsDtoSerializer();
}

class _$AdminProfileBasicsDtoSerializer
    implements PrimitiveSerializer<AdminProfileBasicsDto> {
  @override
  final Iterable<Type> types = const [
    AdminProfileBasicsDto,
    _$AdminProfileBasicsDto,
  ];

  @override
  final String wireName = r'AdminProfileBasicsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminProfileBasicsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    AdminProfileBasicsDto object, {
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
    required AdminProfileBasicsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  AdminProfileBasicsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminProfileBasicsDtoBuilder();
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
