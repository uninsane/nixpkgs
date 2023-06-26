{
  policies = {
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    Homepage = {
      Locked = false;
      StartPage = "homepage";
      URL = "file:///usr/share/mobile-config-firefox/home.html";
    };
    NewTabPage = false;
    NoDefaultBookmarks = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    SearchEngines = { Default = "DuckDuckGo"; };
    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      WhatsNew = false;
    };
  };
  version = "2.2.0";
  sha256 = "1kpdx7qs74g4s22ijb4mbx6rr8j2s0lwlknc53gpvpdirv2j9f02";
}
