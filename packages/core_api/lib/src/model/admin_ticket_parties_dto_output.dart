//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_draft_choices_dto_output_categories_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_parties_dto_output.g.dart';

/// AdminTicketPartiesDtoOutput
///
/// Properties:
/// * [parties]
@BuiltValue()
abstract class AdminTicketPartiesDtoOutput
    implements
        Built<AdminTicketPartiesDtoOutput, AdminTicketPartiesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'parties')
  BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner> get parties;

  AdminTicketPartiesDtoOutput._();

  factory AdminTicketPartiesDtoOutput([
    void updates(AdminTicketPartiesDtoOutputBuilder b),
  ]) = _$AdminTicketPartiesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPartiesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPartiesDtoOutput> get serializer =>
      _$AdminTicketPartiesDtoOutputSerializer();
}

class _$AdminTicketPartiesDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketPartiesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPartiesDtoOutput,
    _$AdminTicketPartiesDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketPartiesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPartiesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'parties';
    yield serializers.serialize(
      object.parties,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantDraftChoicesDtoOutputCategoriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPartiesDtoOutput object, {
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
    required AdminTicketPartiesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'parties':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantDraftChoicesDtoOutputCategoriesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantDraftChoicesDtoOutputCategoriesInner
                  >;
          result.parties.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPartiesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPartiesDtoOutputBuilder();
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
