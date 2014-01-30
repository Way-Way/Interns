//
//  WWConstants.h
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#ifndef __WWConstants_h__
#define __WWConstants_h__

////////////////////////////////////////////////////////////////////////////////
// Network
//#define WW_BASE_URL @"http://wayway-eu.herokuapp.com/api/v2/"
//#define WW_BASE_URL @"http://wayway-staging.herokuapp.com/api/v2/"
//#define WW_BASE_URL @"http://wayway-staging-1213.herokuapp.com/api/v2/"
#define WW_BASE_URL @"http://api2-eu.omblabs.org/api/v2/"

////////////////////////////////////////////////////////////////////////////////
// Notifications
#define WW_TRIGGER_SERVER_FETCH_NEXT_PAGE_NOTIFICATION @"WWTriggerServerFetchNextPageNotification"
#define WW_TRIGGER_SERVER_REFRESH_PLACE_PHOTO_NOTIFICATION @"WWTriggerServerRefreshPlacePhotoNotification"
#define WW_CURRENT_USER_UPDATED_NOTIFICATION @"WWCurrentUserUpdatedNotification"
#define WW_VIEW_PLACE_INFO_NOTIFICATION @"WWViewPlaceInfoNotification"
#define WW_VIEW_PHOTO_NOTIFICATION @"WWViewPhotoNotification"
#define WW_VIEW_PHOTOS_BY_HASH_TAG_NOTIFICATION @"WWViewPhotoByHashTagNotification"
#define WW_PUSH_NEW_HOME_VIEW_NOTIFICATION @"WWPushNewHomeViewNotification"
#define WW_VIEW_INTRO_SLIDES_NOTIFICATION @"WWViewIntroSlidesNotification"

#define WW_SWITCH_TO_HOME_CONTROLLER @"WWSwitchToHomeController"
#define WW_SWITCH_TO_LOGIN_CONTROLLER @"WWSwitchToLoginController"
#define WW_SWITCH_TO_SETTINGS_CONTROLLER @"WWSwitchToSettingsController"
#define WW_SWITCH_TO_SENDFEEDBACK_CONTROLLER @"WWSwitchToSendFeedbackController"
#define WW_SWITCH_TO_FAVORITES_CONTROLLER @"WWSwitchToFavoritesController"
#define WW_OPEN_LEFT_DRAWER_NOTIFICATION @"WWOpenLeftDrawerNotification"

////////////////////////////////////////////////////////////////////////////////
// Colors
#define WW_BLACK_FONT_COLOR         [UIColor uuColorFromHex:@"333333"]
#define WW_LIGHT_GRAY_FONT_COLOR    [UIColor uuColorFromHex:@"999999"]
#define WW_ORANGE_FONT_COLOR        [UIColor uuColorFromHex:@"F96020"]
#define WW_LIGHT_BLUE_COLOR         [UIColor uuColorFromHex:@"167EFB"]
#define WW_GREEN_BUTTON_COLOR       [UIColor uuColorFromHex:@"1CA817"]
#define WW_GRAY_BORDER              [UIColor uuColorFromHex:@"C2C2C2"]
#define WW_GRAY_BACKGROUND          [UIColor uuColorFromHex:@"EDEBF3"]
#define WW_HEADER_BACKGROUND_COLOR  [UIColor uuColorFromHex:@"F9F9F9"]
#define WW_LIGHT_GRAY_BUTTON_COLOR  [UIColor uuColorFromHex:@"AFB4B4"]
#define WW_NAV_GRAY_SEPARATOR_COLOR [UIColor uuColorFromHex:@"ABABAB"]
#define WW_FACEBOOK_BLUE_COLOR      [UIColor uuColorFromHex:@"385285"]

////////////////////////////////////////////////////////////////////////////////
// Fonts
#define WW_DEFAULT_FONT_NAME            @"Bariol-Regular"
#define WW_DEFAULT_BOLD_FONT_NAME       @"Bariol-Bold"

#define WW_HEADING_FONT_SIZE    20
#define WW_SUB_LABEL_FONT_SIZE  14

