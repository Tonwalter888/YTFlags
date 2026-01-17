// Tweak.x
// You can remove the comments flags "//" if you want to use the flags.
// Enables PiP
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
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPicture { return NO; }
- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureIos { return NO; }
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
%end

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

// Enables Background Playback
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

// Extras
%hook FVRDefaultUIFlowController
- (BOOL)shouldSkipWelcome { return YES; }
%end

%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt { return NO; }
%end

%hook YTMusicButtonController
- (BOOL)shouldShowYoutubeMusicButton { return NO; }
%end

%hook YTGlobalConfig
- (BOOL)shouldBlockUpgradeDialog { return YES; }
- (BOOL)shouldShowUpgradeDialog { return NO; }
- (BOOL)shouldShowUpgrade { return NO; }
- (BOOL)shouldForceUpgrade { return NO; }
%end

%hook YTCreatorEndscreenToggleButton
- (BOOL)shouldHideEndScreen { return YES; }
%end

%hook YTModernTransitions
- (BOOL)isPlayablesLaunchAnimationEnabled { return NO; }
%end

%hook YTInlineMutedPlaybackOverlayStatusUpdate
- (BOOL)shouldHideCaptions { return YES; }
%end

%hook YTInlineMutedPlaybackWatchController
- (BOOL)shouldHideCaptionsOnAppStart { return YES; }
- (BOOL)shouldHideCaptionsOnPlaybackStart { return YES; }
%end

%hook YTAutonavEndscreenController
- (BOOL)shouldShowEndscreen { return NO; }
%end

%hook YTReelWatchRootViewController
- (BOOL)shouldHideSnackbarsOnScrollshouldHideSnackbarsOnScroll { return YES; }
%end

%hook YTLCEntryRequirementsViewController
- (BOOL)shouldSkipIntroDialog { return YES; }
%end

%hook GTLRBatchQuery
- (BOOL)shouldSkipAuthorization { return YES; }
%end

%hook GTLRQuery
- (BOOL)shouldSkipAuthorization { return YES; }
%end

%hook YTActiveVideoNotifierImpl
- (BOOL)isActiveVideoPlayable { return YES; }
%end

%hook GWACameraView
- (BOOL)shouldShowInstructions { return NO; }
%end

%hook YTInlineMutedPlaybackPlayerOverlayViewController
- (BOOL)shouldShowUserEducation { return NO; }
%end

// Ads
%hook YTPromotedVideoCellController
- (BOOL)shouldShowPromotedItems { return NO; }
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

// %hook MDXSmartRemoteViewController
// - (BOOL)shouldShowPrivacyDialog { return NO; }
// %end
// 
// %hook YTBedtimeReminderController
// - (BOOL)shouldShowBedtimeReminderAsPanel { return NO; }
// %end
