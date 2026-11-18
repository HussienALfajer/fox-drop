//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_operations_dto_periods_inner.g.dart';

/// AdminDraftOperationsDtoPeriodsInner
///
/// Properties:
/// * [weekday] - 0 is Sunday, 6 Saturday.
/// * [opensAt] - Minutes after midnight on the city's clock.
/// * [closesAt] - Not after the opening: the period crosses midnight (00:00 to 00:00 is all day).
@BuiltValue()
abstract class AdminDraftOperationsDtoPeriodsInner
    implements
        Built<
          AdminDraftOperationsDtoPeriodsInner,
          AdminDraftOperationsDtoPeriodsInnerBuilder
        > {
  /// 0 is Sunday, 6 Saturday.
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  /// Minutes after midnight on the city's clock.
  @BuiltValueField(wireName: r'opensAt')
  int get opensAt;

  /// Not after the opening: the period crosses midnight (00:00 to 00:00 is all day).
  @BuiltValueField(wireName: r'closesAt')
  int get closesAt;

  AdminDraftOperationsDtoPeriodsInner._();

  factory AdminDraftOperationsDtoPeriodsInner([
    void updates(AdminDraftOperationsDtoPeriodsInnerBuilder b),
  ]) = _$AdminDraftOperationsDtoPeriodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftOperationsDtoPeriodsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftOperationsDtoPeriodsInner> get serializer =>
      _$AdminDraftOperationsDtoPeriodsInnerSerializer();
}

class _$AdminDraftOperationsDtoPeriodsInnerSerializer
    implements PrimitiveSerializer<AdminDraftOperationsDtoPeriodsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDraftOperationsDtoPeriodsInner,
    _$AdminDraftOperationsDtoPeriodsInner,
  ];

  @override
  final String wireName = r'AdminDraftOperationsDtoPeriodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftOperationsDtoPeriodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    yield r'opensAt';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(int),
    );
    yield r'closesAt';
    yield serializers.serialize(
      object.closesAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoPeriodsInner object, {
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
    required AdminDraftOperationsDtoPeriodsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.weekday = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftOperationsDtoPeriodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftOperationsDtoPeriodsInnerBuilder();
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
