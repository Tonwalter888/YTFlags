// Tweak.x
// Some flags may not work as expected, as simply enabling or disabling them may not be enough.
// TODO - Adjust codes to make it easier to read and modify.

#import <Foundation/Foundation.h>
#import <YouTubeHeader/_ASDisplayView.h>
#import <YouTubeHeader/YTIElementRenderer.h>
#import <YouTubeHeader/YTInnerTubeCollectionViewController.h>
#import <YouTubeHeader/YTISectionListRenderer.h>
#import <YouTubeHeader/YTIShelfRenderer.h>
#import <YouTubeHeader/YTIWatchNextResponse.h>
#import <YouTubeHeader/YTPlayerOverlay.h>
#import <YouTubeHeader/YTPlayerOverlayProvider.h>
#import <YouTubeHeader/YTReelModel.h>
#import <YouTubeHeader/YTIShowFullscreenInterstitialCommand.h>

extern BOOL EnablesTweak();
extern BOOL Bedtime();
extern BOOL Watching();
extern BOOL AllowsBackgroundPlayback();
extern BOOL EnablesPiP();
extern BOOL DisablesShortsPiP();
extern BOOL BlockUpgradeDialogs();
extern BOOL HideAreYouThereDialog();
extern BOOL HideAdsBadges();
extern BOOL HideYouTubeEdu();
extern BOOL FixSlowsMiniPlayer();
extern BOOL DisablesNewMiniPlayer();
extern BOOL SnackBar();
extern BOOL VideoAds();

static BOOL isProductList(YTICommand *command) {
    if ([command respondsToSelector:@selector(yt_showEngagementPanelEndpoint)]) {
        YTIShowEngagementPanelEndpoint *endpoint = [command yt_showEngagementPanelEndpoint];
        return [endpoint.identifier.tag isEqualToString:@"PAproduct_list"];
    }
    return NO;
}

NSString *getAdString(NSString *description) {
    for (NSString *str in @[
        @"brand_promo",
        @"carousel_footered_layout",
        @"carousel_headered_layout",
        @"eml.expandable_metadata",
        @"feed_ad_metadata",
        @"full_width_portrait_image_layout",
        @"full_width_square_image_layout",
        @"landscape_image_wide_button_layout",
        @"post_shelf",
        @"product_carousel",
        @"product_engagement_panel",
        @"product_item",
        @"shopping_carousel",
        @"shopping_item_card_list",
        @"statement_banner",
        @"square_image_layout",
        @"text_image_button_layout",
        @"text_search_ad",
        @"video_display_full_layout",
        @"video_display_full_buttoned_layout"
    ])
        if ([description containsString:str]) return str;
    return nil;
}

static BOOL isAdRenderer(YTIElementRenderer *elementRenderer, int kind) {
    if ([elementRenderer respondsToSelector:@selector(hasCompatibilityOptions)] && elementRenderer.hasCompatibilityOptions && elementRenderer.compatibilityOptions.hasAdLoggingData) {
        return YES;
    }
    NSString *description = [elementRenderer description];
    NSString *adString = getAdString(description);
    if (adString) {
        return YES;
    }
    return NO;
}

