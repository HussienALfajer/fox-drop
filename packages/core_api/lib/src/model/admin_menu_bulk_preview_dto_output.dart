//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_menu_bulk_preview_dto_output_rows_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_bulk_preview_dto_output.g.dart';

/// AdminMenuBulkPreviewDtoOutput
///
/// Properties:
/// * [currency]
/// * [roundingUnit] - The base's rounding unit each new price is rounded to.
/// * [rows]
/// * [changed]
/// * [unchanged]
/// * [refused] - Above 0, the change cannot be applied.
@BuiltValue()
abstract class AdminMenuBulkPreviewDtoOutput
    implements
        Built<
          AdminMenuBulkPreviewDtoOutput,
          AdminMenuBulkPreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// The base's rounding unit each new price is rounded to.
  @BuiltValueField(wireName: r'roundingUnit')
  String get roundingUnit;

  @BuiltValueField(wireName: r'rows')
  BuiltList<AdminMenuBulkPreviewDtoOutputRowsInner> get rows;

  @BuiltValueField(wireName: r'changed')
  int get changed;

  @BuiltValueField(wireName: r'unchanged')
  int get unchanged;

  /// Above 0, the change cannot be applied.
  @BuiltValueField(wireName: r'refused')
  int get refused;

  AdminMenuBulkPreviewDtoOutput._();

  factory AdminMenuBulkPreviewDtoOutput([
    void updates(AdminMenuBulkPreviewDtoOutputBuilder b),
  ]) = _$AdminMenuBulkPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuBulkPreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuBulkPreviewDtoOutput> get serializer =>
      _$AdminMenuBulkPreviewDtoOutputSerializer();
}

class _$AdminMenuBulkPreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuBulkPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuBulkPreviewDtoOutput,
    _$AdminMenuBulkPreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminMenuBulkPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuBulkPreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'roundingUnit';
    yield serializers.serialize(
      object.roundingUnit,
      specifiedType: const FullType(String),
    );
    yield r'rows';
    yield serializers.serialize(
      object.rows,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuBulkPreviewDtoOutputRowsInner),
      ]),
    );
    yield r'changed';
    yield serializers.serialize(
      object.changed,
      specifiedType: const FullType(int),
    );
    yield r'unchanged';
    yield serializers.serialize(
      object.unchanged,
      specifiedType: const FullType(int),
    );
    yield r'refused';
    yield serializers.serialize(
      object.refused,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkPreviewDtoOutput object, {
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
    required AdminMenuBulkPreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'roundingUnit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.roundingUnit = valueDes;
          break;
        case r'rows':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuBulkPreviewDtoOutputRowsInner),
                    ]),
                  )
                  as BuiltList<AdminMenuBulkPreviewDtoOutputRowsInner>;
          result.rows.replace(valueDes);
          break;
        case r'changed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.changed = valueDes;
          break;
        case r'unchanged':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.unchanged = valueDes;
          break;
        case r'refused':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.refused = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuBulkPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuBulkPreviewDtoOutputBuilder();
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
