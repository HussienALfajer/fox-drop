// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_assignees_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketAssigneesDtoOutput extends AdminTicketAssigneesDtoOutput {
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> assignees;

  factory _$AdminTicketAssigneesDtoOutput([
    void Function(AdminTicketAssigneesDtoOutputBuilder)? updates,
  ]) => (AdminTicketAssigneesDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketAssigneesDtoOutput._({required this.assignees}) : super._();
  @override
  AdminTicketAssigneesDtoOutput rebuild(
    void Function(AdminTicketAssigneesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketAssigneesDtoOutputBuilder toBuilder() =>
      AdminTicketAssigneesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketAssigneesDtoOutput &&
        assignees == other.assignees;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assignees.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminTicketAssigneesDtoOutput',
    )..add('assignees', assignees)).toString();
  }
}

class AdminTicketAssigneesDtoOutputBuilder
    implements
        Builder<
          AdminTicketAssigneesDtoOutput,
          AdminTicketAssigneesDtoOutputBuilder
        > {
  _$AdminTicketAssigneesDtoOutput? _$v;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? _assignees;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get assignees =>
      _$this._assignees ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>();
  set assignees(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? assignees,
  ) => _$this._assignees = assignees;

  AdminTicketAssigneesDtoOutputBuilder() {
    AdminTicketAssigneesDtoOutput._defaults(this);
  }

  AdminTicketAssigneesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assignees = $v.assignees.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketAssigneesDtoOutput other) {
    _$v = other as _$AdminTicketAssigneesDtoOutput;
  }

  @override
  void update(void Function(AdminTicketAssigneesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketAssigneesDtoOutput build() => _build();

  _$AdminTicketAssigneesDtoOutput _build() {
    _$AdminTicketAssigneesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketAssigneesDtoOutput._(assignees: assignees.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'assignees';
        assignees.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketAssigneesDtoOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