static NSMutableArray <YTIItemSectionRenderer *> *filteredArray(NSArray <YTIItemSectionRenderer *> *array) {
    NSMutableArray <YTIItemSectionRenderer *> *newArray = [array mutableCopy];
    NSIndexSet *removeIndexes = [newArray indexesOfObjectsPassingTest:^BOOL(YTIItemSectionRenderer *sectionRenderer, NSUInteger idx, BOOL *stop) {
        if ([sectionRenderer isKindOfClass:%c(YTIShelfRenderer)]) {
            YTIShelfSupportedRenderers *content = ((YTIShelfRenderer *)sectionRenderer).content;
            YTIHorizontalListRenderer *horizontalListRenderer = content.horizontalListRenderer;
            NSMutableArray <YTIHorizontalListSupportedRenderers *> *itemsArray = horizontalListRenderer.itemsArray;
            NSIndexSet *removeItemsArrayIndexes = [itemsArray indexesOfObjectsPassingTest:^BOOL(YTIHorizontalListSupportedRenderers *horizontalListSupportedRenderers, NSUInteger idx2, BOOL *stop2) {
                YTIElementRenderer *elementRenderer = horizontalListSupportedRenderers.elementRenderer;
                return isAdRenderer(elementRenderer, 4);
            }];
            [itemsArray removeObjectsAtIndexes:removeItemsArrayIndexes];
        }
        if (![sectionRenderer isKindOfClass:%c(YTIItemSectionRenderer)])
            return NO;
        NSMutableArray <YTIItemSectionSupportedRenderers *> *contentsArray = sectionRenderer.contentsArray;
        if (contentsArray.count > 1) {
            NSIndexSet *removeContentsArrayIndexes = [contentsArray indexesOfObjectsPassingTest:^BOOL(YTIItemSectionSupportedRenderers *sectionSupportedRenderers, NSUInteger idx2, BOOL *stop2) {
                YTIElementRenderer *elementRenderer = sectionSupportedRenderers.elementRenderer;
                return isAdRenderer(elementRenderer, 3);
            }];
            [contentsArray removeObjectsAtIndexes:removeContentsArrayIndexes];
        }
        YTIItemSectionSupportedRenderers *firstObject = [contentsArray firstObject];
        YTIElementRenderer *elementRenderer = firstObject.elementRenderer;
        return isAdRenderer(elementRenderer, 2);
    }];
    [newArray removeObjectsAtIndexes:removeIndexes];
    return newArray;
}