////////////////////////////////////////////////////////////////////////////////
// Constants
#define WW_DEFAULT_SEARCH_RADIUS 600
#define WW_DEFAULT_MAP_PIN_COUNT 8
#define WW_REGION_LOC_THRESHOLD 30.0f
#define WW_REGION_DELTA_THRESHOLD 0.001f
#define WW_KEYBOARD_ADJUST_TRANSITION_DURATION 0.3f
#define WW_SLIDE_TRANSITION_DURATION 0.5f
#define WW_SEARCH_DELAY 0.5f
#define WW_DEFAULT_SEARCH_ICON_DIM 12.5
#define WW_WAY_WAY_SEARCH_ICON_DIM 18
#define WW_APP_STORE_URL @"https://itunes.apple.com/app/wayway-discover-places-everybody/id694189318?mt=8"

//Multi-language words
#define WW_CURRENT_LOCATION @"Choose Location"
#define WW_FILTER @"Filter"
#define WW_COUNT_FILTERS @"filters"
#define WW_LIST @"List"
#define WW_SEARCH @"Search"
#define WW_FIND_PLACES @"Find Places"
#define WW_FAVORITES @"Favorites"
#define WW_SETTINGS @"Settings"
#define WW_TUTORIAL @"Tutorial"
#define WW_SEND_FEEDBACK @"Send Feedback"
#define WW_SIGN_IN @"Sign In"
#define WW_INVITE_FRIENDS @"Invite Friends"
#define WW_SIGN_IN_MESSAGE @"Signing in lets you save places and easily share them with your friends."

#define WW_CATEGORY_BARS_NIGHTLIFE @"bars & nightlife"
#define WW_CATEGORY_COFFEE_TEA @"coffee & tea"
#define WW_CATEGORY_SNACKS @"on the go"
#define WW_CATEGORY_RESTAURANTS @"restaurants"

////////////////////////////////////////////////////////////////////////////////
// Email Feedback
#define WW_EMAIL_FEEDBACK_TO        @"feedback@wayway.us"
#define WW_EMAIL_FEEDBACK_SUBJECT   @"Feedback"
#define WW_EMAIL_FEEDBACK_BODY      @"<html><body><br/><br/></body></html>"

////////////////////////////////////////////////////////////////////////////////
// Sharing
#define WW_SHARE_EMAIL_SUBJECT      @"Check out Way Way!"
#define WW_SHARE_EMAIL_BODY         @"<html><body><p>Way Way recommends restaurants and bars based on their popularity. Check it out: www.wayway.us</p></body></html>"
#define WW_SHARE_SMS_BODY           @"Way Way recommends restaurants and bars based on their popularity. Check it out: www.wayway.us"

////////////////////////////////////////////////////////////////////////////////
// Flurry

#define WW_FLURRY_EVENT_TAP_ON_SEARCH @"TapOnSearch"
// Tapping on the ‘Search’ bar to start a search

#define WW_FLURRY_EVENT_PERFORM_PLACE_SEARCH @"PlaceSearch"
// Searching for a place on the search bar

#define WW_FLURRY_EVENT_PERFORM_CATEGORY_SEARCH @"CategorySearch"
// Searching for a category on the search bar

#define WW_FLURRY_EVENT_PERFORM_HASHTAG_SEARCH @"HashtagSearch"
// Searching for a hashtag on the search bar

#define WW_FLURRY_EVENT_VIEW_LIST_RESULTS @"ListView"
// Seeing the results of a search on the List view

#define WW_FLURRY_EVENT_TAP_ON_RECENTER @"TapOnRecenter"
// Tap on the ‘recenter’ button

#define WW_FLURRY_EVENT_SCROLL_HALF_MAP @"ScrollingPlacesHalfMap"
// Scrolling places horizontally on the half-map

#define WW_FLURRY_EVENT_TAP_TOP_OF_HALF_MAP_TO_EXPAND @"HalfMapToPlaceTap"
// Tapping on top of the place’s name to get to the place view from the half-map view

#define WW_FLURRY_EVENT_TAP_ON_FILTER @"TapOnFilter"
// Tapping on the ‘filter’ button

#define WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_LOCATION @"SelectLocation"
// Once on Filter, select location

#define WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_PRICE @"SelectPrice"
// Once on filter, select price

#define WW_FLURRY_EVENT_TAP_ON_FILTER_OPEN_NOW @"SelectOpenNow"
// Once on filter, select OpeNow

