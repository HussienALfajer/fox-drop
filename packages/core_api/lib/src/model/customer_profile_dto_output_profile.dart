//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_profile_dto_output_profile.g.dart';

/// CustomerProfileDtoOutputProfile
///
/// Properties:
/// * [firstName] - «الاسم»: 2 to 30 Arabic or Latin letters, spaces and «-».
/// * [lastName] - «الكنية», optional, the same rule.
/// * [gender] - «ذكر» male or «أنثى» female.
/// * [birthday] - «تاريخ الميلاد», optional, a past date.
@BuiltValue()
abstract class CustomerProfileDtoOutputProfile implements Built<CustomerProfileDtoOutputProfile, CustomerProfileDtoOutputProfileBuilder> {
  /// «الاسم»: 2 to 30 Arabic or Latin letters, spaces and «-».
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  /// «الكنية», optional, the same rule.
  @BuiltValueField(wireName: r'lastName')
  String? get lastName;

  /// «ذكر» male or «أنثى» female.
  @BuiltValueField(wireName: r'gender')
  CustomerProfileDtoOutputProfileGenderEnum get gender;
  // enum genderEnum {  male,  female,  };

  /// «تاريخ الميلاد», optional, a past date.
  @BuiltValueField(wireName: r'birthday')
  Date? get birthday;

  CustomerProfileDtoOutputProfile._();

  factory CustomerProfileDtoOutputProfile([void updates(CustomerProfileDtoOutputProfileBuilder b)]) = _$CustomerProfileDtoOutputProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerProfileDtoOutputProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerProfileDtoOutputProfile> get serializer => _$CustomerProfileDtoOutputProfileSerializer();
}

class _$CustomerProfileDtoOutputProfileSerializer implements PrimitiveSerializer<CustomerProfileDtoOutputProfile> {
  @override
  final Iterable<Type> types = const [CustomerProfileDtoOutputProfile, _$CustomerProfileDtoOutputProfile];

  @override
  final String wireName = r'CustomerProfileDtoOutputProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerProfileDtoOutputProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield object.lastName == null ? null : serializers.serialize(
      object.lastName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'gender';
    yield serializers.serialize(
      object.gender,
      specifiedType: const FullType(CustomerProfileDtoOutputProfileGenderEnum),
    );
    yield r'birthday';
    yield object.birthday == null ? null : serializers.serialize(
      object.birthday,
      specifiedType: const FullType.nullable(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerProfileDtoOutputProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerProfileDtoOutputProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastName = valueDes;
          break;
        case r'gender':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerProfileDtoOutputProfileGenderEnum),
          ) as CustomerProfileDtoOutputProfileGenderEnum;
          result.gender = valueDes;
          break;
        case r'birthday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.birthday = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerProfileDtoOutputProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerProfileDtoOutputProfileBuilder();
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


/// «ذكر» male or «أنثى» female.
class CustomerProfileDtoOutputProfileGenderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'male')
  static const CustomerProfileDtoOutputProfileGenderEnum male = _$customerProfileDtoOutputProfileGenderEnum_male;
  @BuiltValueEnumConst(wireName: r'female')
  static const CustomerProfileDtoOutputProfileGenderEnum female = _$customerProfileDtoOutputProfileGenderEnum_female;

  static Serializer<CustomerProfileDtoOutputProfileGenderEnum> get serializer => _$customerProfileDtoOutputProfileGenderEnumSerializer;

  const CustomerProfileDtoOutputProfileGenderEnum._(String name): super(name);

  static BuiltSet<CustomerProfileDtoOutputProfileGenderEnum> get values => _$customerProfileDtoOutputProfileGenderEnumValues;
  static CustomerProfileDtoOutputProfileGenderEnum valueOf(String name) => _$customerProfileDtoOutputProfileGenderEnumValueOf(name);
}

