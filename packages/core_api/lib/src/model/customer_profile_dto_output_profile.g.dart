// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile_dto_output_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerProfileDtoOutputProfileGenderEnum
_$customerProfileDtoOutputProfileGenderEnum_male =
    const CustomerProfileDtoOutputProfileGenderEnum._('male');
const CustomerProfileDtoOutputProfileGenderEnum
_$customerProfileDtoOutputProfileGenderEnum_female =
    const CustomerProfileDtoOutputProfileGenderEnum._('female');

CustomerProfileDtoOutputProfileGenderEnum
_$customerProfileDtoOutputProfileGenderEnumValueOf(String name) {
  switch (name) {
    case 'male':
      return _$customerProfileDtoOutputProfileGenderEnum_male;
    case 'female':
      return _$customerProfileDtoOutputProfileGenderEnum_female;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerProfileDtoOutputProfileGenderEnum>
_$customerProfileDtoOutputProfileGenderEnumValues =
    BuiltSet<CustomerProfileDtoOutputProfileGenderEnum>(
      const <CustomerProfileDtoOutputProfileGenderEnum>[
        _$customerProfileDtoOutputProfileGenderEnum_male,
        _$customerProfileDtoOutputProfileGenderEnum_female,
      ],
    );

Serializer<CustomerProfileDtoOutputProfileGenderEnum>
_$customerProfileDtoOutputProfileGenderEnumSerializer =
    _$CustomerProfileDtoOutputProfileGenderEnumSerializer();

class _$CustomerProfileDtoOutputProfileGenderEnumSerializer
    implements PrimitiveSerializer<CustomerProfileDtoOutputProfileGenderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'male': 'male',
    'female': 'female',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'male': 'male',
    'female': 'female',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerProfileDtoOutputProfileGenderEnum,
  ];
  @override
  final String wireName = 'CustomerProfileDtoOutputProfileGenderEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerProfileDtoOutputProfileGenderEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerProfileDtoOutputProfileGenderEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerProfileDtoOutputProfileGenderEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerProfileDtoOutputProfile
    extends CustomerProfileDtoOutputProfile {
  @override
  final String firstName;
  @override
  final String? lastName;
  @override
  final CustomerProfileDtoOutputProfileGenderEnum gender;
  @override
  final Date? birthday;

  factory _$CustomerProfileDtoOutputProfile([
    void Function(CustomerProfileDtoOutputProfileBuilder)? updates,
  ]) => (CustomerProfileDtoOutputProfileBuilder()..update(updates))._build();

  _$CustomerProfileDtoOutputProfile._({
    required this.firstName,
    this.lastName,
    required this.gender,
    this.birthday,
  }) : super._();
  @override
  CustomerProfileDtoOutputProfile rebuild(
    void Function(CustomerProfileDtoOutputProfileBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerProfileDtoOutputProfileBuilder toBuilder() =>
      CustomerProfileDtoOutputProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerProfileDtoOutputProfile &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        birthday == other.birthday;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, birthday.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerProfileDtoOutputProfile')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('gender', gender)
          ..add('birthday', birthday))
        .toString();
  }
}

class CustomerProfileDtoOutputProfileBuilder
    implements
        Builder<
          CustomerProfileDtoOutputProfile,
          CustomerProfileDtoOutputProfileBuilder
        > {
  _$CustomerProfileDtoOutputProfile? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  CustomerProfileDtoOutputProfileGenderEnum? _gender;
  CustomerProfileDtoOutputProfileGenderEnum? get gender => _$this._gender;
  set gender(CustomerProfileDtoOutputProfileGenderEnum? gender) =>
      _$this._gender = gender;

  Date? _birthday;
  Date? get birthday => _$this._birthday;
  set birthday(Date? birthday) => _$this._birthday = birthday;

  CustomerProfileDtoOutputProfileBuilder() {
    CustomerProfileDtoOutputProfile._defaults(this);
  }

  CustomerProfileDtoOutputProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _gender = $v.gender;
      _birthday = $v.birthday;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerProfileDtoOutputProfile other) {
    _$v = other as _$CustomerProfileDtoOutputProfile;
  }

  @override
  void update(void Function(CustomerProfileDtoOutputProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerProfileDtoOutputProfile build() => _build();

  _$CustomerProfileDtoOutputProfile _build() {
    final _$result =
        _$v ??
        _$CustomerProfileDtoOutputProfile._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'CustomerProfileDtoOutputProfile',
            'firstName',
          ),
          lastName: lastName,
          gender: BuiltValueNullFieldError.checkNotNull(
            gender,
            r'CustomerProfileDtoOutputProfile',
            'gender',
          ),
          birthday: birthday,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
