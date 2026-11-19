//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_bulk_price_result_dto_output.g.dart';

/// AdminMenuBulkPriceResultDtoOutput
///
/// Properties:
/// * [changed]
/// * [unchanged]
@BuiltValue()
abstract class AdminMenuBulkPriceResultDtoOutput
    implements
        Built<
          AdminMenuBulkPriceResultDtoOutput,
          AdminMenuBulkPriceResultDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'changed')
  int get changed;

  @BuiltValueField(wireName: r'unchanged')
  int get unchanged;

  AdminMenuBulkPriceResultDtoOutput._();

  factory AdminMenuBulkPriceResultDtoOutput([
    void updates(AdminMenuBulkPriceResultDtoOutputBuilder b),
  ]) = _$AdminMenuBulkPriceResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuBulkPriceResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuBulkPriceResultDtoOutput> get serializer =>
      _$AdminMenuBulkPriceResultDtoOutputSerializer();
}

class _$AdminMenuBulkPriceResultDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuBulkPriceResultDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuBulkPriceResultDtoOutput,
    _$AdminMenuBulkPriceResultDtoOutput,
  ];

  @override
  final String wireName = r'AdminMenuBulkPriceResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuBulkPriceResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkPriceResultDtoOutput object, {
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
    required AdminMenuBulkPriceResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuBulkPriceResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuBulkPriceResultDtoOutputBuilder();
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
