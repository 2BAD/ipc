-- Declare the protocol
local protocol = Proto("IPC", "IPC Protocol")

-- Define lookup table for packet types
local vs_packet_type = {
  [1] = "Login",
  [6] = "Session",
  [11] = "Alarm",
  [5] = "5",
  [7] = "7",
  [21] = "21",
  [22] = "22"
}

local vs_ipc_cmd = {
  [0x100] = "CMD_BASENUM_LOGIN",
  [0x101] = "CMD_REQUEST_LOGIN",
  [0x102] = "CMD_REQUEST_LOGOUT",
  [0x103] = "CMD_REQUEST_STREAM_BRIEF",
  [0x104] = "CMD_END_LOGIN",

  [0x200] = "CMD_BASENUM_CTRL",
  [0x201] = "CMD_REQUEST_STREAM_START",
  [0x202] = "CMD_REQUEST_STREAM_STOP",
  [0x203] = "CMD_REQUEST_KEYFRAME",
  [0x204] = "CMD_REQUEST_SHUTDOWN",
  [0x205] = "CMD_REQUEST_REBOOT",
  [0x206] = "CMD_REQUEST_CLIENT_INFO",
  [0x207] = "CMD_REQUEST_CHANGE_TIME",
  [0x208] = "CMD_REQUEST_SEARCH_WIFI",
  [0x209] = "CMD_REQUEST_DATA_TO_SERVER",
  [0x20A] = "CMD_REQUEST_CHECK_WIFI",
  [0x20B] = "CMD_REQUEST_NTP_IMMEDIATELY",
  [0x20C] = "CMD_REQUEST_MAX_VIDEO_LEN",
  [0x20D] = "CMD_REQUEST_TRANSPARENT_DATA",
  [0x20E] = "CMD_REQUEST_JPEG_DATA",
  [0x20F] = "CMD_REQUEST_MAC_ENCODE",
  [0x210] = "CMD_REQUEST_MAC_ENCODE_X",
  [0x211] = "CMD_REQUEST_MULTI_STREAM_INFO",
  [0x212] = "CMD_REQUEST_USE_QR_CODE",
  [0x213] = "CMD_END_CTRL",
  [0x2F4] = "CMD_REQUEST_GET_CALIBRATION_IMAGE",
  [0x2F5] = "CMD_REQUEST_SWITCH_NO_SPLICE_MODE",

  [0x300] = "CMD_BASENUM_CHNN_CTRL",
  [0x301] = "CMD_REQUEST_COLOR_SET",
  [0x302] = "CMD_REQUEST_COLOR_CANCEL",
  [0x303] = "CMD_REQUEST_SET_WHITE_BALANCE",
  [0x304] = "CMD_REQUEST_CANCE_WHITE_BALANCE",
  [0x305] = "CMD_REQUEST_SET_DYNANIC_RANGE",
  [0x306] = "CMD_REQUEST_CANCE_DYNAMIC_RANGE",
  [0x307] = "CMD_REQUEST_SET_DENOISE",
  [0x308] = "CMD_REQUEST_CANCE_DENOISE",
  [0x309] = "CMD_REQUEST_SET_IRISTYPE",
  [0x30A] = "CMD_REQUEST_CANCE_IRISTYPE",
  [0x30B] = "CMD_REQUEST_SET_SHARPEN",
  [0x30C] = "CMD_REQUEST_CANCE_SHARPEN",
  [0x30D] = "CMD_REQUEST_BAD_PIXEL_CHECK",
  [0x30E] = "CMD_REQUEST_DAY_NIGHT",
  [0x30F] = "CMD_REQUEST_SET_DAY_NIGHT_MODE",
  [0x310] = "CMD_REQUEST_CANCLE_DAY_NIGHT_MODE",
  [0x311] = "CMD_REQUEST_SET_OSD_MASK",
  [0x312] = "CMD_REQUEST_SET_EXPOSE_MODE",
  [0x313] = "CMD_REQUEST_CANCLE_SET_EXPOSE_MODE",
  [0x314] = "CMD_REQUEST_SET_EXPOSE_VALUE",
  [0x315] = "CMD_REQUEST_CANCLE_SET_EXPOSE_VALUE",
  [0x316] = "CMD_REQUEST_ADJUST_VOLUME",
  [0x317] = "CMD_REQUEST_ADJUST_VOLUME_CANCEL",
  [0x318] = "CMD_REQUEST_SET_DAY_NIGNT_TIME",
  [0x319] = "CMD_REQUEST_SET_IMAGE_MIRROR",
  [0x31A] = "CMD_REQUEST_SET_IMAGE_FILP",
  [0x31B] = "CMD_REQUEST_SET_IMAGE_ROTATO",
  [0x31C] = "CMD_REQUEST_SET_AUTOFOCUS",
  [0x31D] = "CMD_REQUEST_SET_BLC",
  [0x31E] = "CMD_REQUEST_SET_HLC",
  [0x31F] = "CMD_REQUEST_SET_AGC",
  [0x320] = "CMD_REQUEST_CANCEL_SET_BLC",
  [0x321] = "CMD_REQUEST_CANCEL_SET_HLC",
  [0x322] = "CMD_REQUEST_CNACEL_SET_AGC",
  [0x323] = "CMD_REQUEST_SET_HDYNANIC_RANGE",
  [0x324] = "CMD_REQUEST_CANCE_HDYNAMIC_RANGE",
  [0x325] = "CMD_REQUEST_SET_CDS_VALUE",
  [0x326] = "CMD_REQUEST_LENS_CALIBRATION",
  [0x327] = "CMD_REQUEST_LENS_INIT",
  [0x328] = "CMD_REQUEST_LENS_CALIB_INFO",
  [0x329] = "CMD_REQUEST_SET_CDS_MODE",
  [0x32A] = "CMD_REQUEST_SET_BLACK_COLOR",
  [0x32B] = "CMD_END_CHNN_CTRL",

  [0x400] = "CMD_BASENUM_CFG",
  [0x401] = "CMD_REQUEST_CFG_DEFAULT",
  [0x402] = "CMD_REQUEST_CFG_NET",
  [0x403] = "CMD_REQUEST_CFG_MAIL_TEST",
  [0x404] = "CMD_REQUEST_CFG_FTP_TEST",
  [0x405] = "CMD_REQUEST_CFG_ENTER",
  [0x406] = "CMD_REQUEST_CFG_LEAVE",
  [0x407] = "CMD_REQUEST_CFG_GET",
  [0x408] = "CMD_REQUEST_CFG_SET",
  [0x409] = "CMD_REQUEST_CFG_NET_V2",
  [0x40A] = "CMD_REQUEST_CFG_ADD_IPHONE_TOKEN",
  [0x40B] = "CMD_REQUEST_CFG_DEL_IPHONE_TOKEN",
  [0x40C] = "CMD_REQUEST_CFG_SUPPORT_IPHONE_PUSH",
  [0x40D] = "CMD_REQUEST_CFG_EXIST_IPHONE_TOKEN",
  [0x40E] = "CMD_REQUEST_CFG_CUSTOMER_GET",
  [0x40F] = "CMD_REQUEST_CHANNEL_CRRENT_VIDEO_ENCODE_INFO",
  [0x410] = "CMD_REQUEST_MODIFY_CHANNEL_VIDEO_ENCODE_INFO",
  [0x411] = "CMD_REQUEST_API_PROTOCOL",
  [0x412] = "CMD_END_CFG",

  [0x500] = "CMD_BASENUM_DATA",
  [0x501] = "CMD_REQUEST_DATA_SD_ALL_DATE",
  [0x502] = "CMD_REQUEST_DATA_SD_SEARCH_NAME",
  [0x503] = "CMD_REQUEST_DATA_SD_GET_PIC",
  [0x504] = "CMD_REQUEST_DISK_FORMAT",
  [0x505] = "CMD_REQUEST_DISK_POP_SDCARD",
  [0x506] = "CMD_REQUEST_LOGDATA",
  [0x507] = "CMD_END_DATA",

  [0x600] = "CMD_BASENUM_PTZ",
  [0x601] = "CMD_REQUEST_PTZ_START",
  [0x602] = "CMD_REQUEST_PTZ_MOVE",
  [0x603] = "CMD_REQUEST_PTZ_ADJUST",
  [0x604] = "CMD_REQUEST_PTZ_STOP",
  [0x605] = "CMD_REQUEST_PTZ_WRITECOMM",
  [0x606] = "CMD_REQUEST_PTZ_3DZOOM",
  [0x607] = "CMD_REQUEST_PTZ_POSITION",
  [0x608] = "CMD_END_PTZ",

  [0x700] = "CMD_BASENUM_TALK",
  [0x701] = "CMD_REQUEST_TALK_START",
  [0x702] = "CMD_REQUEST_TALK_STREAM",
  [0x703] = "CMD_REQUEST_TALK_STOP",
  [0x704] = "CMD_END_TALK",

  [0x800] = "CMD_BASENUM_SYSTEM_UPDATE",
  [0x801] = "CMD_REQUEST_SYSTEM_UPDATE_DATA",
  [0x802] = "CMD_REQUEST_UBOOT_UPDATE_DATA",
  [0x803] = "CMD_REQUEST_FILE_SYSTEM_UPDATE_DATA",
  [0x804] = "CMD_REQUEST_FILE_SYSTEM_ALL",
  [0x805] = "CMD_REQUEST_INTELLIGENT_LIBRARY_UPDATE_DATA",
  [0x806] = "CMD_END_SYSTEM_UPDATE",

  [0x900] = "CMD_BASENUM_SD_RECORD",
  [0x901] = "CMD_REQUEST_MANUAL_RECORD",
  [0x902] = "CMD_REQUEST_MANUAL_STOP",
  [0x903] = "CMD_REQUEST_DATA_SD_GET_EVENT",
  [0x904] = "CMD_REQUEST_DATA_SD_SEARCH_EVENT",
  [0x905] = "CMD_REQUEST_EVENT_SD_ALL_DATE",
  [0x906] = "CMD_REQUEST_PLAY_EVENT_STREAM",
  [0x907] = "CMD_REQUEST_SUSPEND_EVENT_STREAM",
  [0x908] = "CMD_REQUEST_STOP_EVENT_STREAM",
  [0x909] = "CMD_REQUEST_PULL_ENENT_STREAM",
  [0x90A] = "CMD_REQUEST_SEND_DATA_BAG",
  [0x90B] = "CMD_REQUEST_DATA_SD_GET_EVENT_LIST",

  [0x0A00] = "CMD_BASENUM_UPDATE",
  [0x0A01] = "CMD_REQUEST_UPDATE_START",
  [0x0A02] = "CMD_REQUEST_UPDATE_DATA",
  [0x0A03] = "CMD_REQUEST_UPDATE_END",
  [0x0A04] = "CMD_REQUEST_UPDATE_MTD_DATA",
  [0x0A05] = "CMD_REQUEST_UPDATE_PTZ_DATA",
  [0x0A06] = "CMD_END_UPDATE",

  [0x0B00] = "CMD_BASENUM_ALARM_CONTROL",
  [0x0B01] = "CMD_REQUEST_ALARM_OUT_START",
  [0x0B02] = "CMD_REQUEST_ALARM_OUT_STOP",
  [0x0B03] = "CMD_REQUEST_PEA_RULE_INFO",
  [0x0B04] = "CMD_REQUEST_OSC_RULE_INFO",
  [0x0B05] = "CMD_REQUEST_CPC_RULE_INFO",
  [0x0B06] = "CMD_REQUEST_IPD_RULE_INFO",
  [0x0B07] = "CMD_REQUEST_VFD_RULE_INFO",
  [0x0B08] = "CMD_REQUEST_VEHICE_RULE_INFO",
  [0x0B09] = "CMD_REQUEST_AOIENTRY_RULE_INFO",
  [0x0B0A] = "CMD_REQUEST_AOILEAVE_RULE_INFO",
  [0x0B0B] = "CMD_REQUEST_PASSLINE_RULE_INFO",
  [0x0B0C] = "CMD_REQUEST_TRAFFIC_RULE_INFO",
  [0x0B0D] = "CMD_END_ALARM_CONTROL",

  [0x0D00] = "CMD_BASENUM_SET_FACTORY",
  [0x0D01] = "CMD_REQUEST_SET_FACTORY_CFG",
  [0x0D02] = "CMD_REQUEST_SET_MAC_HARDVER",
  [0x0D03] = "CMD_REQUEST_SET_SPECIAL_FAC",
  [0x0D04] = "CMD_REQUEST_CUR_LIGHT_VALUE",
  [0x0D05] = "CMD_REQUEST_DAYNIGHT_THRESHOLD_VALUE",
  [0x0D06] = "CMD_REQUEST_GET_ENCRYP_STATUS",

  [0x0E00] = "CMD_BASENUM_CALIB",
  [0x0E01] = "CMD_REQUEST_CALIB_AF",
  [0x0E02] = "CMD_REQUEST_CALIB_AE",
  [0x0E03] = "CMD_REQUEST_CALIB_AWB",
  [0x0E04] = "CMD_REQUEST_CALIB_DEFECT_PIXEL",
  [0x0E05] = "CMD_REQUEST_CALIB_LENSHADDING",
  [0x0E06] = "CMD_REQUEST_IMAGEQUALITY",
  [0x0E07] = "CMD_REQUEST_FUNC_TEST",
  [0x0E08] = "CMD_REQUEST_LENS_POS",
  [0x0E09] = "CMD_END_CALIB",

  [0x0F00] = "CMD_BASENUM_UPLOAD",
  [0x0F01] = "CMD_REQUEST_UPLOAD_OSD_IMG_DATA",
  [0x0F02] = "CMD_REQUEST_UPLOAD_HTTPS_CERT_DATE",
  [0x0F03] = "CMD_REQUEST_UPLOAD_CALIBRATION_INFO",
  [0x0F04] = "CMD_REQUEST_UPLOAD_CALIBRATION_INFO_OVER",
  [0x0F05] = "CMD_REQUEST_UPLOAD_CALIBRATION_INFO_READY",
  [0x0F06] = "CMD_END_UPLOAD",

  [0x1000] = "CMD_BASENUM_SMART_SUBSCRIBE",
  [0x1001] = "CMD_REQUEST_GET_SMART_STATE",
  [0x1002] = "CMD_REQUEST_SMART_SUBSCRIBE",
  [0x1003] = "CMD_REQUEST_SMART_RENEW",
  [0x1004] = "CMD_REQUEST_SMART_UNSUBSCRIBE",

  [0x2000] = "CMD_BASENUM_REQUEST_VFD_MATCH",
  [0x2001] = "CMD_REQUEST_ADD_ALBUM",
  [0x2002] = "CMD_REQUEST_DELE_ALBUM",
  [0x2003] = "CMD_REQUEST_QUERY_ALBUM",
  [0x2004] = "CMD_REQUEST_MODIFY_ALBUM",
  [0x2005] = "CMD_REQUEST_IMPORT_EXPORT_START",
  [0x2006] = "CMD_REQUEST_IMPORT_ALBUM",
  [0x2007] = "CMD_REQUEST_EXPORT_ALBUM",
  [0x2008] = "CMD_REQUEST_IMPORT_EXPORT_STOP",
  [0x2009] = "CMD_END_REQUEST_VFD_MATCH",

  [0x1000100] = "CMD_BASENUM_REPLY_LOGIN",
  [0x1000101] = "CMD_REPLY_LOGIN_SUCC",
  [0x1000102] = "CMD_REPLY_LOGIN_FAIL",
  [0x1000103] = "CMD_REPLY_STREAM_BRIEF",
  [0x1000104] = "CMD_END_REPLY_LOGIN",
  [0x1000200] = "CMD_BASENUM_REPLY_CTRL",
  [0x1000201] = "CMD_REPLY_CLIENT_INFO",
  [0x1000202] = "CMD_REPLY_SEARCH_WIFI",
  [0x1000203] = "CMD_REPLY_DATA_TO_CLIENT",
  [0x1000204] = "CMD_REPLY_CHECK_WIFI",
  [0x1000205] = "CMD_REPLY_TRANSPARENT_DATA",
  [0x1000206] = "CMD_REPLY_JPEG_DATA",
  [0x1000207] = "CMD_REPLY_SET_FACTORY_CFG",
  [0x1000208] = "CMD_REPLY_SET_MAC_HARDVER",
  [0x1000209] = "CMD_REPLY_SET_SPECIAL_FAC",
  [0x100020A] = "CMD_REPLY_CUR_LIGHT_VALUE",
  [0x100020B] = "CMD_REPLY_Get_ENCRPY_STATUS",
  [0x100020C] = "CMD_REPLY_MAC_ENCODE_X",
  [0x100020D] = "CMD_REPLY_REQUEST_STREAM_START",
  [0x100020E] = "CMD_REPLY_MULTI_STREAM_INFO",
  [0x100020F] = "CMD_REPLY_USE_QR_CODE",
  [0x1000210] = "CMD_REPLY_DAYNIGHT_THRESHOLD_VALUE",
  [0x1000211] = "CMD_END_REPLY_CTRL",
  [0x10002F2] = "CMD_REPLY_GET_CALIBRATION_IMAGE",
  [0x10002F3] = "CMD_REPLY_SWITCH_NO_SPLICE_MODE",
  [0x1000300] = "CMD_BASENUM_REPLY_CHNN_CTRL",
  [0x1000301] = "CMD_REPLY_CHNN_CTRL_COLOR",
  [0x1000302] = "CMD_REPLY_BAD_PIXEL_CHECK",
  [0x1000303] = "CMD_REPLY_SET_CDS_VALUE",
  [0x1000304] = "CMD_REPLY_LENS_CALIBRATION",
  [0x1000305] = "CMD_REPLY_LENS_INIT",
  [0x1000306] = "CMD_REPLY_LENS_CALIB_INFO",
  [0x1000307] = "CMD_END_REPLY_CHNN_CTRL",
  [0x1000400] = "CMD_BASENUM_REPLY_CFG",
  [0x1000401] = "CMD_REPLY_CFG_SUCC",
  [0x1000402] = "CMD_REPLY_CFG_FAIL",
  [0x1000403] = "CMD_REPLY_CFG_MAIL_TEST",
  [0x1000404] = "CMD_REPLY_CFG_FTP_TEST",
  [0x1000405] = "CMD_REPLY_CFG_DATA",
  [0x1000406] = "CMD_REPLY_CFG_DEFAULT",
  [0x1000407] = "CMD_REPLY_CFG_ADD_IPHONE_TOKEN",
  [0x1000408] = "CMD_REPLY_CFG_DEL_IPHONE_TOKEN",
  [0x1000409] = "CMD_REPLY_CFG_SUPPORT_IPHONE_PUSH",
  [0x100040A] = "CMD_REPLY_CFG_EXIST_IPHONE_TOKEN",
  [0x100040B] = "CMD_REPLY_CFG_CUSTOMER_REPLY",
  [0x100040C] = "CMD_REPLY_CHANNEL_CRRENT_VIDEO_ENCODE_INFO",
  [0x100040D] = "CMD_REPLY_MODIFY_CHANNEL_VIDEO_ENCODE_INFO_SUCC",
  [0x100040E] = "CMD_REPLY_MODIFY_CHANNEL_VIDEO_ENCODE_INFO_FAIL",
  [0x100040F] = "CMD_REPLY_API_PROTOCOL",
  [0x1000410] = "CMD_END_REPLY_CFG",
  [0x1000500] = "CMD_BASENUM_REPLY_SEARCH",
  [0x1000501] = "CMD_REPLY_DATA_SD_ALL_DATE",
  [0x1000502] = "CMD_REPLY_DATA_SD_SEARCH_NAME",
  [0x1000503] = "CMD_REPLY_DATA_SD_GET_PIC",
  [0x1000504] = "CMD_REPLY_DISK_FAIL",
  [0x1000505] = "CMD_REPLY_FORMAT_FAIL",
  [0x1000506] = "CMD_REPLY_FORMAT_PERCENT",
  [0x1000507] = "CMD_REPLY_POP_SDCARD_SUCC",
  [0x1000508] = "CMD_REPLY_POP_SDCARD_FAIL",
  [0x1000509] = "CMD_REPLY_LOGDATA",
  [0x100050A] = "CMD_END_REPLY_SEARCH",
  [0x1000600] = "CMD_BASENUM_REPLY_PTZ",
  [0x1000601] = "CMD_REPLY_PTZ_PRESET_INFO",
  [0x1000602] = "CMD_REPLY_PTZ_START_SUCC",
  [0x1000603] = "CMD_REPLY_PTZ_START_FAIL",
  [0x1000604] = "CMD_REPLY_PTZ_GET_POSITION",
  [0x1000605] = "CMD_END_REPLY_PTZ",
  [0x1000700] = "CMD_BASENUM_REPLYY_TALK",
  [0x1000701] = "CMD_REPLY_TALK_START_SUCC",
  [0x1000702] = "CMD_REPLY_TALK_START_FAIL",
  [0x1000703] = "CMD_END_REPLY_TALK",
  [0x1000800] = "CMD_BASENUM_REPLY_SYSTEM_UPDATE",
  [0x1000801] = "CMD_REPLY_SYSTEM_UPDATE_FAIL",
  [0x1000802] = "CMD_REPLY_SYSTEM_UPDATE_PERCENT",
  [0x1000803] = "CMD_END_REPLY_SYSTEM_UPDATE",
  [0x1000900] = "CMD_BASENUM_REPLY_SD_RECORD",
  [0x1000901] = "CMD_REPLY_MANUAL_RECORD_SUCC",
  [0x1000902] = "CMD_REPLY_MANUAL_RECORD_FAIL",
  [0x1000903] = "CMD_REPLY_MANUAL_STOP_SUCC",
  [0x1000904] = "CMD_REPLY_MANUAL_STOP_FAIL",
  [0x1000905] = "CMD_REPLY_GET_EVENT",
  [0x1000906] = "CMD_REPLY_DATA_SD_SEARCH_EVENT",
  [0x1000907] = "CMD_REPLY_EVENT_SD_ALL_DATE",
  [0x1000908] = "CMD_REPLY_PULL_ENENT_STREAM",
  [0x1000909] = "CMD_REPLY_GET_EVENT_LIST",
  [0x1000A00] = "CMD_BASENUM_REPLY_UPDATE",
  [0x1000A01] = "CMD_REPLY_CAN_UPDATE",
  [0x1000A02] = "CMD_REPLY_NOT_UPDATE",
  [0x1000A03] = "CMD_REPLY_UPDATE_FAIL",
  [0x1000A04] = "CMD_REPLY_UPDATE_PERCENT",
  [0x1000A05] = "CMD_REPLY_UPDATE_PTZ_RESULT",
  [0x1000A06] = "CMD_END_REPLY_UPDATE",
  [0x1000B00] = "CMD_BASENUM_REPLY_STATUS",
  [0x1000B01] = "CMD_REPLY_MOTION",
  [0x1000B02] = "CMD_REPLY_SENSOR",
  [0x1000B03] = "CMD_REPLY_CHNN_NAME",
  [0x1000B04] = "CMD_REPLY_PTZ_PRESET_NAME",
  [0x1000B05] = "CMD_REPLY_PTZ_CURISE_NAME",
  [0x1000B06] = "CMD_REPLY_PTZ",
  [0x1000B07] = "CMD_REPLY_SD_INFO",
  [0x1000B08] = "CMD_REPLY_TRAJECT",
  [0x1000B09] = "CMD_REPLY_PEA",
  [0x1000B0A] = "CMD_REPLY_OSC",
  [0x1000B0B] = "CMD_REPLY_AVD",
  [0x1000B0C] = "CMD_REPLY_TRIP_DATA",
  [0x1000B0D] = "CMD_REPLY_VFD",
  [0x1000B0E] = "CMD_REPLY_CPC",
  [0x1000B0F] = "CMD_REPLY_PEA_RULE_INFO",
  [0x1000B10] = "CMD_REPLY_OSC_RULE_INFO",
  [0x1000B11] = "CMD_REPLY_CDD",
  [0x1000B12] = "CMD_REPLY_IPD",
  [0x1000B13] = "CMD_REPLY_CPC_RULE_INFO",
  [0x1000B14] = "CMD_REPLY_IPD_RULE_INFO",
  [0x1000B15] = "CMD_REPLY_VFD_RULE_INFO",
  [0x1000B16] = "CMD_REPLY_MOTION_AREA",
  [0x1000B17] = "CMD_REPLY_PERIMETER_STATUS",
  [0x1000B18] = "CMD_REPLY_TRIP_STATUS",
  [0x1000B19] = "CMD_REPLY_OSC_STATUS",
  [0x1000B1A] = "CMD_REPLY_AVD_SCENE_STATUS",
  [0x1000B1B] = "CMD_REPLY_AVD_CLARITY_STATUS",
  [0x1000B1C] = "CMD_REPLY_AVD_COLOR_STATUS",
  [0x1000B1D] = "CMD_REPLY_VFD_STATUS",
  [0x1000B1E] = "CMD_REPLY_CPC_STATUS",
  [0x1000B1F] = "CMD_REPLY_CDD_STATUS",
  [0x1000B20] = "CMD_REPLY_IPD_STATUS",
  [0x1000B21] = "CMD_REPLY_FISHEYE_POS",
  [0x1000B22] = "CMD_REPLY_VFD_MATCH_STATUS",
  [0x1000B23] = "CMD_REPLY_VEHICE",
  [0x1000B24] = "CMD_REPLY_VEHICE_STATUS",
  [0x1000B25] = "CMD_REPLY_VEHICE_RULE_INFO",
  [0x1000B26] = "CMD_REPLY_AOIENTRY",
  [0x1000B27] = "CMD_REPLY_AOIENTRY_RULE_INFO",
  [0x1000B28] = "CMD_REPLY_AOIENTRY_STATUS",
  [0x1000B29] = "CMD_REPLY_AOILEAVE",
  [0x1000B2A] = "CMD_REPLY_AOILEAVE_RULE_INFO",
  [0x1000B2B] = "CMD_REPLY_AOILEAVE_STATUS",
  [0x1000B2C] = "CMD_REPLY_PASSLINECOUNT",
  [0x1000B2D] = "CMD_REPLY_PASSLINECOUNT_RULE_INFO",
  [0x1000B2E] = "CMD_REPLY_PASSLINECOUNT_STATUS",
  [0x1000B2F] = "CMD_REPLY_TRAFFIC",
  [0x1000B30] = "CMD_REPLY_TRAFFIC_RULE_INFO",
  [0x1000B31] = "CMD_REPLY_TRAFFIC_STATUS",
  [0x1000B32] = "CMD_REPLY_PEA_TARGET",
  [0x1000B33] = "CMD_END_REPLY_STATUS",
  [0x1000C00] = "CMD_BASENUM_REPLY_STREAM",
  [0x1000C01] = "CMD_REPLY_LIVE_STREAM",
  [0x1000C02] = "CMD_REPLY_PLAY_STREAM",
  [0x1000C03] = "CMD_REPLY_TALK_STREAM",
  [0x1000C04] = "CMD_REPLY_STREAM_NULL",
  [0x1000C05] = "CMD_REPLY_DATA_SD_GET_EVENT",
  [0x1000C06] = "CMD_REPLY_FISHEYE_PTZ_GET",
  [0x1000C07] = "CMD_REPLY_FISHEYE_SET_CENTER",
  [0x1000C08] = "CMD_REPLY_FISHEYE_GET_CENTER",
  [0x1000C09] = "CMD_END_REPLY_STREAM",
  [0x1000D00] = "CMD_BASENUM_REPLY_LOAD",
  [0x1000D01] = "CMD_REPLY_UPLOAD_OSD_IMG_DATA",
  [0x1000D02] = "CMD_REPLY_UPLOAD_HTTPS_CERT_DATE",
  [0x1000D03] = "CMD_REPLY_UPLOAD_CALIBRATION_INFO",
  [0x1000D04] = "CMD_REPLY_UPLOAD_CALIBRATION_INFO_OVER",
  [0x1000D05] = "CMD_REPLY_UPLOAD_CALIBRATION_INFO_READY",
  [0x1000D06] = "CMD_END_REPLY_LOAD",
  [0x1000E00] = "CMD_BASENUM_REPLY_CALIB",
  [0x1000E01] = "CMD_REPLY_CALIB_AF",
  [0x1000E02] = "CMD_REPLY_CALIB_AE",
  [0x1000E03] = "CMD_REPLY_CALIB_AWB",
  [0x1000E04] = "CMD_REPLY_CALIB_DEFECT_PIXEL",
  [0x1000E05] = "CMD_REPLY_CALIB_LENSSHADDING",
  [0x1000E06] = "CMD_REPLY_LENS_POS",
  [0x1000E07] = "CMD_REPLY_FUNC_TEST",
  [0x1000E08] = "CMD_END_REPLY_CALIB",
  [0x1000FA0] = "CMD_BASENUM_ACCESS",
  [0x1000FA1] = "CMD_REPLY_ACCESS_SD_STATUS",
  [0x1000FA2] = "CMD_REPLY_ACCESS_USB_STATUS",
  [0x1000FA3] = "CMD_REPLY_ACCESS_NET_STATUS",
  [0x1000FA4] = "CMD_REPLY_ACCESS_PASS_UNLOCK",
  [0x1000FA5] = "CMD_REPLY_TEMPERARUE_CHANGE",
  [0x1000FA6] = "CMD_REPLY_ACCESS_SHOW_VFD",
  [0x1000FA7] = "CMD_REPLY_CHANGE_TABLET_LANUAGE",
  [0x1000FA8] = "CMD_REPLY_TABLET_CONTENT_TEXT",
  [0x1000FA9] = "CMD_REPLY_TABLET_WIEGAND_DATA",
  [0x1000FAA] = "CMD_REPLY_SHOW_QUESTIONNAIRE",
  [0x1000FAB] = "CMD_REPLY_CHANGE_TABLET_TOUCHSCREEN",
  [0x1000FAC] = "CMD_REPLY_SHOW_POSTER",
  [0x1000FAD] = "CMD_REPLY_SHOW_NAME_TYPE",
  [0x1000FAE] = "CMD_REPLY_SHOW_MATCHING",
  [0x1000FAF] = "CMD_REPLY_SHOW_FACE_PICTURE",
  [0x1000FB0] = "CMD_REPLY_FACE_DATABASE_UPDATE_STATUS",
  [0x1000FB1] = "CMD_REPLY_INTERNAL_CARD_DATA",
  [0x1000FB2] = "CMD_REPLY_485_CARD_DATA",
  [0x1000FB3] = "CMD_REPLY_WIFI_NET_STATUS",
  [0x1000FB4] = "CMD_REPLY_SHOW_PASS_STATUS",
  [0x1000FB5] = "CMD_REPLY_QR_CODE_CHANGE",
  [0x1000FB6] = "CMD_REPLY_QR_CODE_RESULT",
  [0x1000FB7] = "CMD_REPLY_OPEN_PASS_DLG",
  [0x1000FB8] = "CMD_REPLY_UNLOCKING_EVENT",
  [0x1000FB9] = "CMD_REPLY_TAMPER_ALARM",
  [0x1000FBA] = "CMD_REPLY_DOORCONTACT_ALARM",
  [0x1000FBB] = "CMD_REPLY_DOORCONTACT_STATUS",
  [0x1000FBC] = "CMD_REPLY_DOORLOCK_STATUS",
  [0x1000FBD] = "CMD_START_TALKBACK_CALL_NVMS",
  [0x1000FBE] = "CMD_STOP_TALKBACK_CALL_NVMS",
  [0x1000FBF] = "CMD_NVMS_REJECT_TALKBACK",
  [0x1000FC0] = "CMD_NVMS_REPLY_TALKBACK",
  [0x1000FC1] = "CMD_REPLY_TABLET_CALL_STATUS",
  [0x1000FC2] = "CMD_REPLY_DOORBELL_RING_EVENT",
  [0x1000FC3] = "CMD_END_ACCESS",
  [0x1001000] = "CMD_BASENUM_REPLY_SMART_SUBSCRIBE",
  [0x1001001] = "CMD_REPLY_GET_SMART_STATE",
  [0x1001002] = "CMD_REPLY_SMART_SUBSCRIBE",
  [0x1001003] = "CMD_REPLY_SMART_RENEW",
  [0x1001004] = "CMD_REPLY_SMART_UNSUBSCRIBE",
  [0x1001005] = "CMD_REPLY_SMART_ALARM_MESSAGE",
  [0x1002000] = "CMD_BASENUM_REPLY_VFD_MATCH",
  [0x1002001] = "CMD_REPLY_VFD_MATCH_RESULT",
  [0x1002002] = "CMD_REPLY_ADD_ALBUM",
  [0x1002003] = "CMD_REPLY_DELE_ALBUM",
  [0x1002004] = "CMD_REPLY_QUERY_ALBUM",
  [0x1002005] = "CMD_REPLY_MODIFY_ALBUM",
  [0x1002006] = "CMD_REPLY_IMPORT_EXPORT_START",
  [0x1002007] = "CMD_REPLY_IMPORT_ALBUM",
  [0x1002008] = "CMD_REPLY_EXPORT_ALBUM",
  [0x1002009] = "CMD_REPLY_IMPORT_EXPORT_STOP",
  [0x100200A] = "CMD_END_REPLY_VFD_MATCH",
  [0x1010D00] = "CMD_HTTP_REQUEST",
  [0x1010D01] = "CMD_HTTP_REPLY"
}
}

