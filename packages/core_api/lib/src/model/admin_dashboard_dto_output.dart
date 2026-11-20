//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_dashboard_dto_output_tasks_inner.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_today.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_hours_inner.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_troubled_restaurants_inner.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_top_restaurants_inner.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output.g.dart';

/// AdminDashboardDtoOutput
///
/// Properties:
/// * [cityId]
/// * [day] - A business day on the city’s clock, YYYY-MM-DD.
/// * [lastWeekDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [status]
/// * [today]
/// * [lastWeek]
/// * [tasks]
/// * [hours]
/// * [topRestaurants]
/// * [troubledRestaurants]
@BuiltValue()
abstract class AdminDashboardDtoOutput
    implements Built<AdminDashboardDtoOutput, AdminDashboardDtoOutputBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'day')
  String get day;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'lastWeekDay')
  String get lastWeekDay;

  @BuiltValueField(wireName: r'status')
  AdminDashboardDtoOutputStatus get status;

  @BuiltValueField(wireName: r'today')
  AdminDashboardDtoOutputToday get today;

  @BuiltValueField(wireName: r'lastWeek')
  AdminDashboardDtoOutputToday get lastWeek;

  @BuiltValueField(wireName: r'tasks')
  BuiltList<AdminDashboardDtoOutputTasksInner> get tasks;

  @BuiltValueField(wireName: r'hours')
  BuiltList<AdminDashboardDtoOutputHoursInner> get hours;

  @BuiltValueField(wireName: r'topRestaurants')
  BuiltList<AdminDashboardDtoOutputTopRestaurantsInner> get topRestaurants;

  @BuiltValueField(wireName: r'troubledRestaurants')
  BuiltList<AdminDashboardDtoOutputTroubledRestaurantsInner>
  get troubledRestaurants;

  AdminDashboardDtoOutput._();

  factory AdminDashboardDtoOutput([
    void updates(AdminDashboardDtoOutputBuilder b),
  ]) = _$AdminDashboardDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutput> get serializer =>
      _$AdminDashboardDtoOutputSerializer();
}

class _$AdminDashboardDtoOutputSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutput,
    _$AdminDashboardDtoOutput,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(String),
    );
    yield r'lastWeekDay';
    yield serializers.serialize(
      object.lastWeekDay,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminDashboardDtoOutputStatus),
    );
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(AdminDashboardDtoOutputToday),
    );
    yield r'lastWeek';
    yield serializers.serialize(
      object.lastWeek,
      specifiedType: const FullType(AdminDashboardDtoOutputToday),
    );
    yield r'tasks';
    yield serializers.serialize(
      object.tasks,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDashboardDtoOutputTasksInner),
      ]),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDashboardDtoOutputHoursInner),
      ]),
    );
    yield r'topRestaurants';
    yield serializers.serialize(
      object.topRestaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDashboardDtoOutputTopRestaurantsInner),
      ]),
    );
    yield r'troubledRestaurants';
    yield serializers.serialize(
      object.troubledRestaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDashboardDtoOutputTroubledRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutput object, {
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
    required AdminDashboardDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'day':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.day = valueDes;
          break;
        case r'lastWeekDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.lastWeekDay = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDashboardDtoOutputStatus,
                    ),
                  )
                  as AdminDashboardDtoOutputStatus;
          result.status.replace(valueDes);
          break;
        case r'today':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminDashboardDtoOutputToday),
                  )
                  as AdminDashboardDtoOutputToday;
          result.today.replace(valueDes);
          break;
        case r'lastWeek':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminDashboardDtoOutputToday),
                  )
                  as AdminDashboardDtoOutputToday;
          result.lastWeek.replace(valueDes);
          break;
        case r'tasks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDashboardDtoOutputTasksInner),
                    ]),
                  )
                  as BuiltList<AdminDashboardDtoOutputTasksInner>;
          result.tasks.replace(valueDes);
          break;
        case r'hours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDashboardDtoOutputHoursInner),
                    ]),
                  )
                  as BuiltList<AdminDashboardDtoOutputHoursInner>;
          result.hours.replace(valueDes);
          break;
        case r'topRestaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDashboardDtoOutputTopRestaurantsInner),
                    ]),
                  )
                  as BuiltList<AdminDashboardDtoOutputTopRestaurantsInner>;
          result.topRestaurants.replace(valueDes);
          break;
        case r'troubledRestaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDashboardDtoOutputTroubledRestaurantsInner),
                    ]),
                  )
                  as BuiltList<AdminDashboardDtoOutputTroubledRestaurantsInner>;
          result.troubledRestaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputBuilder();
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
