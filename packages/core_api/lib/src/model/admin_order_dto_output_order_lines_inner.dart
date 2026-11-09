//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_lines_inner_options_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_lines_inner.g.dart';

/// AdminOrderDtoOutputOrderLinesInner
///
/// Properties:
/// * [itemId] - «رفض نيابة عن المطعم» picks the unavailable items by it.
/// * [name] 
/// * [quantity] 
/// * [options] 
/// * [note] 
/// * [unitPrice] - Integer minor units (AP §8.6).
/// * [lineTotal] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderLinesInner implements Built<AdminOrderDtoOutputOrderLinesInner, AdminOrderDtoOutputOrderLinesInnerBuilder> {
  /// «رفض نيابة عن المطعم» picks the unavailable items by it.
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'options')
  BuiltList<AdminOrderDtoOutputOrderLinesInnerOptionsInner> get options;

  @BuiltValueField(wireName: r'note')
  String? get note;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'unitPrice')
  String get unitPrice;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'lineTotal')
  String get lineTotal;

  AdminOrderDtoOutputOrderLinesInner._();

  factory AdminOrderDtoOutputOrderLinesInner([void updates(AdminOrderDtoOutputOrderLinesInnerBuilder b)]) = _$AdminOrderDtoOutputOrderLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderLinesInner> get serializer => _$AdminOrderDtoOutputOrderLinesInnerSerializer();
}

class _$AdminOrderDtoOutputOrderLinesInnerSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderLinesInner> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderLinesInner, _$AdminOrderDtoOutputOrderLinesInner];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(AdminOrderDtoOutputOrderLinesInnerOptionsInner)]),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'unitPrice';
    yield serializers.serialize(
      object.unitPrice,
      specifiedType: const FullType(String),
    );
    yield r'lineTotal';
    yield serializers.serialize(
      object.lineTotal,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.itemId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quantity = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminOrderDtoOutputOrderLinesInnerOptionsInner)]),
          ) as BuiltList<AdminOrderDtoOutputOrderLinesInnerOptionsInner>;
          result.options.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'unitPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitPrice = valueDes;
          break;
        case r'lineTotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lineTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderLinesInnerBuilder();
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


