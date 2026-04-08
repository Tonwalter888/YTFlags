// Tweak.x
// Some flags may not work as expected, as simply enabling or disabling them may not be enough.

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
extern BOOL AllowsBackgroundPlayback();
extern BOOL VideoAds();
extern BOOL EnablesPiP();
extern BOOL DisablesShortsPiP();
extern BOOL BlockUpgradeDialogs();
extern BOOL HideAreYouThereDialog();
extern BOOL HideAdsBadges();
extern BOOL HideYouTubeEdu();
extern BOOL FixesSlowMiniPlayer();
extern BOOL DisablesNewMiniPlayer();
extern BOOL Watching();
extern BOOL Bedtime();
extern BOOL SnackBar();

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

// Global hooks
%hook YTColdConfig
- (BOOL)enableIosFreeStableVolume { return YES; }
- (BOOL)enableIosLockMode { return YES; }
- (BOOL)enableIosLockModeFixes { return YES; }
%end

%hook YTHotConfig
- (BOOL)clientInfraClientConfigIosEnableFillingEncodedHacksInnertubeContext { return NO; }
%end

%group BackgroundPlayback
%hook YTIBackgroundOfflineSettingCategoryEntryRenderer
%new(B@:)
- (BOOL)isBackgroundEnabled { return YES; }
%end

%hook MLVideo
- (BOOL)playableInBackground { return YES; }
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground { return YES; }
%end

%hook YTPlaybackData
- (BOOL)isPlayableInBackground { return YES; }
%end

%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground { return YES; }
%end
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
- (void)decorateContext:(id)context {}
%end

%hook YTAccountScopedAdsInnerTubeContextDecorator
- (void)decorateContext:(id)context {}
%end

%hook YTIPlayerResponse
- (BOOL)isMonetized { return NO; }
%end

%hook YTLocalPlaybackController
- (id)createAdsPlaybackCoordinator { return nil; }
%end

%hook MDXSession
- (void)adPlaying:(id)ad {}
%end

%hook MDXSessionImpl
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

%group PiP
%hook YTColdConfig
- (BOOL)addPipMenuItem { return YES; }
- (BOOL)enablePipMenuItem { return YES; }
- (BOOL)androidDisablePipBackgroundButtonForPremium { return NO; }
- (BOOL)androidDisablePipForPremium { return NO; }
- (BOOL)showPipStyleMiniplayer { return NO; }
- (BOOL)iosClientGlobalConfigIosEnablePipNavigationFromPlayerViewController { return YES; }
%end

%hook YTHotConfig
- (BOOL)iosPlayerClientSharedConfigEnableResumeOnHeadForImmersiveLiveInPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigEnableFullScreenAdsInPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigDefaultOffPremiumPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigDisableLockscreenControlsFromPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigSkipPipToggleOnStateChange { return NO; }
- (BOOL)iosPlayerClientSharedConfigTouchEarlyAccessPipSetting { return YES; }
- (BOOL)iosPlayerClientSharedConfigOffsetPipControllerTimeRangeWithSbdlCurrentTime { return NO; }
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInPictureInPicture { return YES; }
%end

%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture { return YES; }
- (BOOL)isPipOffByDefault { return NO; }
- (BOOL)shouldPipResumeOnHead { return YES; }
%end
%end

