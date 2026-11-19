//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_profile_dto_output_earnings_week.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_earnings_today.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_earnings_month.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_earnings.g.dart';

/// AdminCaptainProfileDtoOutputEarnings
///
/// Properties:
/// * [currency]
/// * [balance]
/// * [today]
/// * [week]
/// * [month]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputEarnings
    implements
        Built<
          AdminCaptainProfileDtoOutputEarnings,
          AdminCaptainProfileDtoOutputEarningsBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'today')
  AdminCaptainProfileDtoOutputEarningsToday get today;

  @BuiltValueField(wireName: r'week')
  AdminCaptainProfileDtoOutputEarningsWeek get week;

  @BuiltValueField(wireName: r'month')
  AdminCaptainProfileDtoOutputEarningsMonth get month;

  AdminCaptainProfileDtoOutputEarnings._();

  factory AdminCaptainProfileDtoOutputEarnings([
    void updates(AdminCaptainProfileDtoOutputEarningsBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputEarnings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputEarningsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputEarnings> get serializer =>
      _$AdminCaptainProfileDtoOutputEarningsSerializer();
}

class _$AdminCaptainProfileDtoOutputEarningsSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputEarnings> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputEarnings,
    _$AdminCaptainProfileDtoOutputEarnings,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputEarnings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputEarnings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputEarningsToday),
    );
    yield r'week';
    yield serializers.serialize(
      object.week,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputEarningsWeek),
    );
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputEarningsMonth),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputEarnings object, {
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
    required AdminCaptainProfileDtoOutputEarningsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
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
        case r'today':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputEarningsToday,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputEarningsToday;
          result.today.replace(valueDes);
          break;
        case r'week':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputEarningsWeek,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputEarningsWeek;
          result.week.replace(valueDes);
          break;
        case r'month':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputEarningsMonth,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputEarningsMonth;
          result.month.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutputEarnings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputEarningsBuilder();
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
