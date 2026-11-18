// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_home_sections_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHomeSectionsDtoOutput extends AdminHomeSectionsDtoOutput {
  @override
  final BuiltList<AdminHomeSectionsDtoOutputSectionsInner> sections;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> restaurants;
  @override
  final bool canManage;

  factory _$AdminHomeSectionsDtoOutput([
    void Function(AdminHomeSectionsDtoOutputBuilder)? updates,
  ]) => (AdminHomeSectionsDtoOutputBuilder()..update(updates))._build();

  _$AdminHomeSectionsDtoOutput._({
    required this.sections,
    required this.restaurants,
    required this.canManage,
  }) : super._();
  @override
  AdminHomeSectionsDtoOutput rebuild(
    void Function(AdminHomeSectionsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHomeSectionsDtoOutputBuilder toBuilder() =>
      AdminHomeSectionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHomeSectionsDtoOutput &&
        sections == other.sections &&
        restaurants == other.restaurants &&
        canManage == other.canManage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sections.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHomeSectionsDtoOutput')
          ..add('sections', sections)
          ..add('restaurants', restaurants)
          ..add('canManage', canManage))
        .toString();
  }
}

class AdminHomeSectionsDtoOutputBuilder
    implements
        Builder<AdminHomeSectionsDtoOutput, AdminHomeSectionsDtoOutputBuilder> {
  _$AdminHomeSectionsDtoOutput? _$v;

  ListBuilder<AdminHomeSectionsDtoOutputSectionsInner>? _sections;
  ListBuilder<AdminHomeSectionsDtoOutputSectionsInner> get sections =>
      _$this._sections ??=
          ListBuilder<AdminHomeSectionsDtoOutputSectionsInner>();
  set sections(
    ListBuilder<AdminHomeSectionsDtoOutputSectionsInner>? sections,
  ) => _$this._sections = sections;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? _restaurants;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>
  get restaurants => _$this._restaurants ??=
      ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>();
  set restaurants(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? restaurants,
  ) => _$this._restaurants = restaurants;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  AdminHomeSectionsDtoOutputBuilder() {
    AdminHomeSectionsDtoOutput._defaults(this);
  }

  AdminHomeSectionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sections = $v.sections.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _canManage = $v.canManage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHomeSectionsDtoOutput other) {
    _$v = other as _$AdminHomeSectionsDtoOutput;
  }

  @override
  void update(void Function(AdminHomeSectionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHomeSectionsDtoOutput build() => _build();

  _$AdminHomeSectionsDtoOutput _build() {
    _$AdminHomeSectionsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminHomeSectionsDtoOutput._(
            sections: sections.build(),
            restaurants: restaurants.build(),
            canManage: BuiltValueNullFieldError.checkNotNull(
              canManage,
              r'AdminHomeSectionsDtoOutput',
              'canManage',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sections';
        sections.build();
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminHomeSectionsDtoOutput',
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
