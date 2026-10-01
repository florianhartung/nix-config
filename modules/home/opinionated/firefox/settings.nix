# For info how to use, see:
# <https://searchfox.org/mozilla-release/source/browser/app/profile/firefox.js>

{
  project-lib,
  config,
}:
project-lib.utils.flattenNestedSets {
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "layout.css.prefers-color-scheme.content-override" = 0;

  "browser.download.dir" = "~/${config.xdg.userDirs.download}";
  "browser.startup.page" = 3; # 0 = blank, 1 = home (browser.startup.homepage), 2 = last visited page, 3 = resume previous browser session
  "browser.uiCustomization.state" = {
    placements = {
      widget-overflow-fixed-list = [

      ];
      unified-extensions-area = [

      ];
      nav-bar = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "customizableui-special-spring1"
        "urlbar-container"
        "customizableui-special-spring2"
        "downloads-button"
        "unified-extensions-button"
      ];
      toolbar-menubar = [
        "menubar-items"
      ];
      TabsToolbar = [
        "firefox-view-button"
        "tabbrowser-tabs"
        "new-tab-button"
        "alltabs-button"
      ];
      PersonalToolbar = [

      ];
    };
    seen = [
      "save-to-pocket-button"
      "developer-button"
    ];
    dirtyAreaCache = [
      "nav-bar"
      "PersonalToolbar"
      "toolbar-menubar"
      "TabsToolbar"
    ];
    currentVersion = 20;
    newElementCount = 8;
  };
}
// project-lib.utils.flattenNestedSets {
  "browser.newtabpage.activity-stream" = {
    "showSponsoredTopSites" = false;
    "showSponsored" = false;
    "showRecentSaves" = false;
    "feeds.topsites" = false;
  };
}
