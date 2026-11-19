//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_change_log_dto_output_entries_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_change_log_dto_output.g.dart';

/// AdminRestaurantChangeLogDtoOutput
///
/// Properties:
/// * [entries] - The latest 200 changes, newest first.
@BuiltValue()
abstract class AdminRestaurantChangeLogDtoOutput
    implements
        Built<
          AdminRestaurantChangeLogDtoOutput,
          AdminRestaurantChangeLogDtoOutputBuilder
        > {
  /// The latest 200 changes, newest first.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminRestaurantChangeLogDtoOutputEntriesInner> get entries;

  AdminRestaurantChangeLogDtoOutput._();

  factory AdminRestaurantChangeLogDtoOutput([
    void updates(AdminRestaurantChangeLogDtoOutputBuilder b),
  ]) = _$AdminRestaurantChangeLogDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantChangeLogDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantChangeLogDtoOutput> get serializer =>
      _$AdminRestaurantChangeLogDtoOutputSerializer();
}

class _$AdminRestaurantChangeLogDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantChangeLogDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantChangeLogDtoOutput,
    _$AdminRestaurantChangeLogDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantChangeLogDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantChangeLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantChangeLogDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantChangeLogDtoOutput object, {
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
    required AdminRestaurantChangeLogDtoOutputBuilder result,
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
                      FullType(AdminRestaurantChangeLogDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantChangeLogDtoOutputEntriesInner>;
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
  AdminRestaurantChangeLogDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantChangeLogDtoOutputBuilder();
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