// Try to disable Shorts PiP
%group DisablesShortsPiP
%hook YTColdConfig
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPicture { return NO; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureIos { return NO; }
%end

%hook YTHotConfig
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureAllowedFromPlayer { return NO; }
%end

%hook YTReelModel
- (BOOL)isPiPSupported { return NO; }
%end

%hook YTReelPlayerViewController
- (BOOL)isPictureInPictureAllowed { return NO; }
%end

%hook YTReelWatchRootViewController
- (void)switchToPictureInPicture {}
%end
%end

// Prevent YouTube from asking to update the app
%group Upgrade
%hook YTGlobalConfig
- (BOOL)shouldBlockUpgradeDialog { return YES; }
- (BOOL)shouldShowUpgradeDialog { return NO; }
- (BOOL)shouldShowUpgrade { return NO; }
- (BOOL)shouldForceUpgrade { return NO; }
%end
%end

// Prevent YouTube from asking "Are you there?"
%group AreYouThere
%hook YTColdConfig
- (BOOL)enableYouthereCommandsOnIos { return NO; }
%end

%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt { return NO; }
- (void)showYouTherePrompt {}
%end

%hook YTYouThereControllerImpl
- (BOOL)shouldShowYouTherePrompt { return NO; }
- (void)showYouTherePrompt {}
%end
%end

%group AdsBadges
%hook YTColdConfig
- (BOOL)cxClientDisableMementoPromotions { return YES; }
%end

%hook YTHotConfig
- (BOOL)iosPlayerClientSharedConfigShowPipClingPromo { return NO; }
- (BOOL)liveChatEnableEngagementPanelPromo { return NO; }
- (BOOL)livestreamClientConfigEnableCreationModesPromosTriggered { return NO; }
%end

// NoYTPremium - @PoomSmart https://github.com/PoomSmart/NoYTPremium
// Alert
%hook YTCommerceEventGroupHandler
- (void)addEventHandlers {}
%end

// Full-screen
%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTPromosheetEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return NO; }
%end

%hook YTPromoThrottleControllerImpl
- (BOOL)canShowThrottledPromo { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return NO; }
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial {
    if (self.hasModalClientThrottlingRules)
        self.modalClientThrottlingRules.oncePerTimeWindow = YES;
    return %orig;
}
%end

// "Try new features" in settings
%hook YTSettingsSectionItemManager
- (void)updatePremiumEarlyAccessSectionWithEntry:(id)arg1 {}
%end

// Survey
%hook YTSurveyController
- (void)showSurveyWithRenderer:(id)arg1 surveyParentResponder:(id)arg2 {}
%end

// Hide AI things
%hook YTShortsSharedGalleryPresentationView
- (BOOL)shouldShowAiMontageButton { return NO; }
%end

%hook YTShortsSharedGalleryPresentationViewController
- (BOOL)shouldShowAiMontageButton { return NO; }
%end

%hook YTVideoSubtitleView
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIPlayerCompanionAdsSupportedRenderers
- (BOOL)hasAppPromoCompanionAdRenderer { return NO; }
%end

%hook YTIRenderer
- (id)appPromoAdCtaRenderer { return nil; }
- (BOOL)hasAppPromoAdCtaRenderer { return NO; }
%end

%hook YTIInStreamPlayerCtaAdsSupportedRenderers
- (BOOL)hasAppPromoAdCtaRenderer { return NO; }
%end

%hook YTInterstitialPromoViewController
- (void)showInterstitialPromo:(id)arg1 enableClientImpressionThrottling:(BOOL)arg2 interstitialParentResponder:(id)arg3 {}
- (void)showInterstitialPromo:(id)arg1 interstitialParentResponder:(id)arg2 {}
%end

%hook YTMealbarPromoController
- (id)promoRenderer { return nil; }
- (void)showMealbarPromoWithEvent:(id)arg {}
%end

%hook YTOfflineButtonPromoController
- (void)showOfflinePromoWithRenderer:(id)arg1 endpoint:(id)arg2 parentResponder:(id)arg3 {}
%end

%hook YTOfflineButtonPromoView
- (id)initWithFrame:(CGRect)arg1 renderer:(id)arg2 attributedView:(id)arg3 formattedStringLabelDelegate:(id)arg4 offlineButtonPromoDelegate:(id)arg5 { return nil; }
%end

%hook YTWatchMiniBarControlsView
- (void)setTitle:(id)arg1 byline:(id)arg2 showingPaidPromotion:(BOOL)arg3 showingPremiumBadge:(BOOL)arg4 {}
%end

