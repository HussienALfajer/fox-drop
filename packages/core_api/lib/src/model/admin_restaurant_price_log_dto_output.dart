//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_price_log_dto_output_entries_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_price_log_dto_output.g.dart';

/// AdminRestaurantPriceLogDtoOutput
///
/// Properties:
/// * [entries] - The latest 200, newest first.
@BuiltValue()
abstract class AdminRestaurantPriceLogDtoOutput
    implements
        Built<
          AdminRestaurantPriceLogDtoOutput,
          AdminRestaurantPriceLogDtoOutputBuilder
        > {
  /// The latest 200, newest first.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminRestaurantPriceLogDtoOutputEntriesInner> get entries;

  AdminRestaurantPriceLogDtoOutput._();

  factory AdminRestaurantPriceLogDtoOutput([
    void updates(AdminRestaurantPriceLogDtoOutputBuilder b),
  ]) = _$AdminRestaurantPriceLogDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantPriceLogDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantPriceLogDtoOutput> get serializer =>
      _$AdminRestaurantPriceLogDtoOutputSerializer();
}

class _$AdminRestaurantPriceLogDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantPriceLogDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantPriceLogDtoOutput,
    _$AdminRestaurantPriceLogDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantPriceLogDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantPriceLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantPriceLogDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantPriceLogDtoOutput object, {
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
    required AdminRestaurantPriceLogDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantPriceLogDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantPriceLogDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantPriceLogDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantPriceLogDtoOutputBuilder();
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
