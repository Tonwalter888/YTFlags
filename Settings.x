// Settings.x
// Thanks to the original codes from YTUHD by PoomSmart - https://github.com/PoomSmart/YTUHD/blob/0e735616fd8fc6546339da7fdc78466f16f23ffd/Settings.x

#import <PSHeader/Misc.h>
#import <YouTubeHeader/YTSettingsGroupData.h>
#import <YouTubeHeader/YTSettingsPickerViewController.h>
#import <YouTubeHeader/YTSettingsSectionItem.h>
#import <YouTubeHeader/YTSettingsSectionItemManager.h>
#import <YouTubeHeader/YTSettingsViewController.h>

#define TweakName @"YTFlags"
#define TWEAK_VERSION 1.1.7

#define BedtimeKey @"IAmNotGonnaSleep"
#define WatchingKey @"NoWatchingShelf"
#define AllowsBackgroundPlaybackKey @"EnableBackgroundPlayback"
#define EnablesPiPKey @"AllowsPiP"
#define DisablesShortsPiPKey @"TryToDisablesShortsPiP"
#define BlockUpgradeDialogsKey @"StopYouTubeForcingToUpgrade"
#define HideAreYouThereDialogKey @"HideAnnoyingDialog"
#define HideAdsBadgesKey @"HideAds"
#define HideYouTubeEduKey @"HideYouTubeEducations"
#define FixSlowsMiniPlayerKey @"FixSlowsPlayer"
#define DisablesNewMiniPlayerKey @"DisablesNewStyleMiniPlayer"

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

static const NSInteger TweakSection = 'ytfl';

@interface YTSettingsSectionItemManager (YTFlags)
- (void)updateYTFlagsSectionWithEntry:(id)entry;
@end

BOOL AllowsBackgroundPlayback() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:AllowsBackgroundPlaybackKey];
}

BOOL EnablesPiP() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:EnablesPiPKey];
}

BOOL DisablesShortsPiP() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DisablesShortsPiPKey];
}

BOOL BlockUpgradeDialogs() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:BlockUpgradeDialogsKey];
}

BOOL HideAreYouThereDialog() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HideAreYouThereDialogKey];
}

BOOL HideAdsBadges() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HideAdsBadgesKey];
}

BOOL HideYouTubeEdu() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HideYouTubeEduKey];
}

BOOL FixSlowsMiniPlayer() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FixSlowsMiniPlayerKey];
}

BOOL DisablesNewMiniPlayer() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DisablesNewMiniPlayerKey];
}

BOOL Bedtime() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:BedtimeKey];
}

BOOL Watching() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:WatchingKey];
}

NSBundle *YTFlagsBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"YTFlags" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:tweakBundlePath ?: PS_ROOT_PATH_NS(@"/Library/Application Support/YTFlags.bundle")];
    });
    return bundle;
}

%hook YTSettingsGroupData

- (NSArray <NSNumber *> *)orderedCategories {
    if (self.type != 1 || class_getClassMethod(objc_getClass("YTSettingsGroupData"), @selector(tweaks)))
        return %orig;
    NSMutableArray *mutableCategories = %orig.mutableCopy;
    [mutableCategories insertObject:@(TweakSection) atIndex:0];
    return mutableCategories.copy;
}

%end

%hook YTAppSettingsPresentationData

+ (NSArray <NSNumber *> *)settingsCategoryOrder {
    NSArray <NSNumber *> *order = %orig;
    NSUInteger insertIndex = [order indexOfObject:@(1)];
    if (insertIndex != NSNotFound) {
        NSMutableArray <NSNumber *> *mutableOrder = [order mutableCopy];
        [mutableOrder insertObject:@(TweakSection) atIndex:insertIndex + 1];
        order = mutableOrder.copy;
    }
    return order;
}

%end

%hook YTSettingsSectionItemManager

