//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_discounts.g.dart';

/// AdminDailyReportDtoOutputDiscounts
///
/// Properties:
/// * [platform]
/// * [restaurant]
@BuiltValue()
abstract class AdminDailyReportDtoOutputDiscounts
    implements
        Built<
          AdminDailyReportDtoOutputDiscounts,
          AdminDailyReportDtoOutputDiscountsBuilder
        > {
  @BuiltValueField(wireName: r'platform')
  String get platform;

  @BuiltValueField(wireName: r'restaurant')
  String get restaurant;

  AdminDailyReportDtoOutputDiscounts._();

  factory AdminDailyReportDtoOutputDiscounts([
    void updates(AdminDailyReportDtoOutputDiscountsBuilder b),
  ]) = _$AdminDailyReportDtoOutputDiscounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputDiscountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputDiscounts> get serializer =>
      _$AdminDailyReportDtoOutputDiscountsSerializer();
}

class _$AdminDailyReportDtoOutputDiscountsSerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputDiscounts> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputDiscounts,
    _$AdminDailyReportDtoOutputDiscounts,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputDiscounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputDiscounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(String),
    );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputDiscounts object, {
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
    required AdminDailyReportDtoOutputDiscountsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platform':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.platform = valueDes;
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurant = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputDiscounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputDiscountsBuilder();
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
