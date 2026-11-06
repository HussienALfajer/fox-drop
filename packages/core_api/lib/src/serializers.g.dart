// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(AdminSessionDtoOutput.serializer)
          ..add(BackupCodesDtoOutput.serializer)
          ..add(CaptainAvailabilityDtoOutput.serializer)
          ..add(CaptainAvailabilityDtoOutputAvailability.serializer)
          ..add(CaptainAvailabilityDtoOutputAvailabilityReasonsEnum.serializer)
          ..add(CaptainAvailabilityDtoOutputAvailabilityStateEnum.serializer)
          ..add(CaptainAvailabilityDtoOutputCustody.serializer)
          ..add(CaptainAvailabilityDtoOutputCustodyClosedDue.serializer)
          ..add(CaptainAvailabilityDtoOutputCustodyLimit.serializer)
          ..add(CaptainAvailabilityDtoOutputCustodyUsage.serializer)
          ..add(CaptainCodeRequestDto.serializer)
          ..add(CaptainCodeSentDtoOutput.serializer)
          ..add(CaptainCodeSentDtoOutputChannelEnum.serializer)
          ..add(CaptainGoOnlineDto.serializer)
          ..add(CaptainLocationsDto.serializer)
          ..add(CaptainLocationsDtoPointsInner.serializer)
          ..add(CaptainLocationsSavedDtoOutput.serializer)
          ..add(CaptainRefreshDto.serializer)
          ..add(CaptainSessionDtoOutput.serializer)
          ..add(CaptainSignInDto.serializer)
          ..add(CaptainSignedInDtoOutput.serializer)
          ..add(CaptainSignedOutDtoOutput.serializer)
          ..add(CaptainSignedOutDtoOutputStatusEnum.serializer)
          ..add(CaptainTokensDtoOutput.serializer)
          ..add(CaptainWentOfflineDtoOutput.serializer)
          ..add(CaptainWentOfflineDtoOutputHandIn.serializer)
          ..add(ChangeRolesDto.serializer)
          ..add(ChangeRolesDtoRolesEnum.serializer)
          ..add(CompleteSetupDto.serializer)
          ..add(CreateUserDto.serializer)
          ..add(CreateUserDtoRolesEnum.serializer)
          ..add(CustomerCodeRequestDto.serializer)
          ..add(CustomerCodeSentDtoOutput.serializer)
          ..add(CustomerCodeSentDtoOutputChannelEnum.serializer)
          ..add(CustomerRefreshDto.serializer)
          ..add(CustomerSessionDtoOutput.serializer)
          ..add(CustomerSignInDto.serializer)
          ..add(CustomerSignedInDtoOutput.serializer)
          ..add(CustomerSignedOutDtoOutput.serializer)
          ..add(CustomerSignedOutDtoOutputStatusEnum.serializer)
          ..add(CustomerTokensDtoOutput.serializer)
          ..add(DoneDtoOutput.serializer)
          ..add(DoneDtoOutputStatusEnum.serializer)
          ..add(MerchantAvailabilityDto.serializer)
          ..add(MerchantAvailabilityDtoTypeEnum.serializer)
          ..add(MerchantAvailabilityDtoUntilEnum.serializer)
          ..add(MerchantAvailabilitySavedDtoOutput.serializer)
          ..add(MerchantCodeRequestDto.serializer)
          ..add(MerchantCodeSentDtoOutput.serializer)
          ..add(MerchantCodeSentDtoOutputChannelEnum.serializer)
          ..add(MerchantDeviceDto.serializer)
          ..add(MerchantDeviceDtoPlatformEnum.serializer)
          ..add(MerchantDeviceSavedDtoOutput.serializer)
          ..add(MerchantDeviceSavedDtoOutputStatusEnum.serializer)
          ..add(MerchantMenuDtoOutput.serializer)
          ..add(MerchantMenuDtoOutputCategoriesInner.serializer)
          ..add(MerchantMenuDtoOutputCategoriesInnerItemsInner.serializer)
          ..add(
            MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
                .serializer,
          )
          ..add(
            MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
                .serializer,
          )
          ..add(MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice.serializer)
          ..add(MerchantMenuDtoOutputCategoriesInnerSwitchedOff.serializer)
          ..add(MerchantRefreshDto.serializer)
          ..add(MerchantRestaurantDtoOutput.serializer)
          ..add(MerchantRestaurantDtoOutputAccountStatusEnum.serializer)
          ..add(MerchantRestaurantDtoOutputStateEnum.serializer)
          ..add(MerchantSessionDtoOutput.serializer)
          ..add(MerchantSessionDtoOutputRoleEnum.serializer)
          ..add(MerchantSignInDto.serializer)
          ..add(MerchantSignedInDtoOutput.serializer)
          ..add(MerchantSignedInDtoOutputRoleEnum.serializer)
          ..add(MerchantSignedOutDtoOutput.serializer)
          ..add(MerchantSignedOutDtoOutputStatusEnum.serializer)
          ..add(MerchantTokensDtoOutput.serializer)
          ..add(ResetSettingDto.serializer)
          ..add(RoleMatrixDtoOutput.serializer)
          ..add(RoleMatrixDtoOutputRolesInner.serializer)
          ..add(SettingEntryDtoOutput.serializer)
          ..add(SettingEntryDtoOutputEditRolesEnum.serializer)
          ..add(SettingEntryDtoOutputGroupEnum.serializer)
          ..add(SettingEntryDtoOutputScopeEnum.serializer)
          ..add(SettingHistoryDtoOutput.serializer)
          ..add(SettingHistoryDtoOutputChangesInner.serializer)
          ..add(SettingHistoryDtoOutputChangesInnerActionEnum.serializer)
          ..add(SettingListDtoOutput.serializer)
          ..add(SettingListDtoOutputSettingsInner.serializer)
          ..add(SettingListDtoOutputSettingsInnerEditRolesEnum.serializer)
          ..add(SettingListDtoOutputSettingsInnerGroupEnum.serializer)
          ..add(SettingListDtoOutputSettingsInnerScopeEnum.serializer)
          ..add(SetupLinkDtoOutput.serializer)
          ..add(SetupTokenDto.serializer)
          ..add(SignInDto.serializer)
          ..add(SignedOutDtoOutput.serializer)
          ..add(SignedOutDtoOutputStatusEnum.serializer)
          ..add(StatusDtoOutput.serializer)
          ..add(StatusDtoOutputStatusEnum.serializer)
          ..add(TeamUsersDtoOutput.serializer)
          ..add(TeamUsersDtoOutputUsersInner.serializer)
          ..add(TeamUsersDtoOutputUsersInnerOpenSessionsInner.serializer)
          ..add(TeamUsersDtoOutputUsersInnerStatusEnum.serializer)
          ..add(TotpEnrolmentDtoOutput.serializer)
          ..add(UpdateSettingDto.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                CaptainAvailabilityDtoOutputAvailabilityReasonsEnum,
              ),
            ]),
            () =>
                ListBuilder<
                  CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainLocationsDtoPointsInner),
            ]),
            () => ListBuilder<CaptainLocationsDtoPointsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ChangeRolesDtoRolesEnum),
            ]),
            () => ListBuilder<ChangeRolesDtoRolesEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CreateUserDtoRolesEnum),
            ]),
            () => ListBuilder<CreateUserDtoRolesEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantMenuDtoOutputCategoriesInner),
            ]),
            () => ListBuilder<MerchantMenuDtoOutputCategoriesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantMenuDtoOutputCategoriesInnerItemsInner),
            ]),
            () => ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(RoleMatrixDtoOutputRolesInner),
            ]),
            () => ListBuilder<RoleMatrixDtoOutputRolesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SettingHistoryDtoOutputChangesInner),
            ]),
            () => ListBuilder<SettingHistoryDtoOutputChangesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SettingListDtoOutputSettingsInner),
            ]),
            () => ListBuilder<SettingListDtoOutputSettingsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SettingListDtoOutputSettingsInnerEditRolesEnum),
            ]),
            () => ListBuilder<SettingListDtoOutputSettingsInnerEditRolesEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SettingEntryDtoOutputEditRolesEnum),
            ]),
            () => ListBuilder<SettingEntryDtoOutputEditRolesEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(TeamUsersDtoOutputUsersInnerOpenSessionsInner),
            ]),
            () => ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(TeamUsersDtoOutputUsersInner),
            ]),
            () => ListBuilder<TeamUsersDtoOutputUsersInner>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