local vs_direction = {
  [0] = "Request",
  [1] = "Response"
}

-- Define the fields
local fields = {
    head = ProtoField.string("ipc.head", "Head"),
    data_length = ProtoField.uint32("ipc.len", "Data Length"),
    cmd = ProtoField.uint32("ipc.cmd", "Command", base.HEX),
    cmdType = ProtoField.uint32("ipc.cmdType", "Type", base.HEX, vs_ipc_cmd, 0x0FFFFFFF),
    cmdId = ProtoField.uint8("ipc.cmdId", "Command ID", base.DEC),
    cmdVer = ProtoField.uint8("ipc.cmdVer", "Command Version", base.DEC),
    counter = ProtoField.uint32("ipc.counter", "Counter"),
    sdkVersion = ProtoField.uint32("ipc.sdkVersion", "SDK Version"),
    session = ProtoField.uint32("ipc.session", "Session"),
    direction = ProtoField.uint8("ipc.direction", "Direction", base.DEC, vs_direction),
    login = ProtoField.bytes("ipc.login", "Login", base.SPACE),
    password = ProtoField.bytes("ipc.password", "Passw", base.SPACE),
    manufacturer = ProtoField.string("ipc.manufacturer", "Manufacturer"),

    unk8 = ProtoField.uint8("ipc.unk8", "Unk8"),
    unk32 = ProtoField.uint32("ipc.unk32", "Unk32"),
    unkb = ProtoField.bytes("ipc.unkb", "UnkBs", base.SPACE)
}

