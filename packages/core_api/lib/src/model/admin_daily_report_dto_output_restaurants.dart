//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_restaurants.g.dart';

/// AdminDailyReportDtoOutputRestaurants
///
/// Properties:
/// * [commission]
/// * [discountShare]
/// * [owedByRestaurants]
/// * [owedToRestaurants]
@BuiltValue()
abstract class AdminDailyReportDtoOutputRestaurants
    implements
        Built<
          AdminDailyReportDtoOutputRestaurants,
          AdminDailyReportDtoOutputRestaurantsBuilder
        > {
  @BuiltValueField(wireName: r'commission')
  String get commission;

  @BuiltValueField(wireName: r'discountShare')
  String get discountShare;

  @BuiltValueField(wireName: r'owedByRestaurants')
  String get owedByRestaurants;

  @BuiltValueField(wireName: r'owedToRestaurants')
  String get owedToRestaurants;

  AdminDailyReportDtoOutputRestaurants._();

  factory AdminDailyReportDtoOutputRestaurants([
    void updates(AdminDailyReportDtoOutputRestaurantsBuilder b),
  ]) = _$AdminDailyReportDtoOutputRestaurants;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputRestaurantsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputRestaurants> get serializer =>
      _$AdminDailyReportDtoOutputRestaurantsSerializer();
}

class _$AdminDailyReportDtoOutputRestaurantsSerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputRestaurants> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputRestaurants,
    _$AdminDailyReportDtoOutputRestaurants,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputRestaurants';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputRestaurants object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'discountShare';
    yield serializers.serialize(
      object.discountShare,
      specifiedType: const FullType(String),
    );
    yield r'owedByRestaurants';
    yield serializers.serialize(
      object.owedByRestaurants,
      specifiedType: const FullType(String),
    );
    yield r'owedToRestaurants';
    yield serializers.serialize(
      object.owedToRestaurants,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputRestaurants object, {
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
    required AdminDailyReportDtoOutputRestaurantsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'discountShare':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discountShare = valueDes;
          break;
        case r'owedByRestaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.owedByRestaurants = valueDes;
          break;
        case r'owedToRestaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.owedToRestaurants = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputRestaurants deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputRestaurantsBuilder();
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
