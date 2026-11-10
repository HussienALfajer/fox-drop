// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(AddReasonDto.serializer)
          ..add(AddReasonDtoNoteEnum.serializer)
          ..add(AdminAcceptDto.serializer)
          ..add(AdminAlertDtoOutput.serializer)
          ..add(AdminAlertDtoOutputCodeEnum.serializer)
          ..add(AdminAlertDtoOutputSeverityEnum.serializer)
          ..add(AdminAlertDtoOutputSubjectTypeEnum.serializer)
          ..add(AdminAlertsDtoOutput.serializer)
          ..add(AdminAlertsDtoOutputAlertsInner.serializer)
          ..add(AdminAlertsDtoOutputAlertsInnerAcknowledged.serializer)
          ..add(AdminAlertsDtoOutputAlertsInnerCodeEnum.serializer)
          ..add(AdminAlertsDtoOutputAlertsInnerSeverityEnum.serializer)
          ..add(AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum.serializer)
          ..add(AdminAssignDto.serializer)
          ..add(AdminBoardDtoOutput.serializer)
          ..add(AdminCancelDto.serializer)
          ..add(AdminCancelDtoCashEnum.serializer)
          ..add(AdminCancelDtoResponsibleEnum.serializer)
          ..add(AdminCancelPreviewAnswerDtoOutput.serializer)
          ..add(AdminCancelPreviewAnswerDtoOutputEntriesInner.serializer)
          ..add(AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount.serializer)
          ..add(AdminCancelPreviewAnswerDtoOutputEntriesInnerParty.serializer)
          ..add(
            AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
                .serializer,
          )
          ..add(AdminCancelPreviewDto.serializer)
          ..add(AdminCancelPreviewDtoCashEnum.serializer)
          ..add(AdminCancelPreviewDtoResponsibleEnum.serializer)
          ..add(AdminChangeTimeDto.serializer)
          ..add(AdminCitiesDtoOutput.serializer)
          ..add(AdminCitiesDtoOutputCitiesInner.serializer)
          ..add(AdminCloseItemReportDto.serializer)
          ..add(AdminConfirmPickupDto.serializer)
          ..add(AdminContactDtoOutput.serializer)
          ..add(AdminDispatchStateDtoOutput.serializer)
          ..add(AdminDispatchStateDtoOutputOrder.serializer)
          ..add(AdminDispatchStateDtoOutputOrderCaptainTrackEnum.serializer)
          ..add(AdminDispatchStateDtoOutputOrderOffer.serializer)
          ..add(AdminDispatchStateDtoOutputOrderStatusEnum.serializer)
          ..add(AdminEmergencyStopDtoOutput.serializer)
          ..add(AdminEmergencyStopDtoOutputStop.serializer)
          ..add(AdminEmergencyStopResumedDtoOutput.serializer)
          ..add(AdminEmergencyStopResumedDtoOutputResumedEnum.serializer)
          ..add(AdminEmergencyStopStateDtoOutput.serializer)
          ..add(AdminEmergencyStopStateDtoOutputDefaults.serializer)
          ..add(AdminEmergencyStopStateDtoOutputStop.serializer)
          ..add(AdminFaqDto.serializer)
          ..add(AdminFaqDtoItemsInner.serializer)
          ..add(AdminFaqDtoOutput.serializer)
          ..add(AdminFaqsDtoOutput.serializer)
          ..add(AdminFaqsDtoOutputCustomerInner.serializer)
          ..add(AdminImageSetDtoOutput.serializer)
          ..add(AdminNewUploadDto.serializer)
          ..add(AdminNewUploadDtoContentTypeEnum.serializer)
          ..add(AdminNewUploadDtoPurposeEnum.serializer)
          ..add(AdminNotificationResentDtoOutput.serializer)
          ..add(AdminNotificationTextDtoOutput.serializer)
          ..add(AdminNotificationTextDtoOutputAudienceEnum.serializer)
          ..add(AdminNotificationTextDtoOutputLevelEnum.serializer)
          ..add(AdminNotificationTextDtoOutputPriorityEnum.serializer)
          ..add(AdminNotificationTextsDtoOutput.serializer)
          ..add(AdminNotificationTextsDtoOutputTemplatesInner.serializer)
          ..add(
            AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum
                .serializer,
          )
          ..add(
            AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum.serializer,
          )
          ..add(
            AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum
                .serializer,
          )
          ..add(AdminOrderCardDtoOutput.serializer)
          ..add(AdminOrderCardDtoOutputOrder.serializer)
          ..add(AdminOrderCardDtoOutputOrderAlertsEnum.serializer)
          ..add(AdminOrderCardDtoOutputOrderBadges.serializer)
          ..add(AdminOrderCardDtoOutputOrderCaptain.serializer)
          ..add(AdminOrderCardDtoOutputOrderCaptainTrackEnum.serializer)
          ..add(AdminOrderCardDtoOutputOrderMoments.serializer)
          ..add(AdminOrderCardDtoOutputOrderRestaurant.serializer)
          ..add(AdminOrderCardDtoOutputOrderStatusEnum.serializer)
          ..add(AdminOrderCardDtoOutputOrderTotal.serializer)
          ..add(AdminOrderDtoOutput.serializer)
          ..add(AdminOrderDtoOutputOrder.serializer)
          ..add(AdminOrderDtoOutputOrderAcceptance.serializer)
          ..add(AdminOrderDtoOutputOrderAlertsEnum.serializer)
          ..add(AdminOrderDtoOutputOrderCancelChoices.serializer)
          ..add(AdminOrderDtoOutputOrderCancelChoicesReasonsInner.serializer)
          ..add(AdminOrderDtoOutputOrderCancellation.serializer)
          ..add(AdminOrderDtoOutputOrderCancellationBy.serializer)
          ..add(AdminOrderDtoOutputOrderCancellationCashEnum.serializer)
          ..add(AdminOrderDtoOutputOrderCancellationResponsibleEnum.serializer)
          ..add(AdminOrderDtoOutputOrderCaptainTrackEnum.serializer)
          ..add(AdminOrderDtoOutputOrderCustomer.serializer)
          ..add(AdminOrderDtoOutputOrderCustomerAddress.serializer)
          ..add(AdminOrderDtoOutputOrderCustomerArrival.serializer)
          ..add(AdminOrderDtoOutputOrderCustomerArrivalAway.serializer)
          ..add(AdminOrderDtoOutputOrderDelivery.serializer)
          ..add(AdminOrderDtoOutputOrderDeliveryNetReceived.serializer)
          ..add(AdminOrderDtoOutputOrderDeliveryOutcomeEnum.serializer)
          ..add(AdminOrderDtoOutputOrderDeliveryRecordedBy.serializer)
          ..add(AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum.serializer)
          ..add(AdminOrderDtoOutputOrderDeliveryShortfall.serializer)
          ..add(AdminOrderDtoOutputOrderItemReport.serializer)
          ..add(AdminOrderDtoOutputOrderItemReportItemsInner.serializer)
          ..add(
            AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum.serializer,
          )
          ..add(AdminOrderDtoOutputOrderLinesInner.serializer)
          ..add(AdminOrderDtoOutputOrderLinesInnerOptionsInner.serializer)
          ..add(AdminOrderDtoOutputOrderMoney.serializer)
          ..add(AdminOrderDtoOutputOrderOnBehalf.serializer)
          ..add(AdminOrderDtoOutputOrderOnBehalfPrepTime.serializer)
          ..add(AdminOrderDtoOutputOrderPickup.serializer)
          ..add(AdminOrderDtoOutputOrderPickupDispute.serializer)
          ..add(AdminOrderDtoOutputOrderPickupRequestsInner.serializer)
          ..add(AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy.serializer)
          ..add(
            AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum.serializer,
          )
          ..add(
            AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum.serializer,
          )
          ..add(AdminOrderDtoOutputOrderRejection.serializer)
          ..add(AdminOrderDtoOutputOrderStatusEnum.serializer)
          ..add(AdminOrderDtoOutputOrderTimeChange.serializer)
          ..add(AdminOrderDtoOutputOrderTimelineInner.serializer)
          ..add(AdminOrderDtoOutputOrderTimelineInnerActor.serializer)
          ..add(AdminOrderDtoOutputOrderTimelineInnerFromEnum.serializer)
          ..add(AdminOrderDtoOutputOrderTimelineInnerItemReport.serializer)
          ..add(AdminOrderDtoOutputOrderTimelineInnerTimeChange.serializer)
          ..add(AdminOrderDtoOutputOrderTimelineInnerToEnum.serializer)
          ..add(AdminPickerDtoOutput.serializer)
          ..add(AdminPickerDtoOutputCaptainsInner.serializer)
          ..add(AdminPickerDtoOutputCaptainsInnerCustody.serializer)
          ..add(AdminPickerDtoOutputCaptainsInnerCustodyLimit.serializer)
          ..add(AdminPickerDtoOutputCaptainsInnerCustodyUsage.serializer)
          ..add(AdminPickerDtoOutputCaptainsInnerReasonsEnum.serializer)
          ..add(AdminPickerDtoOutputCaptainsInnerVehicleEnum.serializer)
          ..add(AdminPublishTermsDto.serializer)
          ..add(AdminReasonDtoOutput.serializer)
          ..add(AdminReasonDtoOutputNoteEnum.serializer)
          ..add(AdminReasonListsDtoOutput.serializer)
          ..add(AdminReasonListsDtoOutputListsInner.serializer)
          ..add(AdminReasonListsDtoOutputListsInnerAppsEnum.serializer)
          ..add(AdminReasonListsDtoOutputListsInnerListEnum.serializer)
          ..add(AdminReasonListsDtoOutputListsInnerReasonsInner.serializer)
          ..add(
            AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum.serializer,
          )
          ..add(AdminReasonOrderDtoOutput.serializer)
          ..add(AdminRecordArrivalDto.serializer)
          ..add(AdminRecordDeliveryDto.serializer)
          ..add(AdminRecordDeliveryDtoAmountDue.serializer)
          ..add(AdminRecordDeliveryDtoReceivedInner.serializer)
          ..add(AdminRecordDeliveryDtoShortfall.serializer)
          ..add(AdminRejectDto.serializer)
          ..add(AdminRejectDtoItemsInner.serializer)
          ..add(AdminRejectDtoItemsInnerUntilEnum.serializer)
          ..add(AdminResendNotificationDto.serializer)
          ..add(AdminResendNotificationDtoToEnum.serializer)
          ..add(AdminRestaurantHolidayCloseDto.serializer)
          ..add(AdminRestaurantImagesDtoOutput.serializer)
          ..add(AdminRestaurantImagesDtoOutputCategoriesInner.serializer)
          ..add(
            AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner.serializer,
          )
          ..add(AdminRestaurantMaxActiveOrdersDto.serializer)
          ..add(AdminRestaurantPauseDto.serializer)
          ..add(AdminRestaurantStatusDtoOutput.serializer)
          ..add(AdminRestaurantStatusDtoOutputAccountStatusEnum.serializer)
          ..add(AdminRestaurantStatusDtoOutputHeldPauseSourceEnum.serializer)
          ..add(AdminRestaurantStatusDtoOutputPauseSourceEnum.serializer)
          ..add(AdminRestaurantStatusDtoOutputStateEnum.serializer)
          ..add(AdminRestaurantsDtoOutput.serializer)
          ..add(AdminRestaurantsDtoOutputRestaurantsInner.serializer)
          ..add(AdminResumeEmergencyStopDto.serializer)
          ..add(AdminSessionDtoOutput.serializer)
          ..add(AdminSetImageDto.serializer)
          ..add(AdminShortfallsDtoOutput.serializer)
          ..add(AdminShortfallsDtoOutputShortfallsInner.serializer)
          ..add(AdminStartEmergencyStopDto.serializer)
          ..add(AdminTermsDtoOutput.serializer)
          ..add(AdminTermsDtoOutputCustomer.serializer)
          ..add(AdminTermsVersionDtoOutput.serializer)
          ..add(AdminTextsDtoOutput.serializer)
          ..add(AdminTextsDtoOutputContact.serializer)
          ..add(AdminUpdateContactDto.serializer)
          ..add(AdminUpdateNotificationTextDto.serializer)
          ..add(AdminUploadDtoOutput.serializer)
          ..add(AdminWorkRulesDto.serializer)
          ..add(AdminWorkRulesDtoOutput.serializer)
          ..add(BackupCodesDtoOutput.serializer)
          ..add(CaptainActiveOrderDtoOutput.serializer)
          ..add(CaptainActiveOrderDtoOutputCancelled.serializer)
          ..add(CaptainActiveOrderDtoOutputCancelledCashEnum.serializer)
          ..add(CaptainActiveOrderDtoOutputOrder.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderArrival.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderCaptainTrackEnum.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderCollect.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderCustomer.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderCustomerAddress.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderCustomerArrival.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderCustomerLocation.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderLinesInner.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderPickup.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderPickupPayment.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderPickupRequest.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderPickupRequestAmount.serializer)
          ..add(
            CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum.serializer,
          )
          ..add(
            CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum.serializer,
          )
          ..add(CaptainActiveOrderDtoOutputOrderPreparation.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderRadii.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderRestaurant.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderRestaurantLocation.serializer)
          ..add(CaptainActiveOrderDtoOutputOrderStatusEnum.serializer)
          ..add(CaptainArriveAtCustomerDto.serializer)
          ..add(CaptainArriveAtCustomerDtoAway.serializer)
          ..add(CaptainArriveDto.serializer)
          ..add(CaptainArriveDtoLocation.serializer)
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
          ..add(CaptainContentDtoOutput.serializer)
          ..add(CaptainContentDtoOutputReasons.serializer)
          ..add(CaptainCurrentOfferDtoOutput.serializer)
          ..add(CaptainCurrentOfferDtoOutputOffer.serializer)
          ..add(CaptainCurrentOfferDtoOutputOfferCollect.serializer)
          ..add(CaptainCurrentOfferDtoOutputOfferCustomer.serializer)
          ..add(CaptainCurrentOfferDtoOutputOfferPickupPayment.serializer)
          ..add(CaptainCurrentOfferDtoOutputOfferPreparation.serializer)
          ..add(CaptainCurrentOfferDtoOutputOfferRestaurant.serializer)
          ..add(CaptainCurrentOfferDtoOutputOfferStatusEnum.serializer)
          ..add(CaptainDeliverDto.serializer)
          ..add(CaptainDeliverDtoAway.serializer)
          ..add(CaptainDeliverySummaryDtoOutput.serializer)
          ..add(CaptainDeliverySummaryDtoOutputSummary.serializer)
          ..add(CaptainDeliverySummaryDtoOutputSummaryCustodyChange.serializer)
          ..add(CaptainDeliverySummaryDtoOutputSummaryHandInToday.serializer)
          ..add(CaptainDeliverySummaryDtoOutputSummaryPay.serializer)
          ..add(CaptainEmergencyStopDtoOutput.serializer)
          ..add(CaptainGoOnlineDto.serializer)
          ..add(CaptainLocationsDto.serializer)
          ..add(CaptainLocationsDtoPointsInner.serializer)
          ..add(CaptainLocationsSavedDtoOutput.serializer)
          ..add(CaptainOfferDtoOutput.serializer)
          ..add(CaptainOfferDtoOutputOffer.serializer)
          ..add(CaptainOfferDtoOutputOfferStatusEnum.serializer)
          ..add(CaptainOrderDtoOutput.serializer)
          ..add(CaptainOrderDtoOutputOrder.serializer)
          ..add(CaptainOrderDtoOutputOrderCaptainTrackEnum.serializer)
          ..add(CaptainOrderDtoOutputOrderCustomer.serializer)
          ..add(CaptainOrderDtoOutputOrderPickup.serializer)
          ..add(CaptainOrderDtoOutputOrderPickupRequest.serializer)
          ..add(CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum.serializer)
          ..add(CaptainOrderDtoOutputOrderPickupRequestStatusEnum.serializer)
          ..add(CaptainOrderDtoOutputOrderStatusEnum.serializer)
          ..add(CaptainPickupRequestDto.serializer)
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
          ..add(ContactDtoOutput.serializer)
          ..add(CreateUserDto.serializer)
          ..add(CreateUserDtoRolesEnum.serializer)
          ..add(CustomerActiveOrdersDtoOutput.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInner.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerAddress.serializer)
          ..add(
            CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum.serializer,
          )
          ..add(
            CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation.serializer,
          )
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerCancellation.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerCaptain.serializer)
          ..add(
            CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
                .serializer,
          )
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerDelivery.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerEstimate.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerItemReport.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerLinesInner.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerMoney.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerRejection.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerRestaurant.serializer)
          ..add(CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum.serializer)
          ..add(CustomerAddressDeletedDtoOutput.serializer)
          ..add(CustomerAddressDeletedDtoOutputStatusEnum.serializer)
          ..add(CustomerAddressDtoOutput.serializer)
          ..add(CustomerAddressDtoOutputLabelEnum.serializer)
          ..add(CustomerAddressFieldsDto.serializer)
          ..add(CustomerAddressFieldsDtoLabelEnum.serializer)
          ..add(CustomerAddressListDtoOutput.serializer)
          ..add(CustomerAddressListDtoOutputAddressesInner.serializer)
          ..add(CustomerAddressListDtoOutputAddressesInnerLabelEnum.serializer)
          ..add(CustomerAddressListDtoOutputAddressesInnerLocation.serializer)
          ..add(CustomerCancelOrderDto.serializer)
          ..add(CustomerCodeRequestDto.serializer)
          ..add(CustomerCodeSentDtoOutput.serializer)
          ..add(CustomerCodeSentDtoOutputChannelEnum.serializer)
          ..add(CustomerContentDtoOutput.serializer)
          ..add(CustomerContentDtoOutputReasons.serializer)
          ..add(CustomerEmergencyStopDtoOutput.serializer)
          ..add(CustomerLocationDtoOutput.serializer)
          ..add(CustomerLocationDtoOutputStateEnum.serializer)
          ..add(CustomerLocationDtoOutputZone.serializer)
          ..add(CustomerNewAddressDto.serializer)
          ..add(CustomerNewAddressDtoLabelEnum.serializer)
          ..add(CustomerNewAddressDtoLocation.serializer)
          ..add(CustomerNotificationsDtoOutput.serializer)
          ..add(CustomerNotificationsDtoOutputNotificationsInner.serializer)
          ..add(CustomerOrderDtoOutput.serializer)
          ..add(CustomerOrderDtoOutputOrder.serializer)
          ..add(CustomerOrderDtoOutputOrderDelivery.serializer)
          ..add(CustomerOrderDtoOutputOrderStatusEnum.serializer)
          ..add(CustomerPlaceOrderDto.serializer)
          ..add(CustomerPlaceOrderDtoUnsavedAddress.serializer)
          ..add(CustomerProfileDtoOutput.serializer)
          ..add(CustomerProfileDtoOutputProfile.serializer)
          ..add(CustomerProfileDtoOutputProfileGenderEnum.serializer)
          ..add(CustomerQuoteDtoOutput.serializer)
          ..add(CustomerQuoteDtoOutputEstimate.serializer)
          ..add(CustomerQuoteDtoOutputFreeDelivery.serializer)
          ..add(CustomerQuoteDtoOutputLinesInner.serializer)
          ..add(CustomerQuoteDtoOutputLinesInnerOptionsInner.serializer)
          ..add(CustomerQuoteDtoOutputMinimumOrder.serializer)
          ..add(CustomerQuoteDtoOutputMoney.serializer)
          ..add(CustomerQuoteDtoOutputProblemsInner.serializer)
          ..add(CustomerQuoteDtoOutputProblemsInnerCodeEnum.serializer)
          ..add(CustomerQuoteDtoOutputRatesInner.serializer)
          ..add(CustomerQuoteDtoOutputRestaurant.serializer)
          ..add(CustomerQuoteDtoOutputRestaurantStateEnum.serializer)
          ..add(CustomerQuoteRequestDto.serializer)
          ..add(CustomerQuoteRequestDtoLinesInner.serializer)
          ..add(CustomerQuoteRequestDtoLocation.serializer)
          ..add(CustomerRefreshDto.serializer)
          ..add(CustomerRestaurantListDtoOutput.serializer)
          ..add(CustomerRestaurantListDtoOutputRestaurantsInner.serializer)
          ..add(
            CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee
                .serializer,
          )
          ..add(
            CustomerRestaurantListDtoOutputRestaurantsInnerEstimate.serializer,
          )
          ..add(CustomerRestaurantListDtoOutputRestaurantsInnerState.serializer)
          ..add(
            CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
                .serializer,
          )
          ..add(CustomerRestaurantPageDtoOutput.serializer)
          ..add(CustomerRestaurantPageDtoOutputDeliveryFee.serializer)
          ..add(CustomerRestaurantPageDtoOutputMenuInner.serializer)
          ..add(CustomerRestaurantPageDtoOutputMenuInnerItemsInner.serializer)
          ..add(
            CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
                .serializer,
          )
          ..add(
            CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
                .serializer,
          )
          ..add(
            CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
                .serializer,
          )
          ..add(CustomerRestaurantPageDtoOutputMenuInnerWindow.serializer)
          ..add(CustomerRestaurantPageDtoOutputScheduleInner.serializer)
          ..add(CustomerSaveProfileDto.serializer)
          ..add(CustomerSaveProfileDtoGenderEnum.serializer)
          ..add(CustomerSessionDtoOutput.serializer)
          ..add(CustomerSignInDto.serializer)
          ..add(CustomerSignedInDtoOutput.serializer)
          ..add(CustomerSignedOutDtoOutput.serializer)
          ..add(CustomerSignedOutDtoOutputStatusEnum.serializer)
          ..add(CustomerTokensDtoOutput.serializer)
          ..add(CustomerZoneVoteDto.serializer)
          ..add(CustomerZoneVoteDtoLocation.serializer)
          ..add(CustomerZoneVotedDtoOutput.serializer)
          ..add(CustomerZoneVotedDtoOutputStatusEnum.serializer)
          ..add(DoneDtoOutput.serializer)
          ..add(DoneDtoOutputStatusEnum.serializer)
          ..add(EmergencySignInCodeDtoOutput.serializer)
          ..add(EmergencySignInCodeRequestDto.serializer)
          ..add(EmergencySignInCodeRequestDtoPartyEnum.serializer)
          ..add(MerchantAcceptDto.serializer)
          ..add(MerchantAvailabilityDto.serializer)
          ..add(MerchantAvailabilityDtoTypeEnum.serializer)
          ..add(MerchantAvailabilityDtoUntilEnum.serializer)
          ..add(MerchantAvailabilitySavedDtoOutput.serializer)
          ..add(MerchantBusyModeDto.serializer)
          ..add(MerchantCodeRequestDto.serializer)
          ..add(MerchantCodeRequestDtoPlatformEnum.serializer)
          ..add(MerchantCodeSentDtoOutput.serializer)
          ..add(MerchantCodeSentDtoOutputChannelEnum.serializer)
          ..add(MerchantContentDtoOutput.serializer)
          ..add(MerchantContentDtoOutputFaqInner.serializer)
          ..add(MerchantContentDtoOutputReasons.serializer)
          ..add(
            MerchantContentDtoOutputReasonsMerchantRejectionInner.serializer,
          )
          ..add(
            MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
                .serializer,
          )
          ..add(MerchantDeviceDto.serializer)
          ..add(MerchantDeviceDtoPlatformEnum.serializer)
          ..add(MerchantDeviceSavedDtoOutput.serializer)
          ..add(MerchantDeviceSavedDtoOutputStatusEnum.serializer)
          ..add(MerchantEmergencyStopDtoOutput.serializer)
          ..add(MerchantHolidayCloseDto.serializer)
          ..add(MerchantHoursDtoOutput.serializer)
          ..add(MerchantHoursDtoOutputCoverage.serializer)
          ..add(MerchantHoursDtoOutputCoverageKindEnum.serializer)
          ..add(MerchantHoursDtoOutputPeriodsInner.serializer)
          ..add(MerchantItemReportDto.serializer)
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
          ..add(MerchantOrderDtoOutput.serializer)
          ..add(MerchantOrderDtoOutputOrder.serializer)
          ..add(MerchantOrderDtoOutputOrderCaptainTrackEnum.serializer)
          ..add(MerchantOrderDtoOutputOrderPickup.serializer)
          ..add(MerchantOrderDtoOutputOrderPickupRequest.serializer)
          ..add(MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum.serializer)
          ..add(MerchantOrderDtoOutputOrderPickupRequestStatusEnum.serializer)
          ..add(MerchantOrderDtoOutputOrderStatusEnum.serializer)
          ..add(MerchantOrderSettingsDto.serializer)
          ..add(MerchantOrdersDtoOutput.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInner.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerAcceptance.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerCancellation.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerCaptain.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerCaptainArrival.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerCaptainTrackEnum.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerCustomer.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerItemReport.serializer)
          ..add(
            MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner.serializer,
          )
          ..add(
            MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
                .serializer,
          )
          ..add(MerchantOrdersDtoOutputOrdersInnerItemReportNote.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerLinesInner.serializer)
          ..add(
            MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner.serializer,
          )
          ..add(MerchantOrdersDtoOutputOrdersInnerPickup.serializer)
          ..add(MerchantOrdersDtoOutputOrdersInnerPickupRequest.serializer)
          ..add(
            MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
                .serializer,
          )
          ..add(
            MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
                .serializer,
          )
          ..add(MerchantOrdersDtoOutputOrdersInnerStatusEnum.serializer)
          ..add(MerchantOrdersDtoOutputPrepTime.serializer)
          ..add(MerchantPauseDto.serializer)
          ..add(MerchantPickupDisputeDto.serializer)
          ..add(MerchantPickupDisputeDtoReceivedLinesInner.serializer)
          ..add(MerchantRefreshDto.serializer)
          ..add(MerchantRejectDto.serializer)
          ..add(MerchantRejectDtoItemsInner.serializer)
          ..add(MerchantRejectDtoItemsInnerUntilEnum.serializer)
          ..add(MerchantRestaurantDtoOutput.serializer)
          ..add(MerchantRestaurantDtoOutputAccountStatusEnum.serializer)
          ..add(MerchantRestaurantDtoOutputStateEnum.serializer)
          ..add(MerchantScheduleDto.serializer)
          ..add(MerchantScheduleDtoPeriodsInner.serializer)
          ..add(MerchantSessionDtoOutput.serializer)
          ..add(MerchantSessionDtoOutputRoleEnum.serializer)
          ..add(MerchantSignInDto.serializer)
          ..add(MerchantSignedInDtoOutput.serializer)
          ..add(MerchantSignedInDtoOutputRoleEnum.serializer)
          ..add(MerchantSignedOutDtoOutput.serializer)
          ..add(MerchantSignedOutDtoOutputStatusEnum.serializer)
          ..add(MerchantStatusDtoOutput.serializer)
          ..add(MerchantStatusDtoOutputBusyMode.serializer)
          ..add(MerchantStatusDtoOutputHoliday.serializer)
          ..add(MerchantStatusDtoOutputPauseSourceEnum.serializer)
          ..add(MerchantStatusDtoOutputStateEnum.serializer)
          ..add(MerchantTokensDtoOutput.serializer)
          ..add(PlatformDtoOutput.serializer)
          ..add(PlatformDtoOutputUpdateNeedEnum.serializer)
          ..add(PushTokenDto.serializer)
          ..add(PushTokenDtoPlatformEnum.serializer)
          ..add(PushTokenRegisteredDtoOutput.serializer)
          ..add(PushTokenRegisteredDtoOutputStatusEnum.serializer)
          ..add(RealtimeTokenDtoOutput.serializer)
          ..add(ReorderDto.serializer)
          ..add(ResetSettingDto.serializer)
          ..add(RoleMatrixDtoOutput.serializer)
          ..add(RoleMatrixDtoOutputRolesInner.serializer)
          ..add(SenderNumberStatusDto.serializer)
          ..add(SenderNumberStatusDtoStatusEnum.serializer)
          ..add(SenderPoolDtoOutput.serializer)
          ..add(SenderPoolDtoOutputAlertsInner.serializer)
          ..add(SenderPoolDtoOutputAlertsInnerSeverityEnum.serializer)
          ..add(SenderPoolDtoOutputAlertsInnerTypeEnum.serializer)
          ..add(SenderPoolDtoOutputNumbersInner.serializer)
          ..add(SenderPoolDtoOutputNumbersInnerStatusEnum.serializer)
          ..add(SenderPoolDtoOutputNumbersInnerToday.serializer)
          ..add(SenderPoolDtoOutputNumbersInnerWarmup.serializer)
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
          ..add(TermsAcceptDto.serializer)
          ..add(TermsAcceptedDtoOutput.serializer)
          ..add(TermsAcceptedDtoOutputStatusEnum.serializer)
          ..add(TermsDtoOutput.serializer)
          ..add(TotpEnrolmentDtoOutput.serializer)
          ..add(UpdateReasonDto.serializer)
          ..add(UpdateReasonDtoNoteEnum.serializer)
          ..add(UpdateSettingDto.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminAlertsDtoOutputAlertsInner),
            ]),
            () => ListBuilder<AdminAlertsDtoOutputAlertsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminCancelPreviewAnswerDtoOutputEntriesInner),
            ]),
            () => ListBuilder<AdminCancelPreviewAnswerDtoOutputEntriesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminCitiesDtoOutputCitiesInner),
            ]),
            () => ListBuilder<AdminCitiesDtoOutputCitiesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminFaqDtoItemsInner),
            ]),
            () => ListBuilder<AdminFaqDtoItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminFaqsDtoOutputCustomerInner),
            ]),
            () => ListBuilder<AdminFaqsDtoOutputCustomerInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminFaqsDtoOutputCustomerInner),
            ]),
            () => ListBuilder<AdminFaqsDtoOutputCustomerInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminFaqsDtoOutputCustomerInner),
            ]),
            () => ListBuilder<AdminFaqsDtoOutputCustomerInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminFaqsDtoOutputCustomerInner),
            ]),
            () => ListBuilder<AdminFaqsDtoOutputCustomerInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminNotificationTextsDtoOutputTemplatesInner),
            ]),
            () => ListBuilder<AdminNotificationTextsDtoOutputTemplatesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderCardDtoOutputOrder),
            ]),
            () => ListBuilder<AdminOrderCardDtoOutputOrder>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderCardDtoOutputOrderAlertsEnum),
            ]),
            () => ListBuilder<AdminOrderCardDtoOutputOrderAlertsEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderAlertsEnum),
            ]),
            () => ListBuilder<AdminOrderDtoOutputOrderAlertsEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderLinesInner),
            ]),
            () => ListBuilder<AdminOrderDtoOutputOrderLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderTimelineInner),
            ]),
            () => ListBuilder<AdminOrderDtoOutputOrderTimelineInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderCancelChoicesReasonsInner),
            ]),
            () =>
                ListBuilder<
                  AdminOrderDtoOutputOrderCancelChoicesReasonsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderCancelChoicesReasonsInner),
            ]),
            () =>
                ListBuilder<
                  AdminOrderDtoOutputOrderCancelChoicesReasonsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderItemReportItemsInner),
            ]),
            () => ListBuilder<AdminOrderDtoOutputOrderItemReportItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderLinesInnerOptionsInner),
            ]),
            () => ListBuilder<AdminOrderDtoOutputOrderLinesInnerOptionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminOrderDtoOutputOrderPickupRequestsInner),
            ]),
            () => ListBuilder<AdminOrderDtoOutputOrderPickupRequestsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminPickerDtoOutputCaptainsInner),
            ]),
            () => ListBuilder<AdminPickerDtoOutputCaptainsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminPickerDtoOutputCaptainsInnerReasonsEnum),
            ]),
            () => ListBuilder<AdminPickerDtoOutputCaptainsInnerReasonsEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminReasonListsDtoOutputListsInner),
            ]),
            () => ListBuilder<AdminReasonListsDtoOutputListsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminReasonListsDtoOutputListsInnerAppsEnum),
            ]),
            () => ListBuilder<AdminReasonListsDtoOutputListsInnerAppsEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminReasonListsDtoOutputListsInnerReasonsInner),
            ]),
            () =>
                ListBuilder<AdminReasonListsDtoOutputListsInnerReasonsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminReasonListsDtoOutputListsInnerReasonsInner),
            ]),
            () =>
                ListBuilder<AdminReasonListsDtoOutputListsInnerReasonsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRecordDeliveryDtoReceivedInner),
            ]),
            () => ListBuilder<AdminRecordDeliveryDtoReceivedInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRecordDeliveryDtoReceivedInner),
            ]),
            () => ListBuilder<AdminRecordDeliveryDtoReceivedInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRecordDeliveryDtoReceivedInner),
            ]),
            () => ListBuilder<AdminRecordDeliveryDtoReceivedInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRecordDeliveryDtoReceivedInner),
            ]),
            () => ListBuilder<AdminRecordDeliveryDtoReceivedInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRejectDtoItemsInner),
            ]),
            () => ListBuilder<AdminRejectDtoItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRestaurantImagesDtoOutputCategoriesInner),
            ]),
            () => ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminRestaurantsDtoOutputRestaurantsInner),
            ]),
            () => ListBuilder<AdminRestaurantsDtoOutputRestaurantsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminShortfallsDtoOutputShortfallsInner),
            ]),
            () => ListBuilder<AdminShortfallsDtoOutputShortfallsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainActiveOrderDtoOutputOrderLinesInner),
            ]),
            () => ListBuilder<CaptainActiveOrderDtoOutputOrderLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainActiveOrderDtoOutputOrderLinesInner),
            ]),
            () => ListBuilder<CaptainActiveOrderDtoOutputOrderLinesInner>(),
          )
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
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
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
              const FullType(CustomerActiveOrdersDtoOutputOrdersInner),
            ]),
            () => ListBuilder<CustomerActiveOrdersDtoOutputOrdersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerAddressListDtoOutputAddressesInner),
            ]),
            () => ListBuilder<CustomerAddressListDtoOutputAddressesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerNotificationsDtoOutputNotificationsInner),
            ]),
            () =>
                ListBuilder<CustomerNotificationsDtoOutputNotificationsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteDtoOutputLinesInner),
            ]),
            () => ListBuilder<CustomerQuoteDtoOutputLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteDtoOutputRatesInner),
            ]),
            () => ListBuilder<CustomerQuoteDtoOutputRatesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteDtoOutputProblemsInner),
            ]),
            () => ListBuilder<CustomerQuoteDtoOutputProblemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteDtoOutputLinesInnerOptionsInner),
            ]),
            () => ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteDtoOutputLinesInnerOptionsInner),
            ]),
            () => ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteRequestDtoLinesInner),
            ]),
            () => ListBuilder<CustomerQuoteRequestDtoLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerQuoteRequestDtoLinesInner),
            ]),
            () => ListBuilder<CustomerQuoteRequestDtoLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerRestaurantListDtoOutputRestaurantsInner),
            ]),
            () =>
                ListBuilder<CustomerRestaurantListDtoOutputRestaurantsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                CustomerRestaurantPageDtoOutputMenuInnerItemsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerRestaurantPageDtoOutputMenuInnerItemsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerRestaurantPageDtoOutputScheduleInner),
            ]),
            () => ListBuilder<CustomerRestaurantPageDtoOutputScheduleInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CustomerRestaurantPageDtoOutputMenuInner),
            ]),
            () => ListBuilder<CustomerRestaurantPageDtoOutputMenuInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantContentDtoOutputFaqInner),
            ]),
            () => ListBuilder<MerchantContentDtoOutputFaqInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantContentDtoOutputFaqInner),
            ]),
            () => ListBuilder<MerchantContentDtoOutputFaqInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantContentDtoOutputFaqInner),
            ]),
            () => ListBuilder<MerchantContentDtoOutputFaqInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantContentDtoOutputReasonsMerchantRejectionInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantContentDtoOutputReasonsMerchantRejectionInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantHoursDtoOutputPeriodsInner),
            ]),
            () => ListBuilder<MerchantHoursDtoOutputPeriodsInner>(),
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
              const FullType(MerchantOrdersDtoOutputOrdersInner),
            ]),
            () => ListBuilder<MerchantOrdersDtoOutputOrdersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantOrdersDtoOutputOrdersInnerLinesInner),
            ]),
            () => ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantOrdersDtoOutputOrdersInnerLinesInner),
            ]),
            () => ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
              ),
            ]),
            () =>
                ListBuilder<
                  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantPickupDisputeDtoReceivedLinesInner),
            ]),
            () => ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantPickupDisputeDtoReceivedLinesInner),
            ]),
            () => ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantPickupDisputeDtoReceivedLinesInner),
            ]),
            () => ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantRejectDtoItemsInner),
            ]),
            () => ListBuilder<MerchantRejectDtoItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantRejectDtoItemsInner),
            ]),
            () => ListBuilder<MerchantRejectDtoItemsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantScheduleDtoPeriodsInner),
            ]),
            () => ListBuilder<MerchantScheduleDtoPeriodsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(RoleMatrixDtoOutputRolesInner),
            ]),
            () => ListBuilder<RoleMatrixDtoOutputRolesInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SenderPoolDtoOutputNumbersInner),
            ]),
            () => ListBuilder<SenderPoolDtoOutputNumbersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SenderPoolDtoOutputAlertsInner),
            ]),
            () => ListBuilder<SenderPoolDtoOutputAlertsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SettingEntryDtoOutputEditRolesEnum),
            ]),
            () => ListBuilder<SettingEntryDtoOutputEditRolesEnum>(),
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
              const FullType(TeamUsersDtoOutputUsersInnerOpenSessionsInner),
            ]),
            () => ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(TeamUsersDtoOutputUsersInner),
            ]),
            () => ListBuilder<TeamUsersDtoOutputUsersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
              ),
            ]),
            () =>
                ListBuilder<
                  CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
            () => ListBuilder<CaptainWentOfflineDtoOutputHandIn?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
            () => ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType(String),
            ]),
            () => MapBuilder<String, String>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
