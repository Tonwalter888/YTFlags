// Flags.x
// You can remove the comments flags "//" if you want to use the flags.
// Some flags may not work as expected, as simply enabling or disabling them may not be enough.

#import <Foundation/Foundation.h>

extern BOOL EnablesTweak();
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
- (BOOL)addPipMenuItem { return EnablesPiP(); }
- (BOOL)enablePipMenuItem { return EnablesPiP(); }
- (BOOL)androidDisablePipBackgroundButtonForPremium { return !EnablesPiP(); }
- (BOOL)androidDisablePipForPremium { return !EnablesPiP(); }
// - (BOOL)androidEnableShowSystemBedtimePromoHardcoded { return NO; }
- (BOOL)cxClientDisableMementoPromotions { return HideAdsBadges(); }
- (BOOL)enableIosFloatingMiniplayer { return !DisablesNewMiniPlayer(); }
- (BOOL)enableIosFloatingMiniplayerDoubleTapToResize { return !FixSlowsMiniPlayer(); }
- (BOOL)enableIosFreeStableVolume { return YES; }
- (BOOL)enableIosLockMode { return YES; }
- (BOOL)enableIosLockModeFixes { return YES; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPicture { return !EnablesPiP(); }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureIos { return !EnablesPiP(); }
- (BOOL)isPlaylistEntrypointUserEducationEnabled { return !HideYouTubeEdu(); }
- (BOOL)enableYouthereCommandsOnIos { return !HideAreYouThereDialog(); }
%end

%hook YTHotConfig
- (BOOL)clientInfraClientConfigIosEnableFillingEncodedHacksInnertubeContext { return NO; }
- (BOOL)iosPlayerClientSharedConfigEnableResumeOnHeadForImmersiveLiveInPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigDefaultOffPremiumPip { return !EnablesPiP(); }
- (BOOL)iosPlayerClientSharedConfigDisableLockscreenControlsFromPip { return !EnablesPiP(); }
- (BOOL)iosPlayerClientSharedConfigSkipPipToggleOnStateChange { return !EnablesPiP(); }
- (BOOL)iosPlayerClientSharedConfigTouchEarlyAccessPipSetting { return EnablesPiP(); }
- (BOOL)iosPlayerClientSharedConfigShowPipClingPromo { return NO; }
- (BOOL)livestreamClientConfigEnableCreationModesPromosTriggered { return !HideAdsBadges(); }
- (BOOL)isAggressiveSwipeUserEducationEnabled { return !HideYouTubeEdu(); }
- (BOOL)shortsPlayerGlobalConfigAndroidDisableEducationOverlay { return HideYouTubeEdu(); }
%end

// PiP hacks stuff
%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture { return EnablesPiP(); }
- (BOOL)isPipOffByDefault { return !EnablesPiP(); }
- (BOOL)shouldPipResumeOnHead { return YES; }
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground { return AllowsBackgroundPlayback(); }
- (BOOL)isPlayableInPictureInPicture { return EnablesPiP(); }
%end

// Try to disable Shorts PiP
%hook YTReelModel
- (BOOL)isPiPSupported { return !DisablesShortsPiP(); }
%end

%hook YTReelPlayerViewController
- (BOOL)isPictureInPictureAllowed { return !DisablesShortsPiP(); }
%end

// Allows background playback
%hook YTPlaybackData
- (BOOL)isPlayableInBackground { return AllowsBackgroundPlayback(); }
%end

%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground { return AllowsBackgroundPlayback(); }
- (BOOL)isMonetized { return NO; }
%end

// Prevent YouTube from asking "Are you there?"
%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt { return !HideAreYouThereDialog(); }
%end

// Prevent YouTube from asking to update the app
%hook YTGlobalConfig
- (BOOL)shouldBlockUpgradeDialog { return BlockUpgradeDialogs(); }
- (BOOL)shouldShowUpgradeDialog { return !BlockUpgradeDialogs(); }
- (BOOL)shouldShowUpgrade { return !BlockUpgradeDialogs(); }
- (BOOL)shouldForceUpgrade { return !BlockUpgradeDialogs(); }
%end

// Hide "Continue watching" section
// %hook YTCommuteShelfViewModel
// - (BOOL)shouldHideShelf { return YES; }
// %end

// Prevent YouTube from showing you how to use the app
%hook GWACameraView
- (BOOL)shouldShowInstructions { return !HideYouTubeEdu(); }
%end

%hook YTReelWatchEducationViewController
- (BOOL)isEducationAvailable { return !HideYouTubeEdu(); }
%end

%hook YTFormfillFormHeaderView
- (BOOL)shouldShowInstructions { return !HideYouTubeEdu(); }
%end

%hook YTInlineMutedPlaybackPlayerOverlayViewController
- (BOOL)shouldShowUserEducation { return !HideYouTubeEdu(); }
%end

%hook YTLCEntryRequirementsViewController
- (BOOL)shouldSkipIntroDialog { return HideYouTubeEdu(); }
%end

%hook YTInlineMutedPlaybackAudioIconView
- (BOOL)enableUserEducation { return !HideYouTubeEdu(); }
%end

%hook OGLEducationCappingServiceImpl
- (BOOL)shouldShowQuickSwipeApdEducation { return !HideYouTubeEdu(); }
%end

%hook YTNUXTooltipVisibility
- (BOOL)shouldShowTooltip { return !HideYouTubeEdu(); }
%end

%hook YTPostsQuizCollectionViewController
- (BOOL)shouldShowMarkAnswerTooltip { return !HideYouTubeEdu(); }
%end

// Hide AI things
%hook YTShortsSharedGalleryPresentationView
- (BOOL)shouldShowAiMontageButton { return !HideAdsBadges(); }
%end

%hook YTShortsSharedGalleryPresentationViewController
- (BOOL)shouldShowAiMontageButton { return !HideAdsBadges(); }
%end

%hook YTMainAppVideoPlayerOverlayViewController
- (BOOL)shouldEnableScrubberSlideUserEducation { return !HideYouTubeEdu(); }
- (BOOL)shouldShowScrubUserEducation { return !HideYouTubeEdu(); }
- (BOOL)shouldShowFineScrubbingUserEdu { return !HideYouTubeEdu(); }
%end

// %hook MDXSmartRemoteViewController
// - (BOOL)shouldShowPrivacyDialog { return NO; }
// %end

// %hook YTBedtimeReminderController
// - (BOOL)shouldShowBedtimeReminderAsPanel { return NO; }
// %end

// Hide ads
%hook YTPromotedVideoCellController
- (BOOL)shouldShowPromotedItems { return !HideAdsBadges(); }
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return !HideAdsBadges(); }
%end