// Enables PiP, modifies the miniplayer, and hide tips
%hook YTColdConfig
- (BOOL)addPipMenuItem { return EnablesPiP() ? YES : %orig; }
- (BOOL)enablePipMenuItem { return EnablesPiP() ? YES : %orig; }
- (BOOL)androidDisablePipBackgroundButtonForPremium { return EnablesPiP() ? NO : %orig; }
- (BOOL)androidDisablePipForPremium { return EnablesPiP() ? NO : %orig; }
- (BOOL)androidEnableShowSystemBedtimePromoHardcoded { return Bedtime() ? NO : %orig; }
- (BOOL)cxClientDisableMementoPromotions { return HideAdsBadges() ? YES : %orig; }
- (BOOL)enableIosFloatingMiniplayer { return DisablesNewMiniPlayer() ? NO : %orig; }
- (BOOL)enableIosFloatingMiniplayerDoubleTapToResize { return FixSlowsMiniPlayer() ? NO : %orig; }
- (BOOL)enableIosFreeStableVolume { return YES; }
- (BOOL)enableIosLockMode { return YES; }
- (BOOL)enableIosLockModeFixes { return YES; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPicture { return DisablesShortsPiP() ? NO : %orig; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureIos { return DisablesShortsPiP() ? NO : %orig; }
- (BOOL)isPlaylistEntrypointUserEducationEnabled { return HideYouTubeEdu() ? NO : %orig; }
- (BOOL)enableYouthereCommandsOnIos { return HideAreYouThereDialog() ? NO : %orig; }
- (BOOL)immersiveWatchClientGlobalConfigIosEnableIwfEducationImpressionController { return HideYouTubeEdu() ? NO : %orig; }
- (BOOL)showPipStyleMiniplayer { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosClientGlobalConfigIosEnablePipNavigationFromPlayerViewController { return EnablesPiP() ? YES : %orig; }
%end

%hook YTColdConfigWatchPlayerClientGlobalConfigImpl
- (BOOL)enableIosFloatingMiniplayer { return DisablesNewMiniPlayer() ? NO : %orig; }
%end

%hook YTHotConfig
- (BOOL)clientInfraClientConfigIosEnableFillingEncodedHacksInnertubeContext { return NO; }
- (BOOL)iosPlayerClientSharedConfigEnableResumeOnHeadForImmersiveLiveInPip { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosPlayerClientSharedConfigEnableFullScreenAdsInPip { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosPlayerClientSharedConfigDefaultOffPremiumPip { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosPlayerClientSharedConfigDisableLockscreenControlsFromPip { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosPlayerClientSharedConfigSkipPipToggleOnStateChange { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosPlayerClientSharedConfigTouchEarlyAccessPipSetting { return EnablesPiP() ? YES : %orig; }
- (BOOL)iosPlayerClientSharedConfigOffsetPipControllerTimeRangeWithSbdlCurrentTime { return EnablesPiP() ? NO : %orig; }
- (BOOL)iosPlayerClientSharedConfigShowPipClingPromo { return HideAdsBadges() ? NO : %orig; }
- (BOOL)liveChatEnableEngagementPanelPromo { return HideAdsBadges() ? NO : %orig; }
- (BOOL)livestreamClientConfigEnableCreationModesPromosTriggered { return HideAdsBadges() ? NO : %orig; }
- (BOOL)isAggressiveSwipeUserEducationEnabled { return HideYouTubeEdu() ? NO : %orig; }
- (BOOL)shortsPlayerGlobalConfigAndroidDisableEducationOverlay { return HideYouTubeEdu() ? YES : %orig; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureAllowedFromPlayer { return DisablesShortsPiP() ? NO : %orig; }
%end

// Remove video ads
// YouTube-X - @PoomSmart https://github.com/PoomSmart/YouTube-X
%group VideoAds

%hook YTPlayerResponse
%new(@@:)
- (NSMutableArray *)playerAdsArray { return [NSMutableArray array]; }
%new(@@:)
- (NSMutableArray *)adSlotsArray { return [NSMutableArray array]; }
%end

%hook YTIClientMdxGlobalConfig
%new(B@:)
- (BOOL)enableSkippableAd { return YES; }
%end

%hook YTAdShieldUtils
+ (id)spamSignalsDictionary { return @{}; }
+ (id)spamSignalsDictionaryWithoutIDFA { return @{}; }
%end

%hook YTDataUtils
+ (id)spamSignalsDictionary { return @{ @"ms": @"" }; }
+ (id)spamSignalsDictionaryWithoutIDFA { return @{}; }
%end

%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)context { %orig(nil); }
%end

%hook YTAccountScopedAdsInnerTubeContextDecorator
- (void)decorateContext:(id)context { %orig(nil); }
%end

%hook YTLocalPlaybackController
- (id)createAdsPlaybackCoordinator { return nil; }
%end

%hook MDXSession
- (void)adPlaying:(id)ad {}
%end

%hook YTReelDataSource
- (YTReelModel *)makeContentModelForEntry:(id)entry {
    YTReelModel *model = %orig;
    if ([model respondsToSelector:@selector(videoType)] && model.videoType == 3)
        return nil;
    return model;
}
%end

%hook YTReelInfinitePlaybackDataSource
- (YTReelModel *)makeContentModelForEntry:(id)entry {
    YTReelModel *model = %orig;
    if ([model respondsToSelector:@selector(videoType)] && model.videoType == 3)
        return nil;
    return model;
}
- (void)setReels:(NSMutableOrderedSet <YTReelModel *> *)reels {
    [reels removeObjectsAtIndexes:[reels indexesOfObjectsPassingTest:^BOOL(YTReelModel *obj, NSUInteger idx, BOOL *stop) {
        return [obj respondsToSelector:@selector(videoType)] ? obj.videoType == 3 : NO;
    }]];
    %orig;
}
%end

%hook YTWatchNextResponseViewController
- (void)loadWithModel:(YTIWatchNextResponse *)model {
    YTICommand *onUiReady = model.onUiReady;
    if ([onUiReady respondsToSelector:@selector(yt_commandExecutorCommand)]) {
        YTICommandExecutorCommand *commandExecutorCommand = [onUiReady yt_commandExecutorCommand];
        NSMutableArray <YTICommand *> *commandsArray = commandExecutorCommand.commandsArray;
        [commandsArray removeObjectsAtIndexes:[commandsArray indexesOfObjectsPassingTest:^BOOL(YTICommand *command, NSUInteger idx, BOOL *stop) {
            return isProductList(command);
        }]];
    }
    if (isProductList(onUiReady))
        model.onUiReady = nil;
    %orig;
}
%end

%hook YTMainAppVideoPlayerOverlayViewController
- (void)playerOverlayProvider:(YTPlayerOverlayProvider *)provider didInsertPlayerOverlay:(YTPlayerOverlay *)overlay {
    if ([[overlay overlayIdentifier] isEqualToString:@"player_overlay_product_in_video"]) return;
    %orig;
}
%end

%hook _ASDisplayView
- (void)didMoveToWindow {
    %orig;
    if (([self.accessibilityIdentifier isEqualToString:@"eml.expandable_metadata.vpp"]))
        [self removeFromSuperview];
}
%end

%hook YTInnerTubeCollectionViewController
- (void)displaySectionsWithReloadingSectionControllerByRenderer:(id)renderer {
    NSMutableArray *sectionRenderers = [self valueForKey:@"_sectionRenderers"];
    [self setValue:filteredArray(sectionRenderers) forKey:@"_sectionRenderers"];
    %orig;
}
- (void)addSectionsFromArray:(NSArray <YTIItemSectionRenderer *> *)array {
    %orig(filteredArray(array));
}
%end
%end

// PiP hacks stuff
%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture { return EnablesPiP() ? YES : %orig; }
- (BOOL)isPipOffByDefault { return EnablesPiP() ? NO : %orig; }
- (BOOL)shouldPipResumeOnHead { return EnablesPiP() ? YES : %orig; }
%end

%group BackgroundPlayback
%hook YTIBackgroundOfflineSettingCategoryEntryRenderer
%new(B@:)
- (BOOL)isBackgroundEnabled { return YES; }
%end
%end

%hook MLVideo
- (BOOL)playableInBackground { return AllowsBackgroundPlayback() ? YES : %orig; }
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground { return AllowsBackgroundPlayback() ? YES : %orig; }
- (BOOL)isPlayableInPictureInPicture { return EnablesPiP() ? YES : %orig; }
%end

// Try to disable Shorts PiP
%hook YTReelModel
- (BOOL)isPiPSupported { return DisablesShortsPiP() ? NO : %orig; }
%end

%hook YTReelPlayerViewController
- (BOOL)isPictureInPictureAllowed { return DisablesShortsPiP() ? NO : %orig; }
// Hide first-time using Shorts (The "how to swipe" UI)
- (BOOL)isFirstTimeEduAvailable { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTReelWatchRootViewController
- (void)switchToPictureInPicture { if (!DisablesShortsPiP()) %orig; }
%end

// Allows background playback
%hook YTPlaybackData
- (BOOL)isPlayableInBackground { return AllowsBackgroundPlayback() ? YES : %orig; }
%end

%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground { return AllowsBackgroundPlayback() ? YES : %orig; }
- (BOOL)isMonetized { return HideAdsBadges() ? NO : %orig; }
%end

// Prevent YouTube from asking "Are you there?"
%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt { return HideAreYouThereDialog() ? NO : %orig; }
- (void)showYouTherePrompt { if (!HideAreYouThereDialog()) %orig; }
%end

%hook YTYouThereControllerImpl
- (BOOL)shouldShowYouTherePrompt { return HideAreYouThereDialog() ? NO : %orig; }
- (void)showYouTherePrompt { if (!HideAreYouThereDialog()) %orig; }
%end

// Disables Snackbar
%hook GOOHUDManagerInternal
- (id)sharedInstance { return SnackBar() ? nil : %orig; }
- (void)showMessageMainThread:(id)arg  { if (!SnackBar()) %orig; }
- (void)activateOverlay:(id)arg { if (!SnackBar()) %orig; }
- (void)displayHUDViewForMessage:(id)arg { if (!SnackBar()) %orig; }
%end

// Prevent YouTube from asking to update the app
%hook YTGlobalConfig
- (BOOL)shouldBlockUpgradeDialog { return BlockUpgradeDialogs() ? YES : %orig; }
- (BOOL)shouldShowUpgradeDialog { return BlockUpgradeDialogs() ? NO : %orig; }
- (BOOL)shouldShowUpgrade { return BlockUpgradeDialogs() ? NO : %orig; }
- (BOOL)shouldForceUpgrade { return BlockUpgradeDialogs() ? NO : %orig; }
%end

// Hide "Continue watching" section in feeds
%hook YTCommuteShelfViewModel
- (BOOL)shouldHideShelf { return Watching() ? YES : %orig; }
- (id)initWithModel:(id)arg { return Watching() ? nil : %orig; }
- (id)sectionRenderers { return Watching() ? nil : %orig; }
- (id)delegate { return Watching() ? nil : %orig; }
- (void)setDelegate:(id)arg { if (!Watching()) %orig; }
- (id)menu { return Watching() ? nil : %orig; }
%end

// Prevent YouTube from showing you how to use the app
%hook GWACameraView
- (BOOL)shouldShowInstructions { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTHintControllerImpl
- (void)sendPromoEventWithAccept:(BOOL)arg1 sendClick:(BOOL)arg2 { if (!HideAdsBadges()) %orig; }
%end

%hook YTHintController
- (void)sendPromoEventWithAccept:(BOOL)arg1 sendClick:(BOOL)arg2 { if (!HideAdsBadges()) %orig; }
%end

%hook YTReelWatchEducationViewController
- (BOOL)isEducationAvailable { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTFormfillFormHeaderView
- (BOOL)shouldShowInstructions { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTInlineMutedPlaybackPlayerOverlayViewController
- (BOOL)shouldShowUserEducation { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTLCEntryRequirementsViewController
- (BOOL)shouldSkipIntroDialog { return HideYouTubeEdu() ? YES : %orig; }
%end

%hook YTInlineMutedPlaybackAudioIconView
- (BOOL)enableUserEducation { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook OGLEducationCappingServiceImpl
- (BOOL)shouldShowQuickSwipeApdEducation { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTNUXTooltipVisibility
- (BOOL)shouldShowTooltip { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTPostsQuizCollectionViewController
- (BOOL)shouldShowMarkAnswerTooltip { return HideYouTubeEdu() ? NO : %orig; }
%end

// Hide AI things
%hook YTShortsSharedGalleryPresentationView
- (BOOL)shouldShowAiMontageButton { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTShortsSharedGalleryPresentationViewController
- (BOOL)shouldShowAiMontageButton { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTMainAppVideoPlayerOverlayViewController
- (BOOL)shouldEnableScrubberSlideUserEducation { return HideYouTubeEdu() ? NO : %orig; }
- (BOOL)shouldShowScrubUserEducation { return HideYouTubeEdu() ? NO : %orig; }
- (BOOL)shouldShowFineScrubbingUserEdu { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook MDXSmartRemoteViewController
- (BOOL)shouldShowPrivacyDialog { return HideYouTubeEdu() ? NO : %orig; }
%end

// Hide Bedtime Reminders
%hook YTBedtimeReminderController
- (BOOL)shouldShowBedtimeReminderAsPanel { return Bedtime() ? NO : %orig; }
%end

// Hide ads
// NoYTPremium - @PoomSmart https://github.com/PoomSmart/NoYTPremium
// Alert
%hook YTCommerceEventGroupHandler
- (void)addEventHandlers { if (!HideAdsBadges()) %orig; }
%end

// Full-screen
%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers { if (!HideAdsBadges()) %orig; }
%end

%hook YTPromosheetEventGroupHandler
- (void)addEventHandlers { if (!HideAdsBadges()) %orig; }
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return HideAdsBadges() ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return HideAdsBadges() ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTPromoThrottleControllerImpl
- (BOOL)canShowThrottledPromo { return HideAdsBadges() ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return HideAdsBadges() ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial {
    if (self.hasModalClientThrottlingRules && HideAdsBadges())
        self.modalClientThrottlingRules.oncePerTimeWindow = YES;
    return %orig;
}
%end

// "Try new features" in settings
%hook YTSettingsSectionItemManager
- (void)updatePremiumEarlyAccessSectionWithEntry:(id)arg1 { if (!HideAdsBadges()) %orig; }
%end

/* Hide settings section - Coming soon
%hook YTSettingsSectionItemManager
// Switch accounts
- (void)updateAccountSwitcherSectionWithEntry:(id)arg1 { if (!RemoveAccountSwitcher) %orig; }
- (void)updateAutoplaySectionWithEntry:(id)arg1
- (void)updateGamingThirdPartySectionWithEntry:(id)arg1
- (void)uupdateHelpSectionWithEntry:(id)arg1
- (void)updateHistoryAndPrivacySectionWithEntry:(id)arg1
- (void)updateHistorySectionWithEntry:(id)arg1
- (void)updateLanguagesSectionWithEntry:(id)arg1
- (void)updateLiveChatSectionWithEntry:(id)arg1
- (void)updateMainSectionWithEntry:(id)arg1
- (void)updateNotificationSectionWithEntry:(id)arg1
- (void)updateOfflineSectionWithEntry:(id)arg1
- (void)updateParentSettingsSectionWithEntry:(id)arg1
- (void)updatePlaybackSectionWithEntry:(id)arg1
- (void)updatePremiumEarlyAccessSectionWithEntry:(id)arg1 { if (!HideAdsBadges()) %orig; }
- (void)updatePrivacySectionWithEntry:(id)arg1
- (void)updateQualitySectionWithEntry:(id)arg1
- (void)updateSendFeedbackSectionWithEntry:(id)arg1
- (void)updateSmartDownloadsSectionWithEntry:(id)arg1
- (void)updateSubscriptionProductsSectionWithEntry:(id)arg1
- (void)updateTermsOfServiceSectionWithEntry:(id)arg1
- (void)updateTimeManagementSectionWithEntry:(id)arg1
// - (void)updateUnlimitedSectionWithEntry:(id)arg1
// - (void)updateUnpluggedSectionWithEntry:(id)arg1
- (void)updateVideoQualitySectionWithEntry:(id)arg1
- (void)updateYourDataSectionWithEntry:(id)arg1
%end
*/

// Survey
%hook YTSurveyController
- (void)showSurveyWithRenderer:(id)arg1 surveyParentResponder:(id)arg2 { if (!HideAdsBadges()) %orig; }
%end

%hook YTSurveyPromosheet
- (id)expandablePromosheetDelegate { return HideAdsBadges() ? nil : %orig; }
- (void)setExpandablePromosheetDelegate:(id)arg { if (!HideAdsBadges()) %orig; }
%end

%hook YTSPromotionServiceBlockImpl
- (BOOL)createPromotion:(id)arg1 writer:(id)arg2 error:(NSError **)arg3 { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTSPromotionServiceBlock
- (BOOL)createPromotion:(id)arg1 writer:(id)arg2 error:(NSError **)arg3 { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTPromosheetController
- (BOOL)canPresentPromosheetWithGlobalThrottling:(BOOL)arg1 customizedThrottling:(id)arg2 shouldReplacePromosheet:(BOOL)arg3 { return HideAdsBadges() ? NO : %orig; }
- (void)setCurrentPromosheet:(id)arg { if (!HideAdsBadges()) %orig; }
%end

%hook YTWatchSurveyTriggerController
- (id)initWithParentResponder:(id)arg1 promosheetController:(id)arg2 { return HideAdsBadges() ? nil : %orig; }
%end

%hook YTShareMainView
- (BOOL)shouldShowPromo { return HideAdsBadges() ? NO : %orig; }
- (void)setPromoView:(id)arg { if (!HideAdsBadges()) %orig; }
%end

%hook YCHLiveChatActionPanelView
- (BOOL)shouldShowUpsellButton { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTPromosheetContainerView
- (BOOL)shouldShowExpandButton { return HideAdsBadges() ? NO : %orig; }
- (void)setPromosheet:(id)arg { if (!HideAdsBadges()) %orig; }
- (void)setPromosheetDisplayed:(BOOL)arg { if (!HideAdsBadges()) %orig; }
- (void)setPromosheet:(id)arg1 animated:(BOOL)arg2 completion:(id)arg3 { if (!HideAdsBadges()) %orig; }
%end

%hook ELMPBShowBottomSheetCommand
- (void)showMealbarPromoWithContainerView:(id)arg1 handler:(id)arg2 { if (!HideAdsBadges()) %orig; }
%end

%hook YTAppMealbarPromoController
- (id)mealbarPromoController { return HideAdsBadges() ? nil : %orig; }
%end

%hook YTAppMealbarPromoControllerImpl
- (id)mealbarPromoController { return HideAdsBadges() ? nil : %orig; }
%end

%hook YTUserDefaults
- (BOOL)enablePromoDebugToast { return HideAdsBadges() ? NO : %orig; }
- (BOOL)isPromoForced { return HideAdsBadges() ? NO : %orig; }
- (BOOL)safeguardEducationSkipped { return HideYouTubeEdu() ? YES : %orig; }
- (BOOL)didShowNewReelUserEducation { return HideYouTubeEdu() ? YES : %orig; }
- (BOOL)hasPictureInPictureOnboardingHintShown { return HideYouTubeEdu() ? YES : %orig; }
- (BOOL)shouldShowAddToLongPressHint { return HideYouTubeEdu() ? NO : %orig; }
%end

%hook YTSettings
- (BOOL)hasPictureInPictureOnboardingHintShown { return HideYouTubeEdu() ? YES : %orig; }
%end

%hook YTVideoSubtitleView
- (BOOL)shouldShowAdBadge { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTPostCreationDialogStateEntityModel
- (BOOL)hasisPromoDismissed { return HideAdsBadges() ? YES : %orig; }
- (BOOL)isPromoDismissed { return HideAdsBadges() ? YES : %orig; }
%end

%hook YTIPlayerCompanionAdsSupportedRenderers
- (BOOL)hasAppPromoCompanionAdRenderer { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTIRenderer
- (id)appPromoAdCtaRenderer { return HideAdsBadges() ? nil : %orig; }
- (BOOL)hasAppPromoAdCtaRenderer { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTIInStreamPlayerCtaAdsSupportedRenderers
- (BOOL)hasAppPromoAdCtaRenderer { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTInterstitialPromoViewController
- (void)showInterstitialPromo:(id)arg1 enableClientImpressionThrottling:(BOOL)arg2 interstitialParentResponder:(id)arg3 { if (!HideAdsBadges()) %orig; }
- (void)showInterstitialPromo:(id)arg1 interstitialParentResponder:(id)arg2 { if (!HideAdsBadges()) %orig; }
%end

%hook YTMealbarPromoController
- (id)promoRenderer { return HideAdsBadges() ? nil : %orig; }
- (void)showMealbarPromoWithEvent:(id)arg { if (!HideAdsBadges()) %orig; }
%end

%hook YTOfflineButtonPromoController
- (void)showOfflinePromoWithRenderer:(id)arg1 endpoint:(id)arg2 parentResponder:(id)arg3 { if (!HideAdsBadges()) %orig; }
%end

%hook YTOfflineButtonPromoView
- (id)initWithFrame:(CGRect)arg1 renderer:(id)arg2 attributedView:(id)arg3 formattedStringLabelDelegate:(id)arg4 offlineButtonPromoDelegate:(id)arg5 { return HideAdsBadges() ? nil : %orig; }
%end

%hook YTWatchMiniBarControlsView
- (void)setTitle:(id)arg1 byline:(id)arg2 showingPaidPromotion:(BOOL)arg3 showingPremiumBadge:(BOOL)arg4 { if (!HideAdsBadges()) %orig; }
%end

%hook MDXFeatureFlags
- (BOOL)areMementoPromotionsEnabled { return HideAdsBadges() ? NO : %orig; }
%end

%ctor {
    if (!EnablesTweak()) return;
    %init;
    if (VideoAds()) {
        %init(VideoAds);
    }
    if (AllowsBackgroundPlayback()) {
        %init(BackgroundPlayback);
    }
}