// Flags.x
// Some flags may not work as expected, as simply enabling or disabling them may not be enough.

#import <Foundation/Foundation.h>

@interface YTReelPlayerViewController : NSObject
@end

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

// PiP hacks stuff
%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture { return EnablesPiP() ? YES : %orig; }
- (BOOL)isPipOffByDefault { return EnablesPiP() ? NO : %orig; }
- (BOOL)shouldPipResumeOnHead { return EnablesPiP() ? YES : %orig; }
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
- (BOOL)isPictureInPictureAllowed {
    if (DisablesShortsPiP()) {
        [self setValue:@(NO) forKey:@"_enablePlayerIsPictureInPictureAllowed"];
        return NO;
    }
    return %orig;
}
%end

%hook YTReelWatchRootViewController
- (void)switchToPictureInPicture { 
    if (DisablesShortsPiP()) {
        return;
    }
    %orig;
}
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
%end

%hook YTYouThereControllerImpl
- (BOOL)shouldShowYouTherePrompt { return HideAreYouThereDialog() ? NO : %orig; }
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
%end

// Prevent YouTube from showing you how to use the app
%hook GWACameraView
- (BOOL)shouldShowInstructions { return HideYouTubeEdu() ? NO : %orig; }
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
%hook YTPromotedVideoCellController
- (BOOL)shouldShowPromotedItems { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTShareMainView
- (BOOL)shouldShowPromo { return HideAdsBadges() ? NO : %orig; }
%end

%hook YCHLiveChatActionPanelView
- (BOOL)shouldShowUpsellButton { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTPromosheetContainerView
- (BOOL)shouldShowExpandButton { return HideAdsBadges() ? NO : %orig; }
%end

%hook YTUserDefaults
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
- (BOOL)hasAppPromoAdCtaRenderer { return HideAdsBadges() ? NO : %orig; }
%end

%ctor {
    if (!EnablesTweak()) return;
    %init;
}
