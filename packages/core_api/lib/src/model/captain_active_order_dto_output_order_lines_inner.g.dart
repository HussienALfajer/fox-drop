// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderLinesInner
    extends CaptainActiveOrderDtoOutputOrderLinesInner {
  @override
  final String name;
  @override
  final int quantity;
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>
  options;
  @override
  final String? note;

  factory _$CaptainActiveOrderDtoOutputOrderLinesInner([
    void Function(CaptainActiveOrderDtoOutputOrderLinesInnerBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderLinesInnerBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderLinesInner._({
    required this.name,
    required this.quantity,
    required this.options,
    this.note,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderLinesInner rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderLinesInnerBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderLinesInner &&
        name == other.name &&
        quantity == other.quantity &&
        options == other.options &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderLinesInner',
          )
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('options', options)
          ..add('note', note))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderLinesInnerBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderLinesInner,
          CaptainActiveOrderDtoOutputOrderLinesInnerBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderLinesInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>?
  _options;
  ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>
  get options => _$this._options ??=
      ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>();
  set options(
    ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>?
    options,
  ) => _$this._options = options;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CaptainActiveOrderDtoOutputOrderLinesInnerBuilder() {
    CaptainActiveOrderDtoOutputOrderLinesInner._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _quantity = $v.quantity;
      _options = $v.options.toBuilder();
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderLinesInner other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderLinesInner;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderLinesInner build() => _build();

  _$CaptainActiveOrderDtoOutputOrderLinesInner _build() {
    _$CaptainActiveOrderDtoOutputOrderLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderLinesInner._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CaptainActiveOrderDtoOutputOrderLinesInner',
              'name',
            ),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'CaptainActiveOrderDtoOutputOrderLinesInner',
              'quantity',
            ),
            options: options.build(),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderLinesInner',
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
