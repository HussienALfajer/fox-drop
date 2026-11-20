//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_export_dto_output.g.dart';

/// MerchantExportDtoOutput
///
/// Properties:
/// * [id]
/// * [kind]
/// * [status]
/// * [fileName]
/// * [createdAt]
/// * [expiresAt] - Until when it can be downloaded.
/// * [url] - Asked with download=true while ready: a signed download on the portal’s origin, valid 5 minutes.
@BuiltValue()
abstract class MerchantExportDtoOutput
    implements Built<MerchantExportDtoOutput, MerchantExportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  MerchantExportDtoOutputKindEnum get kind;
  // enum kindEnum {  merchant_report,  merchant_order_history,  merchant_statement,  };

  @BuiltValueField(wireName: r'status')
  MerchantExportDtoOutputStatusEnum get status;
  // enum statusEnum {  pending,  ready,  expired,  };

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Until when it can be downloaded.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  /// Asked with download=true while ready: a signed download on the portal’s origin, valid 5 minutes.
  @BuiltValueField(wireName: r'url')
  String? get url;

  MerchantExportDtoOutput._();

  factory MerchantExportDtoOutput([
    void updates(MerchantExportDtoOutputBuilder b),
  ]) = _$MerchantExportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantExportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantExportDtoOutput> get serializer =>
      _$MerchantExportDtoOutputSerializer();
}

class _$MerchantExportDtoOutputSerializer
    implements PrimitiveSerializer<MerchantExportDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantExportDtoOutput,
    _$MerchantExportDtoOutput,
  ];

  @override
  final String wireName = r'MerchantExportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantExportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(MerchantExportDtoOutputKindEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MerchantExportDtoOutputStatusEnum),
    );
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield object.expiresAt == null
        ? null
        : serializers.serialize(
            object.expiresAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'url';
    yield object.url == null
        ? null
        : serializers.serialize(
            object.url,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantExportDtoOutput object, {
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
    required MerchantExportDtoOutputBuilder result,
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantExportDtoOutputKindEnum,
                    ),
                  )
                  as MerchantExportDtoOutputKindEnum;
          result.kind = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantExportDtoOutputStatusEnum,
                    ),
                  )
                  as MerchantExportDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'fileName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fileName = valueDes;
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
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'url':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantExportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantExportDtoOutputBuilder();
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

class MerchantExportDtoOutputKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant_report')
  static const MerchantExportDtoOutputKindEnum merchantReport =
      _$merchantExportDtoOutputKindEnum_merchantReport;
  @BuiltValueEnumConst(wireName: r'merchant_order_history')
  static const MerchantExportDtoOutputKindEnum merchantOrderHistory =
      _$merchantExportDtoOutputKindEnum_merchantOrderHistory;
  @BuiltValueEnumConst(wireName: r'merchant_statement')
  static const MerchantExportDtoOutputKindEnum merchantStatement =
      _$merchantExportDtoOutputKindEnum_merchantStatement;

  static Serializer<MerchantExportDtoOutputKindEnum> get serializer =>
      _$merchantExportDtoOutputKindEnumSerializer;

  const MerchantExportDtoOutputKindEnum._(String name) : super(name);

  static BuiltSet<MerchantExportDtoOutputKindEnum> get values =>
      _$merchantExportDtoOutputKindEnumValues;
  static MerchantExportDtoOutputKindEnum valueOf(String name) =>
      _$merchantExportDtoOutputKindEnumValueOf(name);
}

class MerchantExportDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const MerchantExportDtoOutputStatusEnum pending =
      _$merchantExportDtoOutputStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'ready')
  static const MerchantExportDtoOutputStatusEnum ready =
      _$merchantExportDtoOutputStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'expired')
  static const MerchantExportDtoOutputStatusEnum expired =
      _$merchantExportDtoOutputStatusEnum_expired;

  static Serializer<MerchantExportDtoOutputStatusEnum> get serializer =>
      _$merchantExportDtoOutputStatusEnumSerializer;

  const MerchantExportDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<MerchantExportDtoOutputStatusEnum> get values =>
      _$merchantExportDtoOutputStatusEnumValues;
  static MerchantExportDtoOutputStatusEnum valueOf(String name) =>
      _$merchantExportDtoOutputStatusEnumValueOf(name);
}
