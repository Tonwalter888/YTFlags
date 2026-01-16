// Tweak.x

// PiP

%hook YTColdConfig

- (BOOL)addPipMenuItem {
    return YES;
}

- (BOOL)enablePipMenuItem {
    return YES;
}

- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPicture {
    return NO;
}

- (BOOL)shortsPlayerGlobalConfigEnableReelsPictureInPictureIos {
    return NO;
}

%end

%hook YTHotConfig

- (BOOL)iosPlayerClientSharedConfigDefaultOffPremiumPip {
    return NO;
}

- (BOOL)iosPlayerClientSharedConfigDisableLockscreenControlsFromPip {
    return NO;
}

- (BOOL)iosPlayerClientSharedConfigEnableResumeOnHeadForImmersiveLiveInPip {
    return NO;
}

- (BOOL)iosPlayerClientSharedConfigOffsetPipControllerTimeRangeWithSbdlCurrentTime {
    return NO;
}

- (BOOL)iosPlayerClientSharedConfigTouchEarlyAccessPipSetting {
    return YES;
}

%end

%hook YTPlayerViewController

- (BOOL)isPictureInPicturePossible {
    return YES;
}

%end

%hook YTPlayerResponse

- (BOOL)isPipOffByDefault {
    return NO;
}

- (BOOL)shouldPipResumeOnHead {
    return YES;
}

%end

%hook MLPIPController

- (BOOL)pictureInPicturePossible {
    return YES;
}

- (BOOL)pictureInPictureSupported {
    return YES;
}

%end

%hook YTIPlayabilityStatus

- (BOOL)isPlayableInPictureInPicture {
    return YES;
}

%end

%hook YTLocalPlaybackController

- (BOOL)isPictureInPicturePossible {
    return YES;
}

%end

%hook YTPlayerPIPController

- (BOOL)isPictureInPicturePossible {
    return YES;
}

- (BOOL)canEnablePictureInPicture {
    return YES;
}

%end

%hook YTPlayerResponse

- (BOOL)isPlayableInPictureInPicture {
    return YES;
}

%end

%hook YTReelModel

- (BOOL)isPiPSupported {
    return NO;
}

%end

// Background Playback

%hook HAMPlayer

- (BOOL)allowsBackgroundPlayback {
    return YES;
}

%end

// Extras

%hook FVRDefaultUIFlowController

- (BOOL)shouldSkipWelcome {
    return YES;
}

%end

%hook YTYouThereController

- (BOOL)shouldShowYouTherePrompt {
    return NO;
}

%end

%hook YTMusicButtonController

- (BOOL)shouldShowYoutubeMusicButton {
    return NO;
}

%end

%hook YTShareMainView

- (BOOL)shouldShowPromo {
    return NO;
}

%end

%hook YTSlimOwnerCellController

- (BOOL)shouldShowHint: {
    return NO;
}

%end

%hook YTSlimVideoScrollableActionBarCellController

- (BOOL)shouldShowHint: {
    return NO;
}

%end

%hook YTGlobalConfig

- (BOOL)shouldBlockUpgradeDialog {
    return YES;
}

- (BOOL)shouldShowUpgradeDialog {
    return NO;
}

- (BOOL)shouldShowUpgrade {
    return NO;
}

%end

%hook YTCreatorEndscreenToggleButton

- (BOOL)shouldHideEndScreen {
    return YES;
}

%end

%hook YTPromotedVideoCellController

- (BOOL)shouldShowPromotedItems {
    return NO;
}

%end

%hook YTAutonavEndscreenController

- (BOOL)shouldShowEndscreen {
    return NO;
}

%end

%hook YTBedtimeReminderController

- (BOOL)shouldShowBedtimeReminderAsPanel {
    return NO;
}

%end

%hook YTReelWatchRootViewController

- (BOOL)shouldHideSnackbarsOnScrollshouldHideSnackbarsOnScroll {
    return YES;
}

%end

%hook YTLCEntryRequirementsViewController

- (BOOL)shouldSkipIntroDialog {
    return YES;
}

%end