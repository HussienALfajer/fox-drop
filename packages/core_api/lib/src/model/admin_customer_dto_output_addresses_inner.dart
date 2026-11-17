//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_addresses_inner.g.dart';

/// AdminCustomerDtoOutputAddressesInner
///
/// Properties:
/// * [id]
/// * [label]
/// * [customLabel]
/// * [street]
/// * [floor]
/// * [landmark]
/// * [neighbourhood]
/// * [location]
/// * [isDefault]
/// * [recipientName]
/// * [maskedContactPhone] - Another contact number, masked; null is the account's own.
@BuiltValue()
abstract class AdminCustomerDtoOutputAddressesInner
    implements
        Built<
          AdminCustomerDtoOutputAddressesInner,
          AdminCustomerDtoOutputAddressesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'customLabel')
  String? get customLabel;

  @BuiltValueField(wireName: r'street')
  String get street;

  @BuiltValueField(wireName: r'floor')
  String? get floor;

  @BuiltValueField(wireName: r'landmark')
  String get landmark;

  @BuiltValueField(wireName: r'neighbourhood')
  String? get neighbourhood;

  @BuiltValueField(wireName: r'location')
  AdminCustomerDtoOutputAddressesInnerLocation get location;

  @BuiltValueField(wireName: r'isDefault')
  bool get isDefault;

  @BuiltValueField(wireName: r'recipientName')
  String? get recipientName;

  /// Another contact number, masked; null is the account's own.
  @BuiltValueField(wireName: r'maskedContactPhone')
  String? get maskedContactPhone;

  AdminCustomerDtoOutputAddressesInner._();

  factory AdminCustomerDtoOutputAddressesInner([
    void updates(AdminCustomerDtoOutputAddressesInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputAddressesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputAddressesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputAddressesInner> get serializer =>
      _$AdminCustomerDtoOutputAddressesInnerSerializer();
}

class _$AdminCustomerDtoOutputAddressesInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputAddressesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputAddressesInner,
    _$AdminCustomerDtoOutputAddressesInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputAddressesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputAddressesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'customLabel';
    yield object.customLabel == null
        ? null
        : serializers.serialize(
            object.customLabel,
            specifiedType: const FullType.nullable(String),
          );
    yield r'street';
    yield serializers.serialize(
      object.street,
      specifiedType: const FullType(String),
    );
    yield r'floor';
    yield object.floor == null
        ? null
        : serializers.serialize(
            object.floor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'landmark';
    yield serializers.serialize(
      object.landmark,
      specifiedType: const FullType(String),
    );
    yield r'neighbourhood';
    yield object.neighbourhood == null
        ? null
        : serializers.serialize(
            object.neighbourhood,
            specifiedType: const FullType.nullable(String),
          );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        AdminCustomerDtoOutputAddressesInnerLocation,
      ),
    );
    yield r'isDefault';
    yield serializers.serialize(
      object.isDefault,
      specifiedType: const FullType(bool),
    );
    yield r'recipientName';
    yield object.recipientName == null
        ? null
        : serializers.serialize(
            object.recipientName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'maskedContactPhone';
    yield object.maskedContactPhone == null
        ? null
        : serializers.serialize(
            object.maskedContactPhone,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputAddressesInner object, {
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
    required AdminCustomerDtoOutputAddressesInnerBuilder result,
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'customLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customLabel = valueDes;
          break;
        case r'street':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.street = valueDes;
          break;
        case r'floor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.floor = valueDes;
          break;
        case r'landmark':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.landmark = valueDes;
          break;
        case r'neighbourhood':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.neighbourhood = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputAddressesInnerLocation,
                    ),
                  )
                  as AdminCustomerDtoOutputAddressesInnerLocation;
          result.location.replace(valueDes);
          break;
        case r'isDefault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isDefault = valueDes;
          break;
        case r'recipientName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.recipientName = valueDes;
          break;
        case r'maskedContactPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maskedContactPhone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputAddressesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputAddressesInnerBuilder();
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
