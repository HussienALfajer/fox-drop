//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_request_option.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_option_group_request_dto.g.dart';

/// MerchantOptionGroupRequestDto
///
/// Properties:
/// * [name]
/// * [minChoices]
/// * [maxChoices]
/// * [itemIds] - The items the group is linked to, as a set.
/// * [options] - The options asked; a published option left out stays as it is.
@BuiltValue()
abstract class MerchantOptionGroupRequestDto
    implements
        Built<
          MerchantOptionGroupRequestDto,
          MerchantOptionGroupRequestDtoBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'minChoices')
  int get minChoices;

  @BuiltValueField(wireName: r'maxChoices')
  int get maxChoices;

  /// The items the group is linked to, as a set.
  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String> get itemIds;

  /// The options asked; a published option left out stays as it is.
  @BuiltValueField(wireName: r'options')
  BuiltList<MerchantRequestOption> get options;

  MerchantOptionGroupRequestDto._();

  factory MerchantOptionGroupRequestDto([
    void updates(MerchantOptionGroupRequestDtoBuilder b),
  ]) = _$MerchantOptionGroupRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOptionGroupRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOptionGroupRequestDto> get serializer =>
      _$MerchantOptionGroupRequestDtoSerializer();
}

class _$MerchantOptionGroupRequestDtoSerializer
    implements PrimitiveSerializer<MerchantOptionGroupRequestDto> {
  @override
  final Iterable<Type> types = const [
    MerchantOptionGroupRequestDto,
    _$MerchantOptionGroupRequestDto,
  ];

  @override
  final String wireName = r'MerchantOptionGroupRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOptionGroupRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'minChoices';
    yield serializers.serialize(
      object.minChoices,
      specifiedType: const FullType(int),
    );
    yield r'maxChoices';
    yield serializers.serialize(
      object.maxChoices,
      specifiedType: const FullType(int),
    );
    yield r'itemIds';
    yield serializers.serialize(
      object.itemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantRequestOption),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOptionGroupRequestDto object, {
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
    required MerchantOptionGroupRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'minChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.minChoices = valueDes;
          break;
        case r'maxChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.maxChoices = valueDes;
          break;
        case r'itemIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.itemIds.replace(valueDes);
          break;
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantRequestOption),
                    ]),
                  )
                  as BuiltList<MerchantRequestOption>;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOptionGroupRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOptionGroupRequestDtoBuilder();
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