%hook MDXFeatureFlags
- (BOOL)areMementoPromotionsEnabled { return NO; }
%end

%hook YTUserDefaults
- (BOOL)enablePromoDebugToast { return NO; }
- (BOOL)isPromoForced { return NO; }
%end

%hook YTAppMealbarPromoController
- (id)mealbarPromoController { return nil; }
%end

%hook YTAppMealbarPromoControllerImpl
- (id)mealbarPromoController { return nil; }
%end

%hook YTSurveyPromosheet
- (id)expandablePromosheetDelegate { return nil; }
- (void)setExpandablePromosheetDelegate:(id)arg {}
%end

%hook YTSPromotionServiceBlockImpl
- (BOOL)createPromotion:(id)arg1 writer:(id)arg2 error:(NSError **)arg3 { return NO; }
%end

%hook YTSPromotionServiceBlock
- (BOOL)createPromotion:(id)arg1 writer:(id)arg2 error:(NSError **)arg3 { return NO; }
%end

%hook YTPromosheetController
- (BOOL)canPresentPromosheetWithGlobalThrottling:(BOOL)arg1 customizedThrottling:(id)arg2 shouldReplacePromosheet:(BOOL)arg3 { return NO; }
- (void)setCurrentPromosheet:(id)arg {}
%end

%hook YTWatchSurveyTriggerController
- (id)initWithParentResponder:(id)arg1 promosheetController:(id)arg2 { return nil; }
%end

%hook YTShareMainView
- (BOOL)shouldShowPromo { return NO; }
- (void)setPromoView:(id)arg {}
%end

%hook YCHLiveChatActionPanelView
- (BOOL)shouldShowUpsellButton { return NO; }
%end

%hook YTPromosheetContainerView
- (BOOL)shouldShowExpandButton { return NO; }
- (void)setPromosheet:(id)arg {}
- (void)setPromosheetDisplayed:(BOOL)arg {}
- (void)setPromosheet:(id)arg1 animated:(BOOL)arg2 completion:(id)arg3 {}
%end

%hook ELMPBShowBottomSheetCommand
- (void)showMealbarPromoWithContainerView:(id)arg1 handler:(id)arg2 {}
%end
%end

// Prevent YouTube from showing you how to use the app
%group Edu
%hook YTReelPlayerViewController
// Hide first-time using Shorts (The "how to swipe" UI)
- (BOOL)isFirstTimeEduAvailable { return NO; }
%end

%hook GWACameraView
- (BOOL)shouldShowInstructions { return NO; }
%end

%hook YTHintControllerImpl
- (void)sendPromoEventWithAccept:(BOOL)arg1 sendClick:(BOOL)arg2 {}
%end

%hook YTHintController
- (void)sendPromoEventWithAccept:(BOOL)arg1 sendClick:(BOOL)arg2 {}
%end

%hook YTReelWatchEducationViewController
- (BOOL)isEducationAvailable { return NO; }
%end

%hook YTFormfillFormHeaderView
- (BOOL)shouldShowInstructions { return NO; }
%end

%hook YTInlineMutedPlaybackPlayerOverlayViewController
- (BOOL)shouldShowUserEducation { return NO; }
%end

%hook YTLCEntryRequirementsViewController
- (BOOL)shouldSkipIntroDialog { return YES; }
%end

%hook YTInlineMutedPlaybackAudioIconView
- (BOOL)enableUserEducation { return NO; }
%end

%hook OGLEducationCappingServiceImpl
- (BOOL)shouldShowQuickSwipeApdEducation { return NO; }
%end

%hook YTNUXTooltipVisibility
- (BOOL)shouldShowTooltip { return NO; }
%end

%hook YTPostsQuizCollectionViewController
- (BOOL)shouldShowMarkAnswerTooltip { return NO; }
%end