%hook YTShareMainView
- (BOOL)shouldShowPromo { return !HideAdsBadges(); }
%end

%hook YCHLiveChatActionPanelView
- (BOOL)shouldShowUpsellButton { return !HideAdsBadges(); }
%end

%hook YTPromosheetContainerView
- (BOOL)shouldShowExpandButton { return !HideAdsBadges(); }
%end


%hook YTUserDefaults
- (BOOL)isPromoForced { return !HideAdsBadges(); }
- (BOOL)safeguardEducationSkipped { return HideYouTubeEdu(); }
- (BOOL)didShowNewReelUserEducation { return HideYouTubeEdu(); }
- (BOOL)hasPictureInPictureOnboardingHintShown { return HideYouTubeEdu(); }
- (BOOL)shouldShowAddToLongPressHint { return !HideYouTubeEdu(); }
%end

%hook YTSettings
- (BOOL)hasPictureInPictureOnboardingHintShown { return HideYouTubeEdu(); }
%end

%hook YTVideoSubtitleView
- (BOOL)shouldShowAdBadge { return !HideAdsBadges(); }
%end

%hook YTPostCreationDialogStateEntityModel
- (BOOL)hasisPromoDismissed { return HideAdsBadges(); }
- (BOOL)isPromoDismissed { return HideAdsBadges(); }
%end

%ctor {
    if (!EnablesTweak()) return;
}