//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_home_sections_dto_output_sections_inner.g.dart';

/// AdminHomeSectionsDtoOutputSectionsInner
///
/// Properties:
/// * [key] - A built-in section's kind, or a custom section's id: what the commands name.
/// * [kind] - «البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section.
/// * [title] - A custom section's title; null for a built-in one.
/// * [restaurantIds] - A custom section's restaurants in the admin's order; empty for a built-in one.
/// * [visible]
@BuiltValue()
abstract class AdminHomeSectionsDtoOutputSectionsInner
    implements
        Built<
          AdminHomeSectionsDtoOutputSectionsInner,
          AdminHomeSectionsDtoOutputSectionsInnerBuilder
        > {
  /// A built-in section's kind, or a custom section's id: what the commands name.
  @BuiltValueField(wireName: r'key')
  String get key;

  /// «البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section.
  @BuiltValueField(wireName: r'kind')
  AdminHomeSectionsDtoOutputSectionsInnerKindEnum get kind;
  // enum kindEnum {  banners,  categories,  nearest,  most_ordered,  new,  offers,  custom,  };

  /// A custom section's title; null for a built-in one.
  @BuiltValueField(wireName: r'title')
  String? get title;

  /// A custom section's restaurants in the admin's order; empty for a built-in one.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  @BuiltValueField(wireName: r'visible')
  bool get visible;

  AdminHomeSectionsDtoOutputSectionsInner._();

  factory AdminHomeSectionsDtoOutputSectionsInner([
    void updates(AdminHomeSectionsDtoOutputSectionsInnerBuilder b),
  ]) = _$AdminHomeSectionsDtoOutputSectionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHomeSectionsDtoOutputSectionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHomeSectionsDtoOutputSectionsInner> get serializer =>
      _$AdminHomeSectionsDtoOutputSectionsInnerSerializer();
}

class _$AdminHomeSectionsDtoOutputSectionsInnerSerializer
    implements PrimitiveSerializer<AdminHomeSectionsDtoOutputSectionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminHomeSectionsDtoOutputSectionsInner,
    _$AdminHomeSectionsDtoOutputSectionsInner,
  ];

  @override
  final String wireName = r'AdminHomeSectionsDtoOutputSectionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHomeSectionsDtoOutputSectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminHomeSectionsDtoOutputSectionsInnerKindEnum,
      ),
    );
    yield r'title';
    yield object.title == null
        ? null
        : serializers.serialize(
            object.title,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurantIds';
    yield serializers.serialize(
      object.restaurantIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'visible';
    yield serializers.serialize(
      object.visible,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHomeSectionsDtoOutputSectionsInner object, {
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
    required AdminHomeSectionsDtoOutputSectionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.key = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminHomeSectionsDtoOutputSectionsInnerKindEnum,
                    ),
                  )
                  as AdminHomeSectionsDtoOutputSectionsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'restaurantIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.restaurantIds.replace(valueDes);
          break;
        case r'visible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.visible = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHomeSectionsDtoOutputSectionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHomeSectionsDtoOutputSectionsInnerBuilder();
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

/// «البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section.
class AdminHomeSectionsDtoOutputSectionsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'banners')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum banners =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_banners;
  @BuiltValueEnumConst(wireName: r'categories')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum categories =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_categories;
  @BuiltValueEnumConst(wireName: r'nearest')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum nearest =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_nearest;
  @BuiltValueEnumConst(wireName: r'most_ordered')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum mostOrdered =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_mostOrdered;
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum new_ =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_new_;
  @BuiltValueEnumConst(wireName: r'offers')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum offers =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_offers;
  @BuiltValueEnumConst(wireName: r'custom')
  static const AdminHomeSectionsDtoOutputSectionsInnerKindEnum custom =
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_custom;

  static Serializer<AdminHomeSectionsDtoOutputSectionsInnerKindEnum>
  get serializer => _$adminHomeSectionsDtoOutputSectionsInnerKindEnumSerializer;

  const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminHomeSectionsDtoOutputSectionsInnerKindEnum> get values =>
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnumValues;
  static AdminHomeSectionsDtoOutputSectionsInnerKindEnum valueOf(String name) =>
      _$adminHomeSectionsDtoOutputSectionsInnerKindEnumValueOf(name);
}