%hook YTMainAppVideoPlayerOverlayViewController
- (BOOL)shouldEnableScrubberSlideUserEducation { return NO; }
- (BOOL)shouldShowScrubUserEducation { return NO; }
- (BOOL)shouldShowFineScrubbingUserEdu { return NO; }
%end

%hook MDXSmartRemoteViewController
- (BOOL)shouldShowPrivacyDialog { return NO; }
%end

%hook YTUserDefaults
- (BOOL)safeguardEducationSkipped { return YES; }
- (BOOL)didShowNewReelUserEducation { return YES; }
- (BOOL)hasPictureInPictureOnboardingHintShown { return YES; }
- (BOOL)shouldShowAddToLongPressHint { return NO; }
%end

%hook YTSettings
- (BOOL)hasPictureInPictureOnboardingHintShown { return YES; }
%end

%hook YTHotConfig
- (BOOL)isAggressiveSwipeUserEducationEnabled { return NO; }
- (BOOL)shortsPlayerGlobalConfigAndroidDisableEducationOverlay { return YES; }
%end

%hook YTColdConfig
- (BOOL)isPlaylistEntrypointUserEducationEnabled { return NO; }
- (BOOL)immersiveWatchClientGlobalConfigIosEnableIwfEducationImpressionController { return NO; }
%end
%end

%group SlowMiniPlayer
%hook YTColdConfig
- (BOOL)enableIosFloatingMiniplayerDoubleTapToResize { return NO; }
%end
%end

%group OldMiniPlayer
%hook YTColdConfig
- (BOOL)enableIosFloatingMiniplayer { return NO; }
%end

%hook YTColdConfigWatchPlayerClientGlobalConfigImpl
- (BOOL)enableIosFloatingMiniplayer { return NO; }
%end
%end

// Hide "Continue watching" section in feeds
%group NoContinShelf
%hook YTCommuteShelfViewModel
- (BOOL)shouldHideShelf { return YES; }
- (id)initWithModel:(id)arg { return nil }
- (id)sectionRenderers { return nil; }
- (id)delegate { return nil; }
- (void)setDelegate:(id)arg {}
- (id)menu { return nil; }
%end
%end

// Hide Bedtime Reminders
%group Bedtime
%hook YTBedtimeReminderController
- (BOOL)shouldShowBedtimeReminderAsPanel { return NO; }
%end

%hook YTColdConfig
- (BOOL)androidEnableShowSystemBedtimePromoHardcoded { return NO; }
%end
%end

// Disables Snackbar
%group SnackBar
%hook GOOHUDManagerInternal
- (id)sharedInstance { return nil; }
- (void)showMessageMainThread:(id)arg {}
- (void)activateOverlay:(id)arg {}
- (void)displayHUDViewForMessage:(id)arg {}
%end
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
- (void)updatePremiumEarlyAccessSectionWithEntry:(id)arg1 {}
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

%ctor {
    if (!EnablesTweak()) return;
    %init;
    if (AllowsBackgroundPlayback()) {
        %init(BackgroundPlayback);
    }
    if (VideoAds()) {
        %init(VideoAds);
    }
    if (EnablesPiP()) {
        %init(PiP);
    }
    if (DisablesShortsPiP()) {
        %init(DisablesShortsPiP);
    }
    if (BlockUpgradeDialogs()) {
        %init(Upgrade);
    }
    if (HideAreYouThereDialog()) { 
        %init(AreYouThere);
    }
    if (HideAdsBadges()) {
        %init(AdsBadges);
    }
    if (HideYouTubeEdu()) {
        %init(Edu);
    }
    if (FixesSlowMiniPlayer()) {
        %init(SlowMiniPlayer);
    }
    if (DisablesNewMiniPlayer()) {
        %init(OldMiniPlayer);
    }
    if (Watching()) {
        %init(NoContinShelf);
    }
    if (Bedtime()) {
        %init(Bedtime);
    }
    if (SnackBar()) {
        %init(SnackBar);
    }
}