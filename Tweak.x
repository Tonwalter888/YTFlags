// Tweak.x
// You can remove the comments flags "//" if you want to use the flags.
// Some flags may not work as expected, as simply enabling or disabling them may not be enough.
// TODO: Group each feature and %ctor with %init().

// Enables PiP, modifies the miniplayer, hide endscreens and tips
%hook YTColdConfig
- (BOOL)addPipMenuItem { return YES; }
- (BOOL)enablePipMenuItem { return YES; }
- (BOOL)androidDisablePipBackgroundButtonForPremium { return NO; }
- (BOOL)androidDisablePipForPremium { return NO; }
// - (BOOL)androidEnableShowSystemBedtimePromoHardcoded { return NO; }
- (BOOL)cxClientDisableMementoPromotions { return YES; }
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
- (BOOL)iosPlayerClientSharedConfigDefaultOffPremiumPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigDisableLockscreenControlsFromPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigEnableResumeOnHeadForImmersiveLiveInPip { return NO; }
- (BOOL)iosPlayerClientSharedConfigSkipPipToggleOnStateChange { return NO; }
- (BOOL)iosPlayerClientSharedConfigOffsetPipControllerTimeRangeWithSbdlCurrentTime { return NO; }
- (BOOL)iosPlayerClientSharedConfigTouchEarlyAccessPipSetting { return YES; }
- (BOOL)iosPlayerClientSharedConfigShowPipClingPromo { return NO; }
- (BOOL)livestreamClientConfigEnableCreationModesPromosTriggered { return NO; }
- (BOOL)liveConsumptionClientConfigIosImmersiveLivePreviewDisableEndscreen { return YES; }
- (BOOL)isAggressiveSwipeUserEducationEnabled { return NO; }
- (BOOL)shortsPlayerGlobalConfigAndroidDisableEducationOverlay { return YES; }
%end

// PiP hacks stuff
%hook YTPlayerViewController
- (BOOL)isPictureInPicturePossible { return YES; }
%end

%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture { return YES; }
- (BOOL)isPipOffByDefault { return NO; }
- (BOOL)shouldPipResumeOnHead { return YES; }
%end

%hook MLPIPController
- (BOOL)pictureInPicturePossible { return YES; }
- (BOOL)pictureInPictureSupported { return YES; }
%end

// Bypass every restrictions
%hook YTIPlayabilityStatus
- (BOOL)isAgeCheckRequired { return NO; }
- (BOOL)isAgeVerificationRequired { return NO; }
- (BOOL)isContentCheckRequired { return NO; }
- (BOOL)isKoreanAgeVerificationRequired { return NO; }
- (BOOL)isConfirmationRequired { return NO; }
- (BOOL)isLoginRequired { return NO; }
- (BOOL)isPlayableInBackground { return YES; }
- (BOOL)isPlayableInPictureInPicture { return YES; }
%end

%hook YTLocalPlaybackController
- (BOOL)isPictureInPicturePossible { return YES; }
%end

%hook YTPlayerPIPController
- (BOOL)isPictureInPicturePossible { return YES; }
- (BOOL)canEnablePictureInPicture { return YES; }
%end

%hook YTReelModel
- (BOOL)isPiPSupported { return NO; }
%end

%hook YTBackgroundabilityPolicyImpl
- (BOOL)isPlayableInPictureInPictureByUserSettings { return YES; }
%end

// Allows background playback
%hook HAMPlayer
- (BOOL)allowsBackgroundPlayback { return YES; }
%end

%hook MLVideo
- (BOOL)playableInBackground { return YES; }
%end

%hook YTPlaybackData
- (BOOL)isPlayableInBackground { return YES; }
%end

%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground { return YES; }
- (BOOL)isMonetized { return NO; }
%end

// Hide welcome screen
%hook FVRDefaultUIFlowController
- (BOOL)shouldSkipWelcome { return YES; }
%end

// Stop YouTube asking "Are you there?"
%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt { return NO; }
%end

// Hide YouTube Music button
%hook YTMusicButtonController
- (BOOL)shouldShowYoutubeMusicButton { return NO; }
%end

// Stop YouTube asking to update the app
%hook YTGlobalConfig
- (BOOL)shouldBlockUpgradeDialog { return YES; }
- (BOOL)shouldShowUpgradeDialog { return NO; }
- (BOOL)shouldShowUpgrade { return NO; }
- (BOOL)shouldForceUpgrade { return NO; }
%end

// Hide modern startup animations
%hook YTModernTransitions
- (BOOL)isPlayablesLaunchAnimationEnabled { return NO; }
%end

// Hide endscreens
%hook YTCreatorEndscreenToggleButton
- (BOOL)shouldHideEndScreen { return YES; }
%end

%hook YTCreatorEndscreenViewController
- (BOOL)endscreenActivated { return NO; }
%end

%hook YTAutonavEndscreenController
- (BOOL)shouldShowEndscreen { return NO; }
- (BOOL)isEndscreenReady { return NO; }
- (BOOL)isEndscreenActivated { return NO; }
%end

%hook YTFeaturePlayerOverlayStateEntityModel
- (BOOL)hasIsEndscreenOverlayVisible { return NO; }
- (BOOL)isEndscreenOverlayVisible { return NO; }
%end

%hook YTWatchStateController
- (BOOL)isEndscreenOverlayVisible { return NO; }
%end

// Hide captions
%hook YTInlineMutedPlaybackOverlayStatusUpdate
- (BOOL)shouldHideCaptions { return YES; }
%end

%hook YTInlineMutedPlaybackOverlayView
- (BOOL)captionsHidden { return YES; }
%end

%hook YTInlineMutedPlaybackStateController
- (BOOL)inlinePlaybackCaptionHidden { return YES; }
- (BOOL)inlinePlaybackCaptionHiddenOnStartEnabled { return YES; }
%end

%hook YTInlineMutedPlaybackWatchController
- (BOOL)shouldHideCaptionsOnAppStart { return YES; }
- (BOOL)shouldHideCaptionsOnPlaybackStart { return YES; }
- (BOOL)shouldTriggerIMPUserEducationIfNeeded { return NO; }
%end

// Hide snackbars
%hook YTReelWatchRootViewController
- (BOOL)shouldHideSnackbarsOnScroll { return YES; }
%end

// Stop YouTube teaching you how to use the app
%hook GWACameraView
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

%hook YTMainAppVideoPlayerOverlayViewController
- (BOOL)shouldEnableScrubberSlideUserEducation { return NO; }
- (BOOL)shouldShowScrubUserEducation { return NO; }
%end

%hook YTShortsUploadsTrimLayoutModel
- (BOOL)shouldDisplayTrimEducationLabel { return NO; }
%end

// %hook MDXSmartRemoteViewController
// - (BOOL)shouldShowPrivacyDialog { return NO; }
// %end
// 
// %hook YTBedtimeReminderController
// - (BOOL)shouldShowBedtimeReminderAsPanel { return NO; }
// %end

// Hide ads
%hook YTPromotedVideoCellController
- (BOOL)shouldShowPromotedItems { return NO; }
%end

%hook MDXCurrentlyPlayingViewController
- (BOOL)isAdShowing { return NO; }
%end

%hook YTAdStateDuringClipCreationEntityModel
- (BOOL)hasAdShowing { return NO; }
%end

%hook YTPostAdStateEntityModel
- (BOOL)hasAdShowing { return NO; }
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
- (BOOL)isPromosheetDisplayed { return NO; }
%end

%hook GHKMainViewDataSource
- (BOOL)hasPromotedProductLinks { return NO; }
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

%end
