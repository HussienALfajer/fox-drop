//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_settle_dto_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dues_pay_dto.g.dart';

/// AdminCustomerDuesPayDto
///
/// Properties:
/// * [cityId]
/// * [customerId]
/// * [due] - The dues the screen showed.
/// * [lines]
@BuiltValue()
abstract class AdminCustomerDuesPayDto
    implements Built<AdminCustomerDuesPayDto, AdminCustomerDuesPayDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'customerId')
  String get customerId;

  /// The dues the screen showed.
  @BuiltValueField(wireName: r'due')
  String get due;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRestaurantSettleDtoLinesInner> get lines;

  AdminCustomerDuesPayDto._();

  factory AdminCustomerDuesPayDto([
    void updates(AdminCustomerDuesPayDtoBuilder b),
  ]) = _$AdminCustomerDuesPayDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDuesPayDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDuesPayDto> get serializer =>
      _$AdminCustomerDuesPayDtoSerializer();
}

class _$AdminCustomerDuesPayDtoSerializer
    implements PrimitiveSerializer<AdminCustomerDuesPayDto> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDuesPayDto,
    _$AdminCustomerDuesPayDto,
  ];

  @override
  final String wireName = r'AdminCustomerDuesPayDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDuesPayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'customerId';
    yield serializers.serialize(
      object.customerId,
      specifiedType: const FullType(String),
    );
    yield r'due';
    yield serializers.serialize(
      object.due,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantSettleDtoLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDuesPayDto object, {
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
    required AdminCustomerDuesPayDtoBuilder result,
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
        case r'customerId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerId = valueDes;
          break;
        case r'due':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.due = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantSettleDtoLinesInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantSettleDtoLinesInner>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDuesPayDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDuesPayDtoBuilder();
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
