// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_timeline_inner_actor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderTimelineInnerActor
    extends AdminOrderDtoOutputOrderTimelineInnerActor {
  @override
  final String type;
  @override
  final String? id;

  factory _$AdminOrderDtoOutputOrderTimelineInnerActor([
    void Function(AdminOrderDtoOutputOrderTimelineInnerActorBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderTimelineInnerActorBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderTimelineInnerActor._({required this.type, this.id})
    : super._();
  @override
  AdminOrderDtoOutputOrderTimelineInnerActor rebuild(
    void Function(AdminOrderDtoOutputOrderTimelineInnerActorBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderTimelineInnerActorBuilder toBuilder() =>
      AdminOrderDtoOutputOrderTimelineInnerActorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderTimelineInnerActor &&
        type == other.type &&
        id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderTimelineInnerActor',
          )
          ..add('type', type)
          ..add('id', id))
        .toString();
  }
}

class AdminOrderDtoOutputOrderTimelineInnerActorBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderTimelineInnerActor,
          AdminOrderDtoOutputOrderTimelineInnerActorBuilder
        > {
  _$AdminOrderDtoOutputOrderTimelineInnerActor? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminOrderDtoOutputOrderTimelineInnerActorBuilder() {
    AdminOrderDtoOutputOrderTimelineInnerActor._defaults(this);
  }

  AdminOrderDtoOutputOrderTimelineInnerActorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderTimelineInnerActor other) {
    _$v = other as _$AdminOrderDtoOutputOrderTimelineInnerActor;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderTimelineInnerActorBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderTimelineInnerActor build() => _build();

  _$AdminOrderDtoOutputOrderTimelineInnerActor _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderTimelineInnerActor._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'AdminOrderDtoOutputOrderTimelineInnerActor',
            'type',
          ),
          id: id,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
