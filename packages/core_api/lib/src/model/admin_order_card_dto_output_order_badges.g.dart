// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output_order_badges.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCardDtoOutputOrderBadges
    extends AdminOrderCardDtoOutputOrderBadges {
  @override
  final bool needsAssignment;
  @override
  final bool note;
  @override
  final bool newCustomer;
  @override
  final bool pickupPending;
  @override
  final bool awaitingCollection;
  @override
  final bool itemReport;
  @override
  final bool cannotComplete;
  @override
  final bool emergency;

  factory _$AdminOrderCardDtoOutputOrderBadges([
    void Function(AdminOrderCardDtoOutputOrderBadgesBuilder)? updates,
  ]) => (AdminOrderCardDtoOutputOrderBadgesBuilder()..update(updates))._build();

  _$AdminOrderCardDtoOutputOrderBadges._({
    required this.needsAssignment,
    required this.note,
    required this.newCustomer,
    required this.pickupPending,
    required this.awaitingCollection,
    required this.itemReport,
    required this.cannotComplete,
    required this.emergency,
  }) : super._();
  @override
  AdminOrderCardDtoOutputOrderBadges rebuild(
    void Function(AdminOrderCardDtoOutputOrderBadgesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputOrderBadgesBuilder toBuilder() =>
      AdminOrderCardDtoOutputOrderBadgesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutputOrderBadges &&
        needsAssignment == other.needsAssignment &&
        note == other.note &&
        newCustomer == other.newCustomer &&
        pickupPending == other.pickupPending &&
        awaitingCollection == other.awaitingCollection &&
        itemReport == other.itemReport &&
        cannotComplete == other.cannotComplete &&
        emergency == other.emergency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, needsAssignment.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, newCustomer.hashCode);
    _$hash = $jc(_$hash, pickupPending.hashCode);
    _$hash = $jc(_$hash, awaitingCollection.hashCode);
    _$hash = $jc(_$hash, itemReport.hashCode);
    _$hash = $jc(_$hash, cannotComplete.hashCode);
    _$hash = $jc(_$hash, emergency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderCardDtoOutputOrderBadges')
          ..add('needsAssignment', needsAssignment)
          ..add('note', note)
          ..add('newCustomer', newCustomer)
          ..add('pickupPending', pickupPending)
          ..add('awaitingCollection', awaitingCollection)
          ..add('itemReport', itemReport)
          ..add('cannotComplete', cannotComplete)
          ..add('emergency', emergency))
        .toString();
  }
}

class AdminOrderCardDtoOutputOrderBadgesBuilder
    implements
        Builder<
          AdminOrderCardDtoOutputOrderBadges,
          AdminOrderCardDtoOutputOrderBadgesBuilder
        > {
  _$AdminOrderCardDtoOutputOrderBadges? _$v;

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

  bool? _pickupPending;
  bool? get pickupPending => _$this._pickupPending;
  set pickupPending(bool? pickupPending) =>
      _$this._pickupPending = pickupPending;

  bool? _awaitingCollection;
  bool? get awaitingCollection => _$this._awaitingCollection;
  set awaitingCollection(bool? awaitingCollection) =>
      _$this._awaitingCollection = awaitingCollection;

  bool? _itemReport;
  bool? get itemReport => _$this._itemReport;
  set itemReport(bool? itemReport) => _$this._itemReport = itemReport;

  bool? _cannotComplete;
  bool? get cannotComplete => _$this._cannotComplete;
  set cannotComplete(bool? cannotComplete) =>
      _$this._cannotComplete = cannotComplete;

  bool? _emergency;
  bool? get emergency => _$this._emergency;
  set emergency(bool? emergency) => _$this._emergency = emergency;

  AdminOrderCardDtoOutputOrderBadgesBuilder() {
    AdminOrderCardDtoOutputOrderBadges._defaults(this);
  }

  AdminOrderCardDtoOutputOrderBadgesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _needsAssignment = $v.needsAssignment;
      _note = $v.note;
      _newCustomer = $v.newCustomer;
      _pickupPending = $v.pickupPending;
      _awaitingCollection = $v.awaitingCollection;
      _itemReport = $v.itemReport;
      _cannotComplete = $v.cannotComplete;
      _emergency = $v.emergency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutputOrderBadges other) {
    _$v = other as _$AdminOrderCardDtoOutputOrderBadges;
  }

  @override
  void update(
    void Function(AdminOrderCardDtoOutputOrderBadgesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutputOrderBadges build() => _build();

  _$AdminOrderCardDtoOutputOrderBadges _build() {
    final _$result =
        _$v ??
        _$AdminOrderCardDtoOutputOrderBadges._(
          needsAssignment: BuiltValueNullFieldError.checkNotNull(
            needsAssignment,
            r'AdminOrderCardDtoOutputOrderBadges',
            'needsAssignment',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminOrderCardDtoOutputOrderBadges',
            'note',
          ),
          newCustomer: BuiltValueNullFieldError.checkNotNull(
            newCustomer,
            r'AdminOrderCardDtoOutputOrderBadges',
            'newCustomer',
          ),
          pickupPending: BuiltValueNullFieldError.checkNotNull(
            pickupPending,
            r'AdminOrderCardDtoOutputOrderBadges',
            'pickupPending',
          ),
          awaitingCollection: BuiltValueNullFieldError.checkNotNull(
            awaitingCollection,
            r'AdminOrderCardDtoOutputOrderBadges',
            'awaitingCollection',
          ),
          itemReport: BuiltValueNullFieldError.checkNotNull(
            itemReport,
            r'AdminOrderCardDtoOutputOrderBadges',
            'itemReport',
          ),
          cannotComplete: BuiltValueNullFieldError.checkNotNull(
            cannotComplete,
            r'AdminOrderCardDtoOutputOrderBadges',
            'cannotComplete',
          ),
          emergency: BuiltValueNullFieldError.checkNotNull(
            emergency,
            r'AdminOrderCardDtoOutputOrderBadges',
            'emergency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
