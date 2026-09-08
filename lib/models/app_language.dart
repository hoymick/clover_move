/// The five locales the product ships in, in the order shown on screen 01b.
enum AppLanguage {
  english('English', 'Ireland', 'en', 'IE'),
  portugueseBr('Portuguese BR', 'Brazil', 'pt', 'BR'),
  portuguesePt('Portuguese PT', 'Portugal', 'pt', 'PT'),
  spanish('Spanish', 'Spain', 'es', 'ES'),
  french('French', 'France', 'fr', 'FR');

  const AppLanguage(
    this.name,
    this.region,
    this.languageCode,
    this.countryCode,
  );

  final String name;
  final String region;
  final String languageCode;
  final String countryCode;
}
