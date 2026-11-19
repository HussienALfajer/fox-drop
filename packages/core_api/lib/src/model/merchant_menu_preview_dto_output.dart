//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_preview_dto_output_menu_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_preview_dto_output.g.dart';

/// MerchantMenuPreviewDtoOutput
///
/// Properties:
/// * [menu] - The restaurant page's menu (CU §9.3): hidden rows left out.
@BuiltValue()
abstract class MerchantMenuPreviewDtoOutput
    implements
        Built<
          MerchantMenuPreviewDtoOutput,
          MerchantMenuPreviewDtoOutputBuilder
        > {
  /// The restaurant page's menu (CU §9.3): hidden rows left out.
  @BuiltValueField(wireName: r'menu')
  BuiltList<AdminMenuPreviewDtoOutputMenuInner> get menu;

  MerchantMenuPreviewDtoOutput._();

  factory MerchantMenuPreviewDtoOutput([
    void updates(MerchantMenuPreviewDtoOutputBuilder b),
  ]) = _$MerchantMenuPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuPreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuPreviewDtoOutput> get serializer =>
      _$MerchantMenuPreviewDtoOutputSerializer();
}

class _$MerchantMenuPreviewDtoOutputSerializer
    implements PrimitiveSerializer<MerchantMenuPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuPreviewDtoOutput,
    _$MerchantMenuPreviewDtoOutput,
  ];

  @override
  final String wireName = r'MerchantMenuPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuPreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'menu';
    yield serializers.serialize(
      object.menu,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuPreviewDtoOutputMenuInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuPreviewDtoOutput object, {
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
    required MerchantMenuPreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'menu':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuPreviewDtoOutputMenuInner),
                    ]),
                  )
                  as BuiltList<AdminMenuPreviewDtoOutputMenuInner>;
          result.menu.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuPreviewDtoOutputBuilder();
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
