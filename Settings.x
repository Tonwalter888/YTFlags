// Settings.x
// Thanks to the original codes from YTUHD by PoomSmart - https://github.com/PoomSmart/YTUHD/blob/0e735616fd8fc6546339da7fdc78466f16f23ffd/Settings.x
// And Thanks to the original codes from YTweaks by fosterbarnes for the tweak header and tweak preferences logics - https://github.com/fosterbarnes/YTweaks/blob/9a6b4df48981d69e36feb774852e46c49dd31b32/Settings.x
#import <PSHeader/Misc.h>
#import <YouTubeHeader/YTSettingsGroupData.h>
#import <YouTubeHeader/YTSettingsPickerViewController.h>
#import <YouTubeHeader/YTSettingsSectionItem.h>
#import <YouTubeHeader/YTSettingsSectionItemManager.h>
#import <YouTubeHeader/YTSettingsViewController.h>
#import <YouTubeHeader/YTToastResponderEvent.h>
#import <YouTubeHeader/YTAlertView.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <UIKit/UIKit.h>

#define TweakName @"YTFlags"

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

#define LOC(x) [YTFlagsBundle() localizedStringForKey:x value:nil table:nil]
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

static const NSInteger TweakSection = 'ytfl';

@interface YTSettingsSectionItemManager (YTFlags) <UIDocumentPickerDelegate>
@property (nonatomic, assign) BOOL isImportingPreferencesForYTFlags;
- (void)updateYTFlagsSectionWithEntry:(id)entry;
- (void)exportPreferencesForYTFlags;
- (void)importPreferencesForYTFlags;
- (void)restoreDefaultsForYTFlags;
@end

NSUserDefaults *defaults;

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

%new
- (void)setIsImportingPreferencesForYTFlags:(BOOL)isImportingPreferencesForYTFlags {
    objc_setAssociatedObject(self, @selector(isImportingPreferencesForYTFlags), @(isImportingPreferencesForYTFlags), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (BOOL)isImportingPreferencesForYTFlags {
    return [objc_getAssociatedObject(self, @selector(isImportingPreferencesForYTFlags)) boolValue];
}

%new(v@:@)
- (void)updateYTFlagsSectionWithEntry:(id)entry {
    NSMutableArray <YTSettingsSectionItem *> *sectionItems = [NSMutableArray array];
    Class YTSettingsSectionItemClass = %c(YTSettingsSectionItem);
    YTSettingsViewController *settingsViewController = [self valueForKey:@"_settingsViewControllerDelegate"];

    // Tweak Version (at the top)
    YTSettingsSectionItem *tweakVersion = [YTSettingsSectionItemClass itemWithTitle:@"YTFlags v1.2.1"
        titleDescription:nil
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
            return NO;
        }];
    [sectionItems addObject:tweakVersion];

    // Preferences (Adapted from Gonerino by castdrian)
    YTSettingsSectionItem *preferences = [YTSettingsSectionItemClass itemWithTitle:@"\t"
        titleDescription:LOC(@"PREFERENCES")
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL(YTSettingsCell *cell, NSUInteger sectionItemIndex) {
            return NO;
        }];
    [sectionItems addObject:preferences];

    // Import preferences
    YTSettingsSectionItem *import = [YTSettingsSectionItemClass itemWithTitle:LOC(@"IMPORT")
        titleDescription:nil
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
            YTAlertView *alertView = [%c(YTAlertView) confirmationDialogWithAction:^{
                [self importPreferencesForYTFlags];
            }
            actionTitle:LOC(@"YES")
            cancelAction:^{}
            cancelTitle:LOC(@"CANCEL")];
            alertView.title = LOC(@"WARNING");
            alertView.subtitle = LOC(@"IMPORT_CONFIRM");
            [alertView show];
            return YES;
        }];
    [sectionItems addObject:import];

    // Export preferences
    YTSettingsSectionItem *export = [YTSettingsSectionItemClass itemWithTitle:LOC(@"EXPORT")
        titleDescription:nil
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
            [self exportPreferencesForYTFlags];
            return YES;
        }];
    [sectionItems addObject:export];

    // Restore defaults
    YTSettingsSectionItem *restore = [YTSettingsSectionItemClass itemWithTitle:LOC(@"RESTORE")
        titleDescription:nil
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
            YTAlertView *alertView = [%c(YTAlertView) confirmationDialogWithAction:^{
                [self restoreDefaultsForYTFlags];
            }
            actionTitle:LOC(@"YES")
            cancelAction:^{}
            cancelTitle:LOC(@"CANCEL")];
            alertView.title = LOC(@"WARNING");
            alertView.subtitle = LOC(@"RESTORE_CONFIRM");
            [alertView show];
            return YES;
        }];
    [sectionItems addObject:restore];

    // Features (Adapted from Gonerino by castdrian)
    YTSettingsSectionItem *features = [YTSettingsSectionItemClass itemWithTitle:@"\t"
        titleDescription:LOC(@"FEATURES")
        accessibilityIdentifier:nil
        detailTextBlock:nil
        selectBlock:^BOOL(YTSettingsCell *cell, NSUInteger sectionItemIndex) {
            return NO;
        }];
    [sectionItems addObject:features];

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
        icon.iconType = 52;
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

