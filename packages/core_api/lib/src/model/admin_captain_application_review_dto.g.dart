// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_review_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainApplicationReviewDtoStatusEnum
_$adminCaptainApplicationReviewDtoStatusEnum_accepted =
    const AdminCaptainApplicationReviewDtoStatusEnum._('accepted');
const AdminCaptainApplicationReviewDtoStatusEnum
_$adminCaptainApplicationReviewDtoStatusEnum_rejected =
    const AdminCaptainApplicationReviewDtoStatusEnum._('rejected');

AdminCaptainApplicationReviewDtoStatusEnum
_$adminCaptainApplicationReviewDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'accepted':
      return _$adminCaptainApplicationReviewDtoStatusEnum_accepted;
    case 'rejected':
      return _$adminCaptainApplicationReviewDtoStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationReviewDtoStatusEnum>
_$adminCaptainApplicationReviewDtoStatusEnumValues =
    BuiltSet<AdminCaptainApplicationReviewDtoStatusEnum>(
      const <AdminCaptainApplicationReviewDtoStatusEnum>[
        _$adminCaptainApplicationReviewDtoStatusEnum_accepted,
        _$adminCaptainApplicationReviewDtoStatusEnum_rejected,
      ],
    );

Serializer<AdminCaptainApplicationReviewDtoStatusEnum>
_$adminCaptainApplicationReviewDtoStatusEnumSerializer =
    _$AdminCaptainApplicationReviewDtoStatusEnumSerializer();

class _$AdminCaptainApplicationReviewDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationReviewDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accepted': 'accepted',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'accepted': 'accepted',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainApplicationReviewDtoStatusEnum,
  ];
  @override
  final String wireName = 'AdminCaptainApplicationReviewDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationReviewDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationReviewDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationReviewDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationReviewDto
    extends AdminCaptainApplicationReviewDto {
  @override
  final AdminCaptainApplicationReviewDtoStatusEnum status;
  @override
  final String? reason;

  factory _$AdminCaptainApplicationReviewDto([
    void Function(AdminCaptainApplicationReviewDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationReviewDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationReviewDto._({required this.status, this.reason})
    : super._();
  @override
  AdminCaptainApplicationReviewDto rebuild(
    void Function(AdminCaptainApplicationReviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationReviewDtoBuilder toBuilder() =>
      AdminCaptainApplicationReviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationReviewDto &&
        status == other.status &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainApplicationReviewDto')
          ..add('status', status)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCaptainApplicationReviewDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationReviewDto,
          AdminCaptainApplicationReviewDtoBuilder
        > {
  _$AdminCaptainApplicationReviewDto? _$v;

  AdminCaptainApplicationReviewDtoStatusEnum? _status;
  AdminCaptainApplicationReviewDtoStatusEnum? get status => _$this._status;
  set status(AdminCaptainApplicationReviewDtoStatusEnum? status) =>
      _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainApplicationReviewDtoBuilder() {
    AdminCaptainApplicationReviewDto._defaults(this);
  }

  AdminCaptainApplicationReviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationReviewDto other) {
    _$v = other as _$AdminCaptainApplicationReviewDto;
  }

  @override
  void update(void Function(AdminCaptainApplicationReviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationReviewDto build() => _build();

  _$AdminCaptainApplicationReviewDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationReviewDto._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCaptainApplicationReviewDto',
            'status',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