%new(v@:@)
- (void)updateYTFlagsSectionWithEntry:(id)entry {
    NSMutableArray <YTSettingsSectionItem *> *sectionItems = [NSMutableArray array];
    NSBundle *tweakBundle = YTFlagsBundle();
    Class YTSettingsSectionItemClass = %c(YTSettingsSectionItem);
    YTSettingsViewController *settingsViewController = [self valueForKey:@"_settingsViewControllerDelegate"];

    // Tweak Version (at the top)
    // Thanks to the original codes from YTweaks by fosterbarnes - https://github.com/fosterbarnes/YTweaks/blob/e921591a89b87256a2b37c4788bd99282f70d9c2/Settings.x
    NSString *versionString = [NSString stringWithFormat:@"YTFlags v%s", TOSTRING(TWEAK_VERSION)];
    YTSettingsSectionItem *tweakVersion = [YTSettingsSectionItemClass itemWithTitle:versionString
        titleDescription:nil
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
            return NO;
        }];
    [sectionItems addObject:tweakVersion];

    // Allows Background Playback
    YTSettingsSectionItem *backgroundPlayback = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"ALLOWS_BACKGROUND_PLAYBACK")
        titleDescription:LOC(@"ALLOWS_BACKGROUND_PLAYBACK_DESC")
        accessibilityIdentifier:nil
        switchOn:AllowsBackgroundPlayback()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:AllowsBackgroundPlaybackKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:backgroundPlayback];

    // Enables PiP
    YTSettingsSectionItem *pip = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"ENABLES_PIP")
        titleDescription:LOC(@"ENABLES_PIP_DESC")
        accessibilityIdentifier:nil
        switchOn:EnablesPiP()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:EnablesPiPKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:pip];

    // Try to disable Shorts PiP
    YTSettingsSectionItem *shortsPiP = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"DISABLES_SHORTS_PIP")
        titleDescription:LOC(@"DISABLES_SHORTS_PIP_DESC")
        accessibilityIdentifier:nil
        switchOn:DisablesShortsPiP()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:DisablesShortsPiPKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:shortsPiP];

    // Block Upgrade Dialogs
    YTSettingsSectionItem *upgrade = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"BLOCK_UPGRADE_DIALOGS")
        titleDescription:LOC(@"BLOCK_UPGRADE_DIALOGS_DESC")
        accessibilityIdentifier:nil
        switchOn:BlockUpgradeDialogs()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:BlockUpgradeDialogsKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:upgrade];

    // Hide "Are you there?" dialog
    YTSettingsSectionItem *areyouthere = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"ARE_YOU_THERE_DIALOG")
        titleDescription:LOC(@"ARE_YOU_THERE_DIALOG_DESC")
        accessibilityIdentifier:nil
        switchOn:HideAreYouThereDialog()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:HideAreYouThereDialogKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:areyouthere];

    // Hide Ads Badges
    YTSettingsSectionItem *ads = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"HIDE_ADS_BADGES")
        titleDescription:LOC(@"HIDE_ADS_BADGES_DESC")
        accessibilityIdentifier:nil
        switchOn:HideAdsBadges()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:HideAdsBadgesKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:ads];

    // Hide YouTube Educations
    YTSettingsSectionItem *edu = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"HIDE_YOUTUBE_EDU")
        titleDescription:LOC(@"HIDE_YOUTUBE_EDU_DESC")
        accessibilityIdentifier:nil
        switchOn:HideYouTubeEdu()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:HideYouTubeEduKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:edu];

    // Fix Slows Miniplayer
    YTSettingsSectionItem *slowsminiplayer = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"FIX_SLOWS_MINIPLAYER")
        titleDescription:LOC(@"FIX_SLOWS_MINIPLAYER_DESC")
        accessibilityIdentifier:nil
        switchOn:FixSlowsMiniPlayer()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:FixSlowsMiniPlayerKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:slowsminiplayer];

    // Disables New Miniplayer
    YTSettingsSectionItem *newminiplayer = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"DISABLES_NEW_MINIPLAYER")
        titleDescription:LOC(@"DISABLES_NEW_MINIPLAYER_DESC")
        accessibilityIdentifier:nil
        switchOn:DisablesNewMiniPlayer()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:DisablesNewMiniPlayerKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:newminiplayer];

    // Hide "Continue Watching" section in feeds
    YTSettingsSectionItem *watching = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"WATCHING")
        titleDescription:LOC(@"WATCHING_DESC")
        accessibilityIdentifier:nil
        switchOn:Watching()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:WatchingKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:watching];

    // Hide Bedtime Reminders
    YTSettingsSectionItem *bedtime = [YTSettingsSectionItemClass switchItemWithTitle:LOC(@"BEDTIME")
        titleDescription:LOC(@"BEDTIME_DESC")
        accessibilityIdentifier:nil
        switchOn:Bedtime()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:BedtimeKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:bedtime];

    if ([settingsViewController respondsToSelector:@selector(setSectionItems:forCategory:title:icon:titleDescription:headerHidden:)]) {
        YTIIcon *icon = [%c(YTIIcon) new];
        icon.iconType = YT_SETTINGS;
        [settingsViewController setSectionItems:sectionItems forCategory:TweakSection title:TweakName icon:icon titleDescription:nil headerHidden:NO];
    } else
        [settingsViewController setSectionItems:sectionItems forCategory:TweakSection title:TweakName titleDescription:nil headerHidden:NO];
}

- (void)updateSectionForCategory:(NSUInteger)category withEntry:(id)entry {
    if (category == TweakSection) {
        [self updateYTFlagsSectionWithEntry:entry];
        return;
    }
    %orig;
}

%end
