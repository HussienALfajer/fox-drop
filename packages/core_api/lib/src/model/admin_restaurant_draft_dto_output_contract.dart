//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_contract.g.dart';

/// AdminRestaurantDraftDtoOutputContract
///
/// Properties:
/// * [signedOn]
/// * [durationMonths]
/// * [contractUrl] - The scan's signed GET on the panel's origin, valid 10 minutes.
/// * [licenceUrl]
/// * [confirmedAt]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputContract
    implements
        Built<
          AdminRestaurantDraftDtoOutputContract,
          AdminRestaurantDraftDtoOutputContractBuilder
        > {
  @BuiltValueField(wireName: r'signedOn')
  String? get signedOn;

  @BuiltValueField(wireName: r'durationMonths')
  int? get durationMonths;

  /// The scan's signed GET on the panel's origin, valid 10 minutes.
  @BuiltValueField(wireName: r'contractUrl')
  String? get contractUrl;

  @BuiltValueField(wireName: r'licenceUrl')
  String? get licenceUrl;

  @BuiltValueField(wireName: r'confirmedAt')
  DateTime? get confirmedAt;

  AdminRestaurantDraftDtoOutputContract._();

  factory AdminRestaurantDraftDtoOutputContract([
    void updates(AdminRestaurantDraftDtoOutputContractBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputContract;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftDtoOutputContractBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputContract> get serializer =>
      _$AdminRestaurantDraftDtoOutputContractSerializer();
}

class _$AdminRestaurantDraftDtoOutputContractSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftDtoOutputContract> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputContract,
    _$AdminRestaurantDraftDtoOutputContract,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputContract';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputContract object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedOn';
    yield object.signedOn == null
        ? null
        : serializers.serialize(
            object.signedOn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'durationMonths';
    yield object.durationMonths == null
        ? null
        : serializers.serialize(
            object.durationMonths,
            specifiedType: const FullType.nullable(int),
          );
    yield r'contractUrl';
    yield object.contractUrl == null
        ? null
        : serializers.serialize(
            object.contractUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'licenceUrl';
    yield object.licenceUrl == null
        ? null
        : serializers.serialize(
            object.licenceUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'confirmedAt';
    yield object.confirmedAt == null
        ? null
        : serializers.serialize(
            object.confirmedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputContract object, {
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
    required AdminRestaurantDraftDtoOutputContractBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.signedOn = valueDes;
          break;
        case r'durationMonths':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.durationMonths = valueDes;
          break;
        case r'contractUrl':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.contractUrl = valueDes;
          break;
        case r'licenceUrl':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.licenceUrl = valueDes;
          break;
        case r'confirmedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.confirmedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputContract deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputContractBuilder();
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
