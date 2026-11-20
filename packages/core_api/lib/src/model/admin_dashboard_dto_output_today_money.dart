//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_today_money.g.dart';

/// In the base; null while an amount has no rate.
///
/// Properties:
/// * [currency]
/// * [gmv] - The customer totals of the orders delivered.
/// * [itemsValue]
/// * [deliveryFees]
/// * [commission]
/// * [margin]
@BuiltValue()
abstract class AdminDashboardDtoOutputTodayMoney
    implements
        Built<
          AdminDashboardDtoOutputTodayMoney,
          AdminDashboardDtoOutputTodayMoneyBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// The customer totals of the orders delivered.
  @BuiltValueField(wireName: r'gmv')
  String get gmv;

  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  @BuiltValueField(wireName: r'deliveryFees')
  String get deliveryFees;

  @BuiltValueField(wireName: r'commission')
  String get commission;

  @BuiltValueField(wireName: r'margin')
  String get margin;

  AdminDashboardDtoOutputTodayMoney._();

  factory AdminDashboardDtoOutputTodayMoney([
    void updates(AdminDashboardDtoOutputTodayMoneyBuilder b),
  ]) = _$AdminDashboardDtoOutputTodayMoney;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputTodayMoneyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputTodayMoney> get serializer =>
      _$AdminDashboardDtoOutputTodayMoneySerializer();
}

class _$AdminDashboardDtoOutputTodayMoneySerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputTodayMoney> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputTodayMoney,
    _$AdminDashboardDtoOutputTodayMoney,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputTodayMoney';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputTodayMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'gmv';
    yield serializers.serialize(
      object.gmv,
      specifiedType: const FullType(String),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'deliveryFees';
    yield serializers.serialize(
      object.deliveryFees,
      specifiedType: const FullType(String),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'margin';
    yield serializers.serialize(
      object.margin,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputTodayMoney object, {
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
    required AdminDashboardDtoOutputTodayMoneyBuilder result,
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
        case r'gmv':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.gmv = valueDes;
          break;
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'deliveryFees':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deliveryFees = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'margin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.margin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputTodayMoney deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputTodayMoneyBuilder();
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
