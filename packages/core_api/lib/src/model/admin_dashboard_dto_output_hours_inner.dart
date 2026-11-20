//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_hours_inner.g.dart';

/// AdminDashboardDtoOutputHoursInner
///
/// Properties:
/// * [hour]
/// * [today]
/// * [lastWeek]
@BuiltValue()
abstract class AdminDashboardDtoOutputHoursInner
    implements
        Built<
          AdminDashboardDtoOutputHoursInner,
          AdminDashboardDtoOutputHoursInnerBuilder
        > {
  @BuiltValueField(wireName: r'hour')
  String get hour;

  @BuiltValueField(wireName: r'today')
  int get today;

  @BuiltValueField(wireName: r'lastWeek')
  int get lastWeek;

  AdminDashboardDtoOutputHoursInner._();

  factory AdminDashboardDtoOutputHoursInner([
    void updates(AdminDashboardDtoOutputHoursInnerBuilder b),
  ]) = _$AdminDashboardDtoOutputHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputHoursInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputHoursInner> get serializer =>
      _$AdminDashboardDtoOutputHoursInnerSerializer();
}

class _$AdminDashboardDtoOutputHoursInnerSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputHoursInner> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputHoursInner,
    _$AdminDashboardDtoOutputHoursInner,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputHoursInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'hour';
    yield serializers.serialize(
      object.hour,
      specifiedType: const FullType(String),
    );
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(int),
    );
    yield r'lastWeek';
    yield serializers.serialize(
      object.lastWeek,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputHoursInner object, {
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
    required AdminDashboardDtoOutputHoursInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hour':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.hour = valueDes;
          break;
        case r'today':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.today = valueDes;
          break;
        case r'lastWeek':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.lastWeek = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputHoursInnerBuilder();
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
