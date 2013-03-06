//
//  Constants.h
//  iShare
//
//  Created by dai Tiger on 13-2-24.
//  Copyright (c) 2013年 NCS. All rights reserved.
//

//Model Name
#define AUDIENCEMODEL @"Audience"
#define SESSIONMODEL @"Session"


//AudienceModel Propeties
#define AttendTime @"attendTime"
#define AudienceID @"audienceID"
#define CheckInIndicator @"checkinIndicator"
#define LotteryIndicator @"lotteryIndicator"
#define StaffID @"staffID"
#define StaffName @"staffName"
#define UserID @"userID"
#define WinLotteryIndicator @"winIndicator"
#define SessionInfo @"session"

//UserDefault Keys -- Added by Wang Wen Hao
#define kEnabledSound           @"enabled_sound"
#define kEnabledVibrate         @"enabled_vibrate"
#define kSliderAwardCount       @"slider_awardCount"
#define kCurrentSession         @"session_current"
#define kServerSetting          @"server_setting"

//DateFormat
#define kDateFormat             @"yyyy-MM-dd HH:mm:ss"

//AlertView Tags
#define kNoSessionSeleted       9999
#define kAddAudienceError       9998
#define kSessionMismatch        9997

//Session Json Items
#define kSessionID              @"sessionId"
#define kSessionName            @"sessionName"
#define kSessionStartTime       @"startTime"
#define kSessionEndTime         @"endTime"
#define kSessionLecturer        @"lecturer"
#define kSessionDepartment      @"deptName"
#define kSessionLocation        @"location"
#define kSessionDesc            @"desc"

//Ticket Json Items
#define kTicketSessionID        @"sessionId"
#define kTicketSessionName      @"sessionName"
#define kTicketUserID           @"userId"
#define kTicketUserName         @"userName"
#define kTicketStaffID          @"staffId"

//Notification Name
#define kSessionScanStartNotification @"SessionScanStart"
#define kCheckinScanStartNotification @"CheckinScanStart"
#define kPopViewControllerNofitication @"PopViewController"

//common UI settings
#define MIN_SCALE 0.8f
#define FONT_SIZE 14.0
#define DEFAULT_CELL_HEIGHT 66.0

//UploadService
#define SERVER_URL @"http://192.168.81.131:8000/mobil/batch"
#define UPLOAD_URI @"/upload/attendance"
#define PARAM_NAME_ACCOUNT_ID @"account_id"
#define PARAM_NAME_ACCOUNT_PASSWORD @"account_password"
#define PARAM_NAME_JSON_LIST @"json_list"
#define JSON_PARAM_USER_ID @"userId"
#define JSON_PARAM_SESSION_ID @"sessionId"