//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_edit_dto_keep_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_edit_dto_add_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_preview_dto.g.dart';

/// AdminEditPreviewDto
///
/// Properties:
/// * [keep] - The current lines kept, each with its quantity; a line left out is removed. A raised quantity keeps the unit price and counts as items added.
/// * [add] - Lines added from the restaurant's current menu at current prices, available only (400 invalid_edit). A line whose options change is left out of keep and added again.
/// * [deliveryFee] - A new delivery fee in minor units, or null to keep it (the threshold is not checked again).
/// * [extraPrepMin] - Required exactly when items are added to a ready order: it goes back to accepted with this many minutes from now, and the promised time moves by them (400 invalid_edit otherwise).
@BuiltValue()
abstract class AdminEditPreviewDto
    implements Built<AdminEditPreviewDto, AdminEditPreviewDtoBuilder> {
  /// The current lines kept, each with its quantity; a line left out is removed. A raised quantity keeps the unit price and counts as items added.
  @BuiltValueField(wireName: r'keep')
  BuiltList<AdminEditDtoKeepInner> get keep;

  /// Lines added from the restaurant's current menu at current prices, available only (400 invalid_edit). A line whose options change is left out of keep and added again.
  @BuiltValueField(wireName: r'add')
  BuiltList<AdminEditDtoAddInner> get add;

  /// A new delivery fee in minor units, or null to keep it (the threshold is not checked again).
  @BuiltValueField(wireName: r'deliveryFee')
  String? get deliveryFee;

  /// Required exactly when items are added to a ready order: it goes back to accepted with this many minutes from now, and the promised time moves by them (400 invalid_edit otherwise).
  @BuiltValueField(wireName: r'extraPrepMin')
  int? get extraPrepMin;

  AdminEditPreviewDto._();

  factory AdminEditPreviewDto([void updates(AdminEditPreviewDtoBuilder b)]) =
      _$AdminEditPreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditPreviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditPreviewDto> get serializer =>
      _$AdminEditPreviewDtoSerializer();
}

class _$AdminEditPreviewDtoSerializer
    implements PrimitiveSerializer<AdminEditPreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminEditPreviewDto,
    _$AdminEditPreviewDto,
  ];

  @override
  final String wireName = r'AdminEditPreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditPreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'keep';
    yield serializers.serialize(
      object.keep,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditDtoKeepInner),
      ]),
    );
    yield r'add';
    yield serializers.serialize(
      object.add,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditDtoAddInner),
      ]),
    );
    yield r'deliveryFee';
    yield object.deliveryFee == null
        ? null
        : serializers.serialize(
            object.deliveryFee,
            specifiedType: const FullType.nullable(String),
          );
    yield r'extraPrepMin';
    yield object.extraPrepMin == null
        ? null
        : serializers.serialize(
            object.extraPrepMin,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewDto object, {
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
    required AdminEditPreviewDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'keep':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditDtoKeepInner),
                    ]),
                  )
                  as BuiltList<AdminEditDtoKeepInner>;
          result.keep.replace(valueDes);
          break;
        case r'add':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditDtoAddInner),
                    ]),
                  )
                  as BuiltList<AdminEditDtoAddInner>;
          result.add.replace(valueDes);
          break;
        case r'deliveryFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.deliveryFee = valueDes;
          break;
        case r'extraPrepMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.extraPrepMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditPreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditPreviewDtoBuilder();
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
