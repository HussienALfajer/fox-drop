// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_board_dto_output_orders_inner_badges.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBoardDtoOutputOrdersInnerBadges
    extends AdminBoardDtoOutputOrdersInnerBadges {
  @override
  final bool needsAssignment;
  @override
  final bool note;
  @override
  final bool newCustomer;

  factory _$AdminBoardDtoOutputOrdersInnerBadges([
    void Function(AdminBoardDtoOutputOrdersInnerBadgesBuilder)? updates,
  ]) =>
      (AdminBoardDtoOutputOrdersInnerBadgesBuilder()..update(updates))._build();

  _$AdminBoardDtoOutputOrdersInnerBadges._({
    required this.needsAssignment,
    required this.note,
    required this.newCustomer,
  }) : super._();
  @override
  AdminBoardDtoOutputOrdersInnerBadges rebuild(
    void Function(AdminBoardDtoOutputOrdersInnerBadgesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBoardDtoOutputOrdersInnerBadgesBuilder toBuilder() =>
      AdminBoardDtoOutputOrdersInnerBadgesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBoardDtoOutputOrdersInnerBadges &&
        needsAssignment == other.needsAssignment &&
        note == other.note &&
        newCustomer == other.newCustomer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, needsAssignment.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, newCustomer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBoardDtoOutputOrdersInnerBadges')
          ..add('needsAssignment', needsAssignment)
          ..add('note', note)
          ..add('newCustomer', newCustomer))
        .toString();
  }
}

class AdminBoardDtoOutputOrdersInnerBadgesBuilder
    implements
        Builder<
          AdminBoardDtoOutputOrdersInnerBadges,
          AdminBoardDtoOutputOrdersInnerBadgesBuilder
        > {
  _$AdminBoardDtoOutputOrdersInnerBadges? _$v;

  bool? _needsAssignment;
  bool? get needsAssignment => _$this._needsAssignment;
  set needsAssignment(bool? needsAssignment) =>
      _$this._needsAssignment = needsAssignment;

  bool? _note;
  bool? get note => _$this._note;
  set note(bool? note) => _$this._note = note;

  bool? _newCustomer;
  bool? get newCustomer => _$this._newCustomer;
  set newCustomer(bool? newCustomer) => _$this._newCustomer = newCustomer;

  AdminBoardDtoOutputOrdersInnerBadgesBuilder() {
    AdminBoardDtoOutputOrdersInnerBadges._defaults(this);
  }

  AdminBoardDtoOutputOrdersInnerBadgesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _needsAssignment = $v.needsAssignment;
      _note = $v.note;
      _newCustomer = $v.newCustomer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBoardDtoOutputOrdersInnerBadges other) {
    _$v = other as _$AdminBoardDtoOutputOrdersInnerBadges;
  }

  @override
  void update(
    void Function(AdminBoardDtoOutputOrdersInnerBadgesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBoardDtoOutputOrdersInnerBadges build() => _build();

  _$AdminBoardDtoOutputOrdersInnerBadges _build() {
    final _$result =
        _$v ??
        _$AdminBoardDtoOutputOrdersInnerBadges._(
          needsAssignment: BuiltValueNullFieldError.checkNotNull(
            needsAssignment,
            r'AdminBoardDtoOutputOrdersInnerBadges',
            'needsAssignment',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminBoardDtoOutputOrdersInnerBadges',
            'note',
          ),
          newCustomer: BuiltValueNullFieldError.checkNotNull(
            newCustomer,
            r'AdminBoardDtoOutputOrdersInnerBadges',
            'newCustomer',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
