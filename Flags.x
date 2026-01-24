// Flags.x
// You can remove the comments flags "//" if you want to use the flags.
// Some flags may not work as expected, as simply enabling or disabling them may not be enough.

// Enables PiP, modifies the miniplayer, hide endscreens and tips
%hook YTColdConfig
- (BOOL)addPipMenuItem { return YES; }
- (BOOL)enablePipMenuItem { return YES; }
- (BOOL)androidDisablePipBackgroundButtonForPremium { return NO; }
- (BOOL)androidDisablePipForPremium { return NO; }
// - (BOOL)androidEnableShowSystemBedtimePromoHardcoded { return NO; }
- (BOOL)cxClientDisableMementoPromotions { return YES; }
- (BOOL)enableIosFloatingMiniplayer { return YES; }
- (BOOL)enableIosFloatingMiniplayerDoubleTapToResize { return NO; }
- (BOOL)enableIosFreeStableVolume { return YES; }
- (BOOL)enableIosLockMode { return YES; }
- (BOOL)enableIosLockModeFixes { return YES; }
- (BOOL)iosDisableCaptionsOnAppStartForVwc { return YES; }
- (BOOL)iosClientGlobalConfigEnableCaptionsAutoTranslationIosClient { return NO; }
- (BOOL)iosDisableCreatorEndscreenHitTestFix { return YES; }
- (BOOL)iosDisableEndscreenOnActivateVideo { return YES; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPicture { return NO; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureIos { return NO; }
- (BOOL)isPlaylistEntrypointUserEducationEnabled { return NO; }
- (BOOL)enableYouthereCommandsOnIos { return NO; }
%end

%hook YTHotConfig
- (BOOL)clientInfraClientConfigIosEnableFillingEncodedHacksInnertubeContext { return NO; }
- (BOOL)iosPlayerClientSharedConfigEnableResumeOnHeadForImmersiveLiveInPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigDefaultOffPremiumPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigDisableLockscreenControlsFromPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigSkipPipToggleOnStateChange { return NO; }
- (BOOL)iosPlayerClientSharedConfigTouchEarlyAccessPipSetting { return YES; }
- (BOOL)iosPlayerClientSharedConfigShowPipClingPromo { return NO; }
- (BOOL)livestreamClientConfigEnableCreationModesPromosTriggered { return NO; }
- (BOOL)liveConsumptionClientConfigIosImmersiveLivePreviewDisableEndscreen { return YES; }
- (BOOL)isAggressiveSwipeUserEducationEnabled { return NO; }
- (BOOL)shortsPlayerGlobalConfigAndroidDisableEducationOverlay { return YES; }
%end

// PiP hacks stuff
%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture { return YES; }
- (BOOL)isPipOffByDefault { return NO; }
- (BOOL)shouldPipResumeOnHead { return YES; }
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground { return YES; }
- (BOOL)isPlayableInPictureInPicture { return YES; }
%end

%hook YTBackgroundabilityPolicyImpl
- (BOOL)isPlayableInPictureInPictureByUserSettings { return YES; }
%end

// Try to disable Shorts PiP
%hook YTReelModel
- (BOOL)isPiPSupported { return NO; }
%end

%hook YTReelPlayerViewController
- (BOOL)isPictureInPictureAllowed { return NO; }
%end

// Allows background playback
%hook YTPlaybackData
- (BOOL)isPlayableInBackground { return YES; }
%end

%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground { return YES; }
- (BOOL)isMonetized { return NO; }
%end

// Prevent YouTube from asking "Are you there?"
%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt { return NO; }
%end

// Prevent YouTube from asking to update the app
%hook YTGlobalConfig
- (BOOL)shouldBlockUpgradeDialog { return YES; }
- (BOOL)shouldShowUpgradeDialog { return NO; }
- (BOOL)shouldShowUpgrade { return NO; }
- (BOOL)shouldForceUpgrade { return NO; }
%end

// Hide "Continue watching" section
// %hook YTCommuteShelfViewModel
// - (BOOL)shouldHideShelf { return YES; }
// %end

// Prevent YouTube from showing you how to use the app
%hook GWACameraView
- (BOOL)shouldShowInstructions { return NO; }
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

// Hide AI things
%hook YTShortsSharedGalleryPresentationView
- (BOOL)shouldShowAiMontageButton { return NO; }
%end

%hook YTShortsSharedGalleryPresentationViewController
- (BOOL)shouldShowAiMontageButton { return NO; }
%end

%hook YTMainAppVideoPlayerOverlayViewController
- (BOOL)shouldEnableScrubberSlideUserEducation { return NO; }
- (BOOL)shouldShowScrubUserEducation { return NO; }
- (BOOL)shouldShowFineScrubbingUserEdu { return NO; }
%end

%hook YTShortsUploadsTrimLayoutModel
- (BOOL)shouldDisplayTrimEducationLabel { return NO; }
%end

// %hook MDXSmartRemoteViewController
// - (BOOL)shouldShowPrivacyDialog { return NO; }
// %end

// %hook YTBedtimeReminderController
// - (BOOL)shouldShowBedtimeReminderAsPanel { return NO; }
// %end

// Hide ads
%hook YTPromotedVideoCellController
- (BOOL)shouldShowPromotedItems { return NO; }
%end

%hook SUPSupportContentService
- (BOOL)hasPromotedProductLinkClickCallback { return NO; }
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return NO; }
%end

%hook YTShareMainView
- (BOOL)shouldShowPromo { return NO; }
%end

%hook YCHLiveChatActionPanelView
- (BOOL)shouldShowUpsellButton { return NO; }
%end

%hook YTPromosheetContainerView
- (BOOL)isPromosheetDisplayed { return YES; }
- (BOOL)shouldShowExpandButton { return NO; }
%end

%hook GHKMainViewDataSource
- (BOOL)hasPromotedProductLinks { return NO; }
%end

%hook YTICompactPlaylistRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTICompactPromotedVideoRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTICompactRadioRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTICompactShowRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTICompactVideoRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridNarrowPlaylistRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridNarrowRadioRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridNarrowVideoRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridPlaylistRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridPromotedVideoRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridRadioRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridShowRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTIGridVideoRenderer
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTUserDefaults
- (BOOL)isPromoForced { return NO; }
- (BOOL)safeguardEducationSkipped { return YES; }
- (BOOL)didShowNewReelUserEducation { return YES; }
- (BOOL)hasPictureInPictureOnboardingHintShown { return YES; }
- (BOOL)shouldShowAddToLongPressHint { return NO; }
%end

%hook YTVideoSubtitleView
- (BOOL)shouldShowAdBadge { return NO; }
%end

%hook YTPostCreationDialogStateEntityModel
- (BOOL)hasisPromoDismissed { return YES; }
- (BOOL)isPromoDismissed { return YES; }
%end
