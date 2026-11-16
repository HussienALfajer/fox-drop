//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_daily_report_dto_output_now_overdue_restaurants_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_now.g.dart';

/// Today’s state; null for a past day.
///
/// Properties:
/// * [captainsBlocked]
/// * [overdueRestaurants]
@BuiltValue()
abstract class AdminDailyReportDtoOutputNow
    implements
        Built<
          AdminDailyReportDtoOutputNow,
          AdminDailyReportDtoOutputNowBuilder
        > {
  @BuiltValueField(wireName: r'captainsBlocked')
  int get captainsBlocked;

  @BuiltValueField(wireName: r'overdueRestaurants')
  BuiltList<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>
  get overdueRestaurants;

  AdminDailyReportDtoOutputNow._();

  factory AdminDailyReportDtoOutputNow([
    void updates(AdminDailyReportDtoOutputNowBuilder b),
  ]) = _$AdminDailyReportDtoOutputNow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputNowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputNow> get serializer =>
      _$AdminDailyReportDtoOutputNowSerializer();
}

class _$AdminDailyReportDtoOutputNowSerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputNow> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputNow,
    _$AdminDailyReportDtoOutputNow,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputNow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputNow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainsBlocked';
    yield serializers.serialize(
      object.captainsBlocked,
      specifiedType: const FullType(int),
    );
    yield r'overdueRestaurants';
    yield serializers.serialize(
      object.overdueRestaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDailyReportDtoOutputNowOverdueRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputNow object, {
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
    required AdminDailyReportDtoOutputNowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainsBlocked':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.captainsBlocked = valueDes;
          break;
        case r'overdueRestaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminDailyReportDtoOutputNowOverdueRestaurantsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminDailyReportDtoOutputNowOverdueRestaurantsInner
                  >;
          result.overdueRestaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputNow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputNowBuilder();
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
