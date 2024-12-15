{
  config,
  pkgs,
  ...
}:

{

  programs = {
    chromium = {
      enable = true;
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://duckduckgo.com/?t=h_&q={searchTerms}";
    };
  };

}
