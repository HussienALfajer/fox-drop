//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_now_overdue_restaurants_inner.g.dart';

/// AdminDailyReportDtoOutputNowOverdueRestaurantsInner
///
/// Properties:
/// * [restaurantId]
/// * [name]
/// * [balance] - + the restaurant owes.
/// * [overdueSince]
@BuiltValue()
abstract class AdminDailyReportDtoOutputNowOverdueRestaurantsInner
    implements
        Built<
          AdminDailyReportDtoOutputNowOverdueRestaurantsInner,
          AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// + the restaurant owes.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'overdueSince')
  DateTime get overdueSince;

  AdminDailyReportDtoOutputNowOverdueRestaurantsInner._();

  factory AdminDailyReportDtoOutputNowOverdueRestaurantsInner([
    void updates(AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder b),
  ]) = _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>
  get serializer =>
      _$AdminDailyReportDtoOutputNowOverdueRestaurantsInnerSerializer();
}

class _$AdminDailyReportDtoOutputNowOverdueRestaurantsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminDailyReportDtoOutputNowOverdueRestaurantsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputNowOverdueRestaurantsInner,
    _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner,
  ];

  @override
  final String wireName =
      r'AdminDailyReportDtoOutputNowOverdueRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputNowOverdueRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'overdueSince';
    yield serializers.serialize(
      object.overdueSince,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputNowOverdueRestaurantsInner object, {
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
    required AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'balance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.balance = valueDes;
          break;
        case r'overdueSince':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.overdueSince = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputNowOverdueRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder();
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