%new
- (void)exportPreferencesForYTFlags {
    // Get all preferences
    NSDictionary *prefs = [defaults dictionaryRepresentation];
    // Filter only YTFlags keys
    NSMutableDictionary *ytflagsPrefs = [NSMutableDictionary dictionary];
    for (NSString *key in prefs) {
        if ([key hasPrefix:@"IAmNotGonnaSleep"] ||
            [key hasPrefix:@"NoWatchingShelf"] ||
            [key hasPrefix:@"EnableBackgroundPlayback"] ||
            [key hasPrefix:@"AllowsPiP"] ||
            [key hasPrefix:@"TryToDisablesShortsPiP"] ||
            [key hasPrefix:@"StopYouTubeForcingToUpgrade"] ||
            [key hasPrefix:@"HideAnnoyingDialog"] ||
            [key hasPrefix:@"HideAds"] ||
            [key hasPrefix:@"HideYouTubeEducations"] ||
            [key hasPrefix:@"FixSlowsPlayer"] ||
            [key hasPrefix:@"DisablesNewStyleMiniPlayer"]) {
            ytflagsPrefs[key] = prefs[key]; 
        }
    }
    // Write to temp file
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"YTFlags_Preferences.plist"];
    [ytflagsPrefs writeToFile:tempPath atomically:YES];
    // Present document picker for save
    NSURL *fileURL = [NSURL fileURLWithPath:tempPath];
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForExportingURLs:@[fileURL]];
    picker.delegate = self;
    YTSettingsViewController *settingsVC = [self valueForKey:@"_dataDelegate"];
    [settingsVC presentViewController:picker animated:YES completion:nil];
}

%new
- (void)importPreferencesForYTFlags {
    self.isImportingPreferencesForYTFlags = YES;
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[
        [UTType typeWithIdentifier:@"public.xml"],
        [UTType typeWithIdentifier:@"com.apple.property-list"]
    ]];
    picker.delegate = self;
    picker.allowsMultipleSelection = NO;
    YTSettingsViewController *settingsVC = [self valueForKey:@"_dataDelegate"];
    [settingsVC presentViewController:picker animated:YES completion:nil];
}

%new
- (void)documentPickerForYTFlags:(UIDocumentPickerViewController *)controller 
    didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    // Only process for import operations, ignore export
    if (!self.isImportingPreferencesForYTFlags || urls.count == 0) return;
    NSURL *fileURL = urls[0];
    NSDictionary *importedPrefs = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    if (importedPrefs) {
        // Import preferences
        for (NSString *key in importedPrefs) {
            [defaults setObject:importedPrefs[key] forKey:key];
        }
        [defaults synchronize];
        // Show success message
        [[%c(YTToastResponderEvent) eventWithMessage:LOC(@"IMPORT_SUCCESS") firstResponder:[self parentResponder]] send];
    } else {
        [[%c(YTToastResponderEvent) eventWithMessage:LOC(@"IMPORT_FAILED") firstResponder:[self parentResponder]] send];
    }
    self.isImportingPreferencesForYTFlags = NO;
}

%new
- (void)restoreDefaultsForYTFlags {
    NSArray *keys = @[@"IAmNotGonnaSleep",
                      @"NoWatchingShelf",
                      @"EnableBackgroundPlayback",
                      @"AllowsPiP",
                      @"TryToDisablesShortsPiP",
                      @"StopYouTubeForcingToUpgrade",
                      @"HideAnnoyingDialog",
                      @"HideAds",
                      @"HideYouTubeEducations",
                      @"FixSlowsPlayer",
                      @"DisablesNewStyleMiniPlayer"];
    for (NSString *key in keys) {
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
}

%end

%ctor {
    defaults = [NSUserDefaults standardUserDefaults];
    %init;
}