#define WW_FLURRY_EVENT_TAP_ON_FILTER_TRENDING @"SelectTrending"
// Once on Filter, select Trending

#define WW_FLURRY_EVENT_FILTER_CLEAR_FILTER @"ClearFilter"
// Once on Filter, select clear Filter

#define WW_FLURRY_EVENT_TAP_ON_INFO_WHILE_HALF_MAP @"InfoHalfMapView"
// Tap on ‘Info’ to get to the detailed screen on Half-Map view

#define WW_FLURRY_EVENT_TAP_ON_INFO_WHILE_EXPANDED @"InfoPlaceView"
// Tap on ‘Info’ to get to the detailed screen on Place view

#define WW_FLURRY_EVENT_TAP_ON_PIN_WHILE_HALF_MAP @"TapOnPinHalfMap"
// Tap on a pin on Half-Map view

#define WW_FLURRY_EVENT_TAP_ON_PIN_WHILE_FULL_MAP @"TapOnPinFullMap"
// Tap on a pin on Full-Map view

#define WW_FLURRY_EVENT_TAP_FULL_MAP @"HalfMaptoFullMap"
// Tapping on the half-map to get to the Full-Map view

#define WW_FLURRY_EVENT_TAP_REDO_SEARCH_HALF_MAP @"RedoSearchHalfMap"
// Tapping on the ‘Refresh’ button to redo a search on the Half-map

#define WW_FLURRY_EVENT_TAP_ON_REDO_SEARCH_FULL_MAP @"RedoSearchFullMap"
// Tapping on the ‘Refresh’ button to redo a search on the Full-map

#define WW_FLURRY_EVENT_MOVE_MAP @"MoveMap"
// Moving map by panning or scrolling

#define WW_FLURRY_EVENT_TAP_ON_HASH_TAG @"TapHashtagPlaceView"
// Tapping on a Hashtag when on the Place view to get to the detailed hashtag screen

#define WW_FLURRY_EVENT_CLOSE_PLACE_DETAILS @"ClosePlaceView"
// Tapping on the ‘Cross’ to close the Full Place view and go on the Half-Map

#define WW_FLURRY_EVENT_TAP_BACK_HASHTAG_NAVIGATION_ARROW @"TapBackHashtagNavigationArrow"
// Tapping on the ‘Back’ to navigate back in hashtag searches

#define WW_FLURRY_EVENT_TAP_FOOD_TAB @"TapFoodTab"
// Tap the ‘food’ tab once on place view

#define WW_FLURRY_EVENT_TAP_ATMOSPHERE_TAB @"TapAtmosphereTab"
// Tap the ‘atmosphere’ tab once on place view

#define WW_FLURRY_EVENT_TAP_PEOPLE_TAB @"TapPeopleTab"
// Tap the ‘people’ tab once on place view

#define WW_FLURRY_EVENT_TAP_TAGS_TAB @"TapTagsTab"
// Tap the ‘tags’ tab once on place view

#define WW_FLURRY_EVENT_TAP_ON_SMALL_PHOTO @"TapSmallPhoto"
// Tap on a small photo to get to a large photo

#define WW_FLURRY_EVENT_TAP_ON_SMALL_PHOTO_BELOW_HASHTAG @"TapSmallPhotoBelowHashtag"
// Tap on a small photo below the hashtag and get to a large photo

#define WW_FLURRY_EVENT_SCROLL_LARGE_PHOTOS_HORIZONTALLY @"ScrollLargePhoto"
// Scroll large photo horizontally

#define WW_FLURRY_EVENT_TAP_HASH_TAG_BELOW_LARGE_PHOTO @"TapHashtaginBigPhoto"
// Tap a hashtag below a big photo

#define WW_FLURRY_EVENT_TAP_DIRECTIONS @"TapDirection"
// Tap direction once in the Detail screen

#define WW_FLURRY_EVENT_TAP_CALL_PLACE @"CallPlace"
// Call a place once in the Detail screen

#define WW_FLURRY_EVENT_TAP_ADD_TO_FAVORITES @"AddToFavorites"
//Add to favorites once in the Detail screen

#define WW_FLURRY_EVENT_TAP_SHARE_FACEBOOK @"TapShareFB"
// Tap on Share on FB once in the Detail screen

