//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_search_dto_output_items_inner_option_groups_inner_options_inner.g.dart';

/// CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta]
/// * [available] - Faded and not pickable when false.
@BuiltValue()
abstract class CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
    implements
        Built<
          CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner,
          CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  CaptainAvailabilityDtoOutputCustodyLimit get priceDelta;

  /// Faded and not pickable when false.
  @BuiltValueField(wireName: r'available')
  bool get available;

  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner._();

  factory CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner([
    void updates(
      CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder b,
    ),
  ]) = _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
  >
  get serializer =>
      _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerSerializer();
}

class _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner,
    _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner,
  ];

  @override
  final String wireName =
      r'CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner object, {
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
    required CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyLimit,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyLimit;
          result.priceDelta.replace(valueDes);
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.available = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder();
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
