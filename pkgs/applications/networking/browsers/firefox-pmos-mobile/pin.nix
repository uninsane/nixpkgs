{
  policies = {
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "normal_installed";
      };
    };
    FirefoxHome = {
      Highlights = false;
      Locked = false;
      Pocket = false;
      Search = true;
      Snippets = false;
      TopSites = false;
    };
    Homepage = {
      Locked = false;
      StartPage = "homepage";
      URL = "about:home";
    };
    NoDefaultBookmarks = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    SearchEngines = {
      Default = "DuckDuckGo";
      Remove = [
        "1&1 Suche"
        "Allaannonser"
        "Allegro"
        "Am Faclair Beag"
        "Amazon.ca"
        "Amazon.co.jp"
        "Amazon.co.uk"
        "Amazon.com"
        "Amazon.com.au"
        "Amazon.de"
        "Amazon.es"
        "Amazon.fr"
        "Amazon.in"
        "Amazon.it"
        "Amazon.nl"
        "Amazon.se"
        "Atlas"
        "Azerdict"
        "Azet"
        "BBC ┐ BBC Alba"
        "Bing"
        "Ceneje.si"
        "Chambers (UK)"
        "Cốc Cốc"
        "DIEC2"
        "Diccionario RAE"
        "EUdict Eng->Cro"
        "Ecosia"
        "Encyklopedia PWN"
        "Freelang (br)"
        "GMX - Búsqueda web"
        "GMX - Recherche web"
        "GMX Search"
        "GMX Shopping"
        "GMX Suche"
        "Google"
        "Gule sider"
        "Heureka"
        "Hotline"
        "Kannada Store"
        "LEO Eng-Deu"
        "List.am"
        "Mapy.cz"
        "Marktplaats.nl"
        "MercadoLibre Argentina"
        "MercadoLibre Chile"
        "MercadoLibre Mexico"
        "MercadoLivre"
        "Najdi.si"
        "Neti"
        "OLX.ba"
        "OZON.ru"
        "Odpiralni Časi"
        "Ordbok"
        "Osta"
        "Palas Print"
        "Pazaruvaj"
        "Priberam"
        "Price.ru"
        "Prisjakt"
        "QXL"
        "Qwant"
        "Qwant Junior"
        "Readmoo 讀墨電子書"
        "SS.lv"
        "Salidzini.lv"
        "Seznam"
        "Tyda.se"
        "Vatera.hu"
        "WEB.DE Suche"
        "Wikiccionari (oc)"
        "Wolne Lektury"
        "Yahoo! JAPAN"
        "Yandex"
        "Zoznam"
        "bol.com"
        "channel"
        "clid"
        "eBay"
        "flip.kz"
        "mail.com"
        "mail.com search"
        "tearma.ie"
        "Õigekeelsussõnaraamat"
        "Погодак"
        "Поиск Mail.Ru"
        "Яндекс"
        "מילון מורפיקס"
        "విక్షనరీ (te)"
        "พจนานุกรม ลองดู"
        "ヤフオク!"
        "亚马逊"
        "教えて！goo"
        "楽天市場"
        "百度"
        "네이버"
        "다음"
      ];
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      SkipOnboarding = false;
      UrlbarInterventions = false;
      WhatsNew = false;
    };
  };
  sha256 = "07vgjg15id74pyjzhxl97hjsaz8a0hj54wq2vxfblxds6k5pak04";
  version = "4.0.2";
}
