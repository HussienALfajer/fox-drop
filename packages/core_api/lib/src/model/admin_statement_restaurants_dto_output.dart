//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_statement_restaurants_dto_output.g.dart';

/// AdminStatementRestaurantsDtoOutput
///
/// Properties:
/// * [restaurants]
@BuiltValue()
abstract class AdminStatementRestaurantsDtoOutput
    implements
        Built<
          AdminStatementRestaurantsDtoOutput,
          AdminStatementRestaurantsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get restaurants;

  AdminStatementRestaurantsDtoOutput._();

  factory AdminStatementRestaurantsDtoOutput([
    void updates(AdminStatementRestaurantsDtoOutputBuilder b),
  ]) = _$AdminStatementRestaurantsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStatementRestaurantsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStatementRestaurantsDtoOutput> get serializer =>
      _$AdminStatementRestaurantsDtoOutputSerializer();
}

class _$AdminStatementRestaurantsDtoOutputSerializer
    implements PrimitiveSerializer<AdminStatementRestaurantsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminStatementRestaurantsDtoOutput,
    _$AdminStatementRestaurantsDtoOutput,
  ];

  @override
  final String wireName = r'AdminStatementRestaurantsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStatementRestaurantsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStatementRestaurantsDtoOutput object, {
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
    required AdminStatementRestaurantsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>;
          result.restaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStatementRestaurantsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStatementRestaurantsDtoOutputBuilder();
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
