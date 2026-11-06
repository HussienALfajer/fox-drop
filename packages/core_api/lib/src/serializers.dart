//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:core_api/src/date_serializer.dart';
import 'package:core_api/src/model/date.dart';

import 'package:core_api/src/model/admin_session_dto_output.dart';
import 'package:core_api/src/model/backup_codes_dto_output.dart';
import 'package:core_api/src/model/captain_availability_dto_output.dart';
import 'package:core_api/src/model/captain_availability_dto_output_availability.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_closed_due.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_usage.dart';
import 'package:core_api/src/model/captain_code_request_dto.dart';
import 'package:core_api/src/model/captain_code_sent_dto_output.dart';
import 'package:core_api/src/model/captain_go_online_dto.dart';
import 'package:core_api/src/model/captain_locations_dto.dart';
import 'package:core_api/src/model/captain_locations_dto_points_inner.dart';
import 'package:core_api/src/model/captain_locations_saved_dto_output.dart';
import 'package:core_api/src/model/captain_refresh_dto.dart';
import 'package:core_api/src/model/captain_session_dto_output.dart';
import 'package:core_api/src/model/captain_sign_in_dto.dart';
import 'package:core_api/src/model/captain_signed_in_dto_output.dart';
import 'package:core_api/src/model/captain_signed_out_dto_output.dart';
import 'package:core_api/src/model/captain_tokens_dto_output.dart';
import 'package:core_api/src/model/captain_went_offline_dto_output.dart';
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/change_roles_dto.dart';
import 'package:core_api/src/model/complete_setup_dto.dart';
import 'package:core_api/src/model/create_user_dto.dart';
import 'package:core_api/src/model/customer_address_deleted_dto_output.dart';
import 'package:core_api/src/model/customer_address_dto_output.dart';
import 'package:core_api/src/model/customer_address_fields_dto.dart';
import 'package:core_api/src/model/customer_address_list_dto_output.dart';
import 'package:core_api/src/model/customer_address_list_dto_output_addresses_inner.dart';
import 'package:core_api/src/model/customer_address_list_dto_output_addresses_inner_location.dart';
import 'package:core_api/src/model/customer_code_request_dto.dart';
import 'package:core_api/src/model/customer_code_sent_dto_output.dart';
import 'package:core_api/src/model/customer_location_dto_output.dart';
import 'package:core_api/src/model/customer_location_dto_output_zone.dart';
import 'package:core_api/src/model/customer_new_address_dto.dart';
import 'package:core_api/src/model/customer_new_address_dto_location.dart';
import 'package:core_api/src/model/customer_profile_dto_output.dart';
import 'package:core_api/src/model/customer_profile_dto_output_profile.dart';
import 'package:core_api/src/model/customer_refresh_dto.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_delivery_fee.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_estimate.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_state.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_delivery_fee.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_items_inner.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_items_inner_option_groups_inner.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_items_inner_option_groups_inner_options_inner.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_window.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_schedule_inner.dart';
import 'package:core_api/src/model/customer_save_profile_dto.dart';
import 'package:core_api/src/model/customer_session_dto_output.dart';
import 'package:core_api/src/model/customer_sign_in_dto.dart';
import 'package:core_api/src/model/customer_signed_in_dto_output.dart';
import 'package:core_api/src/model/customer_signed_out_dto_output.dart';
import 'package:core_api/src/model/customer_tokens_dto_output.dart';
import 'package:core_api/src/model/customer_zone_vote_dto.dart';
import 'package:core_api/src/model/customer_zone_vote_dto_location.dart';
import 'package:core_api/src/model/customer_zone_voted_dto_output.dart';
import 'package:core_api/src/model/done_dto_output.dart';
import 'package:core_api/src/model/merchant_availability_dto.dart';
import 'package:core_api/src/model/merchant_availability_saved_dto_output.dart';
import 'package:core_api/src/model/merchant_code_request_dto.dart';
import 'package:core_api/src/model/merchant_code_sent_dto_output.dart';
import 'package:core_api/src/model/merchant_device_dto.dart';
import 'package:core_api/src/model/merchant_device_saved_dto_output.dart';
import 'package:core_api/src/model/merchant_menu_dto_output.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner_options_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_price.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_switched_off.dart';
import 'package:core_api/src/model/merchant_refresh_dto.dart';
import 'package:core_api/src/model/merchant_restaurant_dto_output.dart';
import 'package:core_api/src/model/merchant_session_dto_output.dart';
import 'package:core_api/src/model/merchant_sign_in_dto.dart';
import 'package:core_api/src/model/merchant_signed_in_dto_output.dart';
import 'package:core_api/src/model/merchant_signed_out_dto_output.dart';
import 'package:core_api/src/model/merchant_tokens_dto_output.dart';
import 'package:core_api/src/model/reset_setting_dto.dart';
import 'package:core_api/src/model/role_matrix_dto_output.dart';
import 'package:core_api/src/model/role_matrix_dto_output_roles_inner.dart';
import 'package:core_api/src/model/setting_entry_dto_output.dart';
import 'package:core_api/src/model/setting_history_dto_output.dart';
import 'package:core_api/src/model/setting_history_dto_output_changes_inner.dart';
import 'package:core_api/src/model/setting_list_dto_output.dart';
import 'package:core_api/src/model/setting_list_dto_output_settings_inner.dart';
import 'package:core_api/src/model/setup_link_dto_output.dart';
import 'package:core_api/src/model/setup_token_dto.dart';
import 'package:core_api/src/model/sign_in_dto.dart';
import 'package:core_api/src/model/signed_out_dto_output.dart';
import 'package:core_api/src/model/status_dto_output.dart';
import 'package:core_api/src/model/team_users_dto_output.dart';
import 'package:core_api/src/model/team_users_dto_output_users_inner.dart';
import 'package:core_api/src/model/team_users_dto_output_users_inner_open_sessions_inner.dart';
import 'package:core_api/src/model/totp_enrolment_dto_output.dart';
import 'package:core_api/src/model/update_setting_dto.dart';

