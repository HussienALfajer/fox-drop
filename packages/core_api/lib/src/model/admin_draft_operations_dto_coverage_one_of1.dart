//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_operations_dto_coverage_one_of1.g.dart';

/// AdminDraftOperationsDtoCoverageOneOf1
///
/// Properties:
/// * [kind]
/// * [zoneIds]
@BuiltValue()
abstract class AdminDraftOperationsDtoCoverageOneOf1
    implements
        Built<
          AdminDraftOperationsDtoCoverageOneOf1,
          AdminDraftOperationsDtoCoverageOneOf1Builder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminDraftOperationsDtoCoverageOneOf1KindEnum get kind;
  // enum kindEnum {  zones,  };

  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  AdminDraftOperationsDtoCoverageOneOf1._();

  factory AdminDraftOperationsDtoCoverageOneOf1([
    void updates(AdminDraftOperationsDtoCoverageOneOf1Builder b),
  ]) = _$AdminDraftOperationsDtoCoverageOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftOperationsDtoCoverageOneOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftOperationsDtoCoverageOneOf1> get serializer =>
      _$AdminDraftOperationsDtoCoverageOneOf1Serializer();
}

class _$AdminDraftOperationsDtoCoverageOneOf1Serializer
    implements PrimitiveSerializer<AdminDraftOperationsDtoCoverageOneOf1> {
  @override
  final Iterable<Type> types = const [
    AdminDraftOperationsDtoCoverageOneOf1,
    _$AdminDraftOperationsDtoCoverageOneOf1,
  ];

  @override
  final String wireName = r'AdminDraftOperationsDtoCoverageOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminDraftOperationsDtoCoverageOneOf1KindEnum,
      ),
    );
    yield r'zoneIds';
    yield serializers.serialize(
      object.zoneIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageOneOf1 object, {
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
    required AdminDraftOperationsDtoCoverageOneOf1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDraftOperationsDtoCoverageOneOf1KindEnum,
                    ),
                  )
                  as AdminDraftOperationsDtoCoverageOneOf1KindEnum;
          result.kind = valueDes;
          break;
        case r'zoneIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zoneIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftOperationsDtoCoverageOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftOperationsDtoCoverageOneOf1Builder();
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

class AdminDraftOperationsDtoCoverageOneOf1KindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'zones')
  static const AdminDraftOperationsDtoCoverageOneOf1KindEnum zones =
      _$adminDraftOperationsDtoCoverageOneOf1KindEnum_zones;

  static Serializer<AdminDraftOperationsDtoCoverageOneOf1KindEnum>
  get serializer => _$adminDraftOperationsDtoCoverageOneOf1KindEnumSerializer;

  const AdminDraftOperationsDtoCoverageOneOf1KindEnum._(String name)
    : super(name);

  static BuiltSet<AdminDraftOperationsDtoCoverageOneOf1KindEnum> get values =>
      _$adminDraftOperationsDtoCoverageOneOf1KindEnumValues;
  static AdminDraftOperationsDtoCoverageOneOf1KindEnum valueOf(String name) =>
      _$adminDraftOperationsDtoCoverageOneOf1KindEnumValueOf(name);
}
