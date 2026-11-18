//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner_location.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_route_dto_output_route.g.dart';

/// CaptainOrderRouteDtoOutputRoute
///
/// Properties:
/// * [metres]
/// * [seconds]
/// * [method]
/// * [line]
@BuiltValue()
abstract class CaptainOrderRouteDtoOutputRoute
    implements
        Built<
          CaptainOrderRouteDtoOutputRoute,
          CaptainOrderRouteDtoOutputRouteBuilder
        > {
  @BuiltValueField(wireName: r'metres')
  int get metres;

  @BuiltValueField(wireName: r'seconds')
  int get seconds;

  @BuiltValueField(wireName: r'method')
  CaptainOrderRouteDtoOutputRouteMethodEnum get method;
  // enum methodEnum {  road,  straight_x1.3,  };

  @BuiltValueField(wireName: r'line')
  BuiltList<AdminCustomerDtoOutputAddressesInnerLocation>? get line;

  CaptainOrderRouteDtoOutputRoute._();

  factory CaptainOrderRouteDtoOutputRoute([
    void updates(CaptainOrderRouteDtoOutputRouteBuilder b),
  ]) = _$CaptainOrderRouteDtoOutputRoute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderRouteDtoOutputRouteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderRouteDtoOutputRoute> get serializer =>
      _$CaptainOrderRouteDtoOutputRouteSerializer();
}

class _$CaptainOrderRouteDtoOutputRouteSerializer
    implements PrimitiveSerializer<CaptainOrderRouteDtoOutputRoute> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderRouteDtoOutputRoute,
    _$CaptainOrderRouteDtoOutputRoute,
  ];

  @override
  final String wireName = r'CaptainOrderRouteDtoOutputRoute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderRouteDtoOutputRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'metres';
    yield serializers.serialize(
      object.metres,
      specifiedType: const FullType(int),
    );
    yield r'seconds';
    yield serializers.serialize(
      object.seconds,
      specifiedType: const FullType(int),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(CaptainOrderRouteDtoOutputRouteMethodEnum),
    );
    yield r'line';
    yield object.line == null
        ? null
        : serializers.serialize(
            object.line,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(AdminCustomerDtoOutputAddressesInnerLocation),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderRouteDtoOutputRoute object, {
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
    required CaptainOrderRouteDtoOutputRouteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.metres = valueDes;
          break;
        case r'seconds':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.seconds = valueDes;
          break;
        case r'method':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderRouteDtoOutputRouteMethodEnum,
                    ),
                  )
                  as CaptainOrderRouteDtoOutputRouteMethodEnum;
          result.method = valueDes;
          break;
        case r'line':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(AdminCustomerDtoOutputAddressesInnerLocation),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputAddressesInnerLocation>?;
          if (valueDes == null) continue;
          result.line.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderRouteDtoOutputRoute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderRouteDtoOutputRouteBuilder();
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

class CaptainOrderRouteDtoOutputRouteMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'road')
  static const CaptainOrderRouteDtoOutputRouteMethodEnum road =
      _$captainOrderRouteDtoOutputRouteMethodEnum_road;
  @BuiltValueEnumConst(wireName: r'straight_x1.3')
  static const CaptainOrderRouteDtoOutputRouteMethodEnum straightX1Period3 =
      _$captainOrderRouteDtoOutputRouteMethodEnum_straightX1Period3;

  static Serializer<CaptainOrderRouteDtoOutputRouteMethodEnum> get serializer =>
      _$captainOrderRouteDtoOutputRouteMethodEnumSerializer;

  const CaptainOrderRouteDtoOutputRouteMethodEnum._(String name) : super(name);

  static BuiltSet<CaptainOrderRouteDtoOutputRouteMethodEnum> get values =>
      _$captainOrderRouteDtoOutputRouteMethodEnumValues;
  static CaptainOrderRouteDtoOutputRouteMethodEnum valueOf(String name) =>
      _$captainOrderRouteDtoOutputRouteMethodEnumValueOf(name);
}