part 'serializers.g.dart';

@SerializersFor([
  AdminSessionDtoOutput,
  BackupCodesDtoOutput,
  CaptainAvailabilityDtoOutput,
  CaptainAvailabilityDtoOutputAvailability,
  CaptainAvailabilityDtoOutputCustody,
  CaptainAvailabilityDtoOutputCustodyClosedDue,
  CaptainAvailabilityDtoOutputCustodyLimit,
  CaptainAvailabilityDtoOutputCustodyUsage,
  CaptainCodeRequestDto,
  CaptainCodeSentDtoOutput,
  CaptainGoOnlineDto,
  CaptainLocationsDto,
  CaptainLocationsDtoPointsInner,
  CaptainLocationsSavedDtoOutput,
  CaptainRefreshDto,
  CaptainSessionDtoOutput,
  CaptainSignInDto,
  CaptainSignedInDtoOutput,
  CaptainSignedOutDtoOutput,
  CaptainTokensDtoOutput,
  CaptainWentOfflineDtoOutput,
  CaptainWentOfflineDtoOutputHandIn,
  ChangeRolesDto,
  CompleteSetupDto,
  CreateUserDto,
  CustomerAddressDeletedDtoOutput,
  CustomerAddressDtoOutput,
  CustomerAddressFieldsDto,
  CustomerAddressListDtoOutput,
  CustomerAddressListDtoOutputAddressesInner,
  CustomerAddressListDtoOutputAddressesInnerLocation,
  CustomerCodeRequestDto,
  CustomerCodeSentDtoOutput,
  CustomerLocationDtoOutput,
  CustomerLocationDtoOutputZone,
  CustomerNewAddressDto,
  CustomerNewAddressDtoLocation,
  CustomerProfileDtoOutput,
  CustomerProfileDtoOutputProfile,
  CustomerRefreshDto,
  CustomerRestaurantListDtoOutput,
  CustomerRestaurantListDtoOutputRestaurantsInner,
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee,
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate,
  CustomerRestaurantListDtoOutputRestaurantsInnerState,
  CustomerRestaurantPageDtoOutput,
  CustomerRestaurantPageDtoOutputDeliveryFee,
  CustomerRestaurantPageDtoOutputMenuInner,
  CustomerRestaurantPageDtoOutputMenuInnerItemsInner,
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner,
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
  CustomerRestaurantPageDtoOutputMenuInnerWindow,
  CustomerRestaurantPageDtoOutputScheduleInner,
  CustomerSaveProfileDto,
  CustomerSessionDtoOutput,
  CustomerSignInDto,
  CustomerSignedInDtoOutput,
  CustomerSignedOutDtoOutput,
  CustomerTokensDtoOutput,
  CustomerZoneVoteDto,
  CustomerZoneVoteDtoLocation,
  CustomerZoneVotedDtoOutput,
  DoneDtoOutput,
  MerchantAvailabilityDto,
  MerchantAvailabilitySavedDtoOutput,
  MerchantCodeRequestDto,
  MerchantCodeSentDtoOutput,
  MerchantDeviceDto,
  MerchantDeviceSavedDtoOutput,
  MerchantMenuDtoOutput,
  MerchantMenuDtoOutputCategoriesInner,
  MerchantMenuDtoOutputCategoriesInnerItemsInner,
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff,
  MerchantRefreshDto,
  MerchantRestaurantDtoOutput,
  MerchantSessionDtoOutput,
  MerchantSignInDto,
  MerchantSignedInDtoOutput,
  MerchantSignedOutDtoOutput,
  MerchantTokensDtoOutput,
  ResetSettingDto,
  RoleMatrixDtoOutput,
  RoleMatrixDtoOutputRolesInner,
  SettingEntryDtoOutput,
  SettingHistoryDtoOutput,
  SettingHistoryDtoOutputChangesInner,
  SettingListDtoOutput,
  SettingListDtoOutputSettingsInner,
  SetupLinkDtoOutput,
  SetupTokenDto,
  SignInDto,
  SignedOutDtoOutput,
  StatusDtoOutput,
  TeamUsersDtoOutput,
  TeamUsersDtoOutputUsersInner,
  TeamUsersDtoOutputUsersInnerOpenSessionsInner,
  TotpEnrolmentDtoOutput,
  UpdateSettingDto,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(SettingListDtoOutputSettingsInner),
            ]),
            () => ListBuilder<SettingListDtoOutputSettingsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(CustomerRestaurantListDtoOutputRestaurantsInner),
            ]),
            () =>
                ListBuilder<CustomerRestaurantListDtoOutputRestaurantsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(TeamUsersDtoOutputUsersInner)]),
            () => ListBuilder<TeamUsersDtoOutputUsersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(num)]),
            () => ListBuilder<num>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(MerchantMenuDtoOutputCategoriesInnerItemsInner),
            ]),
            () => ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(CustomerAddressListDtoOutputAddressesInner),
            ]),
            () => ListBuilder<CustomerAddressListDtoOutputAddressesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(CustomerRestaurantPageDtoOutputMenuInnerItemsInner),
            ]),
            () =>
                ListBuilder<
                  CustomerRestaurantPageDtoOutputMenuInnerItemsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(TeamUsersDtoOutputUsersInnerOpenSessionsInner),
            ]),
            () => ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(CaptainLocationsDtoPointsInner),
            ]),
            () => ListBuilder<CaptainLocationsDtoPointsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(RoleMatrixDtoOutputRolesInner),
            ]),
            () => ListBuilder<RoleMatrixDtoOutputRolesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(
                MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(CustomerRestaurantPageDtoOutputScheduleInner),
            ]),
            () => ListBuilder<CustomerRestaurantPageDtoOutputScheduleInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(
                CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(MerchantMenuDtoOutputCategoriesInner),
            ]),
            () => ListBuilder<MerchantMenuDtoOutputCategoriesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(
                CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(CustomerRestaurantPageDtoOutputMenuInner),
            ]),
            () => ListBuilder<CustomerRestaurantPageDtoOutputMenuInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(
                MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(SettingHistoryDtoOutputChangesInner),
            ]),
            () => ListBuilder<SettingHistoryDtoOutputChangesInner>(),
          )
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
