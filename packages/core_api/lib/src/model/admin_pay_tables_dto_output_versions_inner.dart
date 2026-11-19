//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_pay_tables_dto_output_versions_inner_rates_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_tables_dto_output_versions_inner.g.dart';

/// AdminPayTablesDtoOutputVersionsInner
///
/// Properties:
/// * [id]
/// * [state] - in_force; announced: starts later; replaced: a later version with the same start took its place; ended.
/// * [currency]
/// * [effectiveFrom]
/// * [rates] - One per vehicle, in the catalogue order.
/// * [editorName] - Null for the system or an unknown admin.
/// * [reason]
/// * [createdAt]
@BuiltValue()
abstract class AdminPayTablesDtoOutputVersionsInner
    implements
        Built<
          AdminPayTablesDtoOutputVersionsInner,
          AdminPayTablesDtoOutputVersionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// in_force; announced: starts later; replaced: a later version with the same start took its place; ended.
  @BuiltValueField(wireName: r'state')
  AdminPayTablesDtoOutputVersionsInnerStateEnum get state;
  // enum stateEnum {  in_force,  announced,  replaced,  ended,  };

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  /// One per vehicle, in the catalogue order.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminPayTablesDtoOutputVersionsInnerRatesInner> get rates;

  /// Null for the system or an unknown admin.
  @BuiltValueField(wireName: r'editorName')
  String? get editorName;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminPayTablesDtoOutputVersionsInner._();

  factory AdminPayTablesDtoOutputVersionsInner([
    void updates(AdminPayTablesDtoOutputVersionsInnerBuilder b),
  ]) = _$AdminPayTablesDtoOutputVersionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablesDtoOutputVersionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablesDtoOutputVersionsInner> get serializer =>
      _$AdminPayTablesDtoOutputVersionsInnerSerializer();
}

class _$AdminPayTablesDtoOutputVersionsInnerSerializer
    implements PrimitiveSerializer<AdminPayTablesDtoOutputVersionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablesDtoOutputVersionsInner,
    _$AdminPayTablesDtoOutputVersionsInner,
  ];

  @override
  final String wireName = r'AdminPayTablesDtoOutputVersionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablesDtoOutputVersionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        AdminPayTablesDtoOutputVersionsInnerStateEnum,
      ),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'rates';
    yield serializers.serialize(
      object.rates,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPayTablesDtoOutputVersionsInnerRatesInner),
      ]),
    );
    yield r'editorName';
    yield object.editorName == null
        ? null
        : serializers.serialize(
            object.editorName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutputVersionsInner object, {
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
    required AdminPayTablesDtoOutputVersionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablesDtoOutputVersionsInnerStateEnum,
                    ),
                  )
                  as AdminPayTablesDtoOutputVersionsInnerStateEnum;
          result.state = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'rates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPayTablesDtoOutputVersionsInnerRatesInner),
                    ]),
                  )
                  as BuiltList<AdminPayTablesDtoOutputVersionsInnerRatesInner>;
          result.rates.replace(valueDes);
          break;
        case r'editorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.editorName = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablesDtoOutputVersionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablesDtoOutputVersionsInnerBuilder();
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

/// in_force; announced: starts later; replaced: a later version with the same start took its place; ended.
class AdminPayTablesDtoOutputVersionsInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'in_force')
  static const AdminPayTablesDtoOutputVersionsInnerStateEnum inForce =
      _$adminPayTablesDtoOutputVersionsInnerStateEnum_inForce;
  @BuiltValueEnumConst(wireName: r'announced')
  static const AdminPayTablesDtoOutputVersionsInnerStateEnum announced =
      _$adminPayTablesDtoOutputVersionsInnerStateEnum_announced;
  @BuiltValueEnumConst(wireName: r'replaced')
  static const AdminPayTablesDtoOutputVersionsInnerStateEnum replaced =
      _$adminPayTablesDtoOutputVersionsInnerStateEnum_replaced;
  @BuiltValueEnumConst(wireName: r'ended')
  static const AdminPayTablesDtoOutputVersionsInnerStateEnum ended =
      _$adminPayTablesDtoOutputVersionsInnerStateEnum_ended;

  static Serializer<AdminPayTablesDtoOutputVersionsInnerStateEnum>
  get serializer => _$adminPayTablesDtoOutputVersionsInnerStateEnumSerializer;

  const AdminPayTablesDtoOutputVersionsInnerStateEnum._(String name)
    : super(name);

  static BuiltSet<AdminPayTablesDtoOutputVersionsInnerStateEnum> get values =>
      _$adminPayTablesDtoOutputVersionsInnerStateEnumValues;
  static AdminPayTablesDtoOutputVersionsInnerStateEnum valueOf(String name) =>
      _$adminPayTablesDtoOutputVersionsInnerStateEnumValueOf(name);
}
