//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_current_drawer_session_dto_output_session_currencies_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_drawer_sessions_dto_output_sessions_inner.g.dart';

/// AdminDrawerSessionsDtoOutputSessionsInner
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [adminAccountId]
/// * [adminName]
/// * [kind]
/// * [openedAt]
/// * [closedAt]
/// * [closeNote]
/// * [currencies]
@BuiltValue()
abstract class AdminDrawerSessionsDtoOutputSessionsInner
    implements
        Built<
          AdminDrawerSessionsDtoOutputSessionsInner,
          AdminDrawerSessionsDtoOutputSessionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'adminAccountId')
  String get adminAccountId;

  @BuiltValueField(wireName: r'adminName')
  String? get adminName;

  @BuiltValueField(wireName: r'kind')
  AdminDrawerSessionsDtoOutputSessionsInnerKindEnum get kind;
  // enum kindEnum {  office,  };

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closeNote')
  String? get closeNote;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>
  get currencies;

  AdminDrawerSessionsDtoOutputSessionsInner._();

  factory AdminDrawerSessionsDtoOutputSessionsInner([
    void updates(AdminDrawerSessionsDtoOutputSessionsInnerBuilder b),
  ]) = _$AdminDrawerSessionsDtoOutputSessionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDrawerSessionsDtoOutputSessionsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDrawerSessionsDtoOutputSessionsInner> get serializer =>
      _$AdminDrawerSessionsDtoOutputSessionsInnerSerializer();
}

class _$AdminDrawerSessionsDtoOutputSessionsInnerSerializer
    implements PrimitiveSerializer<AdminDrawerSessionsDtoOutputSessionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDrawerSessionsDtoOutputSessionsInner,
    _$AdminDrawerSessionsDtoOutputSessionsInner,
  ];

  @override
  final String wireName = r'AdminDrawerSessionsDtoOutputSessionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDrawerSessionsDtoOutputSessionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'adminAccountId';
    yield serializers.serialize(
      object.adminAccountId,
      specifiedType: const FullType(String),
    );
    yield r'adminName';
    yield object.adminName == null
        ? null
        : serializers.serialize(
            object.adminName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminDrawerSessionsDtoOutputSessionsInnerKindEnum,
      ),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closedAt';
    yield object.closedAt == null
        ? null
        : serializers.serialize(
            object.closedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'closeNote';
    yield object.closeNote == null
        ? null
        : serializers.serialize(
            object.closeNote,
            specifiedType: const FullType.nullable(String),
          );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDrawerSessionsDtoOutputSessionsInner object, {
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
    required AdminDrawerSessionsDtoOutputSessionsInnerBuilder result,
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
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'adminAccountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adminAccountId = valueDes;
          break;
        case r'adminName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.adminName = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDrawerSessionsDtoOutputSessionsInnerKindEnum,
                    ),
                  )
                  as AdminDrawerSessionsDtoOutputSessionsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        case r'closedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'closeNote':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.closeNote = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner
                  >;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDrawerSessionsDtoOutputSessionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDrawerSessionsDtoOutputSessionsInnerBuilder();
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

class AdminDrawerSessionsDtoOutputSessionsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'office')
  static const AdminDrawerSessionsDtoOutputSessionsInnerKindEnum office =
      _$adminDrawerSessionsDtoOutputSessionsInnerKindEnum_office;

  static Serializer<AdminDrawerSessionsDtoOutputSessionsInnerKindEnum>
  get serializer =>
      _$adminDrawerSessionsDtoOutputSessionsInnerKindEnumSerializer;

  const AdminDrawerSessionsDtoOutputSessionsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminDrawerSessionsDtoOutputSessionsInnerKindEnum>
  get values => _$adminDrawerSessionsDtoOutputSessionsInnerKindEnumValues;
  static AdminDrawerSessionsDtoOutputSessionsInnerKindEnum valueOf(
    String name,
  ) => _$adminDrawerSessionsDtoOutputSessionsInnerKindEnumValueOf(name);
}
