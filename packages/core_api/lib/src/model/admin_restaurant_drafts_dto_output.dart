//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_drafts_dto_output_drafts_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_drafts_dto_output.g.dart';

/// AdminRestaurantDraftsDtoOutput
///
/// Properties:
/// * [drafts]
@BuiltValue()
abstract class AdminRestaurantDraftsDtoOutput
    implements
        Built<
          AdminRestaurantDraftsDtoOutput,
          AdminRestaurantDraftsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'drafts')
  BuiltList<AdminRestaurantDraftsDtoOutputDraftsInner> get drafts;

  AdminRestaurantDraftsDtoOutput._();

  factory AdminRestaurantDraftsDtoOutput([
    void updates(AdminRestaurantDraftsDtoOutputBuilder b),
  ]) = _$AdminRestaurantDraftsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftsDtoOutput> get serializer =>
      _$AdminRestaurantDraftsDtoOutputSerializer();
}

class _$AdminRestaurantDraftsDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftsDtoOutput,
    _$AdminRestaurantDraftsDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'drafts';
    yield serializers.serialize(
      object.drafts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantDraftsDtoOutputDraftsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftsDtoOutput object, {
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
    required AdminRestaurantDraftsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'drafts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantDraftsDtoOutputDraftsInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantDraftsDtoOutputDraftsInner>;
          result.drafts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftsDtoOutputBuilder();
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
