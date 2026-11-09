//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_lines_inner_options_inner.g.dart';

/// AdminOrderDtoOutputOrderLinesInnerOptionsInner
///
/// Properties:
/// * [name] 
/// * [priceDelta] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderLinesInnerOptionsInner implements Built<AdminOrderDtoOutputOrderLinesInnerOptionsInner, AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'priceDelta')
  String get priceDelta;

  AdminOrderDtoOutputOrderLinesInnerOptionsInner._();

  factory AdminOrderDtoOutputOrderLinesInnerOptionsInner([void updates(AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder b)]) = _$AdminOrderDtoOutputOrderLinesInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderLinesInnerOptionsInner> get serializer => _$AdminOrderDtoOutputOrderLinesInnerOptionsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderLinesInnerOptionsInnerSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderLinesInnerOptionsInner> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderLinesInnerOptionsInner, _$AdminOrderDtoOutputOrderLinesInnerOptionsInner];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderLinesInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderLinesInnerOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderLinesInnerOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'priceDelta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceDelta = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderLinesInnerOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder();
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


