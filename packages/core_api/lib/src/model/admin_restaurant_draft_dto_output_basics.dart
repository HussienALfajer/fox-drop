//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_basics.g.dart';

/// AdminRestaurantDraftDtoOutputBasics
///
/// Properties:
/// * [nameAr]
/// * [nameEn]
/// * [categoryIds]
/// * [description]
/// * [logoKey]
/// * [coverKey]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputBasics
    implements
        Built<
          AdminRestaurantDraftDtoOutputBasics,
          AdminRestaurantDraftDtoOutputBasicsBuilder
        > {
  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'logoKey')
  String? get logoKey;

  @BuiltValueField(wireName: r'coverKey')
  String? get coverKey;

  AdminRestaurantDraftDtoOutputBasics._();

  factory AdminRestaurantDraftDtoOutputBasics([
    void updates(AdminRestaurantDraftDtoOutputBasicsBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputBasics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftDtoOutputBasicsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputBasics> get serializer =>
      _$AdminRestaurantDraftDtoOutputBasicsSerializer();
}

class _$AdminRestaurantDraftDtoOutputBasicsSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftDtoOutputBasics> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputBasics,
    _$AdminRestaurantDraftDtoOutputBasics,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputBasics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputBasics object, {
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
    yield r'logoKey';
    yield object.logoKey == null
        ? null
        : serializers.serialize(
            object.logoKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'coverKey';
    yield object.coverKey == null
        ? null
        : serializers.serialize(
            object.coverKey,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputBasics object, {
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
    required AdminRestaurantDraftDtoOutputBasicsBuilder result,
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
        case r'logoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.logoKey = valueDes;
          break;
        case r'coverKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.coverKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputBasics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputBasicsBuilder();
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
