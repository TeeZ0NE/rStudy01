sub main(obj)
  ? obj
  ' Print info from Roku
  appInfo = CreateObject("roAppInfo")
  ? "App Title: ", appInfo.getTitle()
  ? "App Version: ", appInfo.getVersion()
  ? "Channel ID: ", appInfo.getID()
  ? "isDev: ", appInfo.isDev()
  ? "Custom field 1: ", appInfo.getValue("custom_field_1")
  ? "Custom field 2: ", appInfo.getValue("custom_field_2")
  ? "Subtitle: ", appInfo.getSubtitle()
  ' Print info from device
  ? "-------------"
  deviceInfo = CreateObject("roDeviceInfo")
  ? "Model: ", deviceInfo.getModel()
  ? "Display name: ", deviceInfo.getModelDisplayName()
  ? "Firmware: ", deviceInfo.getVersion()
  ? "Device ID: ", deviceInfo.getChannelClientId()
  ? "Friendly name: ", deviceInfo.getFriendlyName()
  displaySize = deviceInfo.getDisplaySize()
  ? "Dispaly size: ", displaySize.w;"x";displaySize.h
  ? "Display resolution: ", deviceInfo.getUIResolution()
  ? "Video Mode: ", deviceInfo.getVideoMode()
  ? "IP Address: ", deviceInfo.getExternalIp()
end sub