//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_orders.g.dart';

/// AdminDailyReportDtoOutputOrders
///
/// Properties:
/// * [count]
/// * [gmv]
/// * [itemsValue]
@BuiltValue()
abstract class AdminDailyReportDtoOutputOrders
    implements
        Built<
          AdminDailyReportDtoOutputOrders,
          AdminDailyReportDtoOutputOrdersBuilder
        > {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'gmv')
  String get gmv;

  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  AdminDailyReportDtoOutputOrders._();

  factory AdminDailyReportDtoOutputOrders([
    void updates(AdminDailyReportDtoOutputOrdersBuilder b),
  ]) = _$AdminDailyReportDtoOutputOrders;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputOrdersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputOrders> get serializer =>
      _$AdminDailyReportDtoOutputOrdersSerializer();
}

class _$AdminDailyReportDtoOutputOrdersSerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputOrders> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputOrders,
    _$AdminDailyReportDtoOutputOrders,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputOrders';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputOrders object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputOrders object, {
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
    required AdminDailyReportDtoOutputOrdersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputOrders deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputOrdersBuilder();
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