protocol.fields = fields

-- Define the dissector function
function protocol.dissector(buffer, pinfo, tree)
    -- Set protocol name
    pinfo.cols.protocol = protocol.name

    -- Create t_ipc subtree
    local t_ipc = tree:add(protocol, buffer(), "IPC")
    local offset = 0

    -- Create t_header subtree
    local t_header = t_ipc:add(protocol, buffer(offset), "Header")

    -- Add fields to the t_header
    t_header:add(fields.head, buffer(offset, 4))
    local p_head = buffer(offset, 4):string()
    offset = offset + 4

    t_header:add_le(fields.data_length, buffer(offset, 4))
    offset = offset + 4

    if p_head == '1111' and buffer:len() == offset then
      pinfo.cols.info = 'keepalive'
    end

    if buffer:len() > offset then

      -- Create t_command subtree
      local t_command = t_ipc:add(protocol, buffer(offset), "Command")

      t_command:add_le(fields.cmd, buffer(offset, 4))
      local p_cmd = buffer(offset, 4):uint()
      t_command:add_le(fields.cmdType, buffer(offset, 4))
      local p_cmdType = buffer(offset, 4):uint()
      offset = offset + 4

      t_command:add_le(fields.cmdId, buffer(offset, 4))
      local p_cmdId = buffer(offset, 4):uint()
      offset = offset + 4

      t_command:add_le(fields.cmdVer, buffer(offset, 4))
      local p_cmdVer = buffer(offset, 4):uint()
      offset = offset + 4

      t_command:add_le(fields.data_length, buffer(offset, 4))
      offset = offset + 4

      -- pinfo.cols.info = vs_direction[p_direction] .. "(" .. vs_cmd[p_cmd] .. " " .. vs_packet_type[p_type] .. ")"

      -- Init Session
      if p_cmd == 21 and p_type == 6 then
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.session, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4

        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1
        t_command:add(fields.unk8, buffer(offset, 1))
        offset = offset + 1

        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
      else
        t_command:add_le(fields.unk32, buffer(offset, 4))
        offset = offset + 4
        t_command:add_le(fields.data_length, buffer(offset, 4))
        offset = offset + 4
        local t_frame = t_command:add(protocol, buffer(offset), "Frame")

        if buffer:len() > offset then
          if p_type == 1 and p_direction == 0 then
            t_frame:add_le(fields.unk32, buffer(offset, 4))
            offset = offset + 4
            t_frame:add_le(fields.login, buffer(offset, 32))
            offset = offset + 32
            t_frame:add_le(fields.password, buffer(offset, 32))
            offset = offset + 32
            t_frame:add_le(fields.unkb, buffer(offset, 32))
            offset = offset + 32
            t_frame:add_le(fields.unk32, buffer(offset, 4))
            offset = offset + 4
            t_frame:add_le(fields.unk32, buffer(offset, 4))
            offset = offset + 4
            t_frame:add_le(fields.unk32, buffer(offset, 4))
            offset = offset + 4
          elseif p_type == 1 and p_direction == 1 and buffer:len() > 40 then
            offset = offset + 58
            t_ipc:add(fields.manufacturer, buffer(offset, 4))
            offset = offset + 4
          end
        end
      end
    end
end

-- Register the protocol
DissectorTable.get("tcp.port"):add(9008, protocol)