#define WW_FLURRY_EVENT_TAP_SHARE_TWITTER @"TapShareTwitter"
// Tap on Share on Twitter once in the Detail screen

#define WW_FLURRY_EVENT_TAP_SHARE_TEXT @"TapShareText"
// Tap on Share text once in the Detail screen

#define WW_FLURRY_EVENT_TAP_SHARE_EMAIL @"TapShareEmail"
// Tap on Share text once in the Detail screen

#define WW_FLURRY_EVENT_SHARE_FACEBOOK @"ShareFB"
// Share on FB once in the Detail screen

#define WW_FLURRY_EVENT_SHARE_TWITTER @"ShareTwitter"
// Share on Twitter once in the Detail screen

#define WW_FLURRY_EVENT_SHARE_TEXT @"ShareText"
// Share text once in the Detail screen

#define WW_FLURRY_EVENT_SHARE_EMAIL @"ShareEmail"
// Share text once in the Detail screen

#define WW_FLURRY_EVENT_TAP_HAMBURGER @"TapHamburger"
// Tap the ‘Three Bar’ button

#define WW_FLURRY_EVENT_TAP_SETTINGS @"TapSetting"
// Tap on ‘Setting’

#define WW_FLURRY_EVENT_TAP_TUTORIAL @"TapTutorial"
// Tap on ‘How It Works’

#define WW_FLURRY_EVENT_TAP_FEEDBACK @"TapFeedback"
// Tap on ‘Feedback’

#define WW_FLURRY_EVENT_TAP_ABOUT @"TapAbout"
// Tap on ‘About’

#define WW_FLURRY_EVENT_TAP_TERMS_AND_CONDITIONS @"TapTerms"
// Tap on ‘Terms’

#define WW_FLURRY_EVENT_TAP_PRIVACY_POLICY @"TapPrivatePolicy"
// Tap on ‘Private Policy’

#define WW_FLURRY_EVENT_LOGIN_FACEBOOK @"SignInFB"
// Sign in via FB

#define WW_FLURRY_EVENT_REGISTER_EMAIL @"SignUpEmail"
// Sign-up with email

#define WW_FLURRY_EVENT_LOGIN_EMAIL @"SignInEmail"
// Sign-in with email

#define WW_FLURRY_EVENT_TAP_ALREADY_HAVE_ACCOUNT @"TapAlreayHaveAccount"
// Tap on ‘Already have account’

#define WW_FLURRY_EVENT_TAP_FIND_PLACES @"TapFindPlaces"
// Tap ‘Find Places’

#define WW_FLURRY_EVENT_INVITE_FRIENDS @"InviteFriends"
// Tap on ‘Invite friends’

#define WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG @"TapOnIntroHashtag"
// Tap on ‘Invite friends’

#define WW_FLURRY_EVENT_SKIP_TUTORIAL @"SkipTutorial"
// Tap on ‘Invite friends’




////////////////////////////////////////////////////////////////////////////////
// Enums
typedef enum
{
    WWCriteriaNone = -1,
    WWCriteriaCity = 0,
    WWCriteriaNeighborhood,
    WWCriteriaCategory,
    WWCriteriaSubCategory,
    WWCriteriaPrice,
    WWCriteriaBlank,
    WWCriteriaSearchButton,
    
    WWCriteriaCount,
    
} WWCriteria;

typedef enum
{
    WWRankTypeTrending,
    WWRankTypeClassic,
    
} WWRankType;

typedef enum
{
    WWPhotoFilterTags,
    WWPhotoFilterPeople,
    WWPhotoFilterFood,
    WWPhotoFilterVenue,
    
    WWPhotoFilterNone = -1,
    
} WWPhotoFilter;

typedef enum
{
    WWPhotoSizeSmall,
    WWPhotoSizeLarge,
} WWPhotoSize;

typedef enum
{
    WWRateItPrefNone = 0,
    WWRateItPrefRatedIt = 1,
    WWRateItPrefIgnoreThisTime = 2,
    WWRateItPrefIgnoreForever = 3,
    
} WWRateItPref;

#define kWWSecondsPerHour (60 * 60)
#define kWWSecondsPerDay  (kWWSecondsPerHour * 24)
#define kWWSecondsPerWeek (kWWSecondsPerDay  * 7)
#define kWWSecondsPerYear (kWWSecondsPerWeek * 52)

#endif
