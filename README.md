er18ern
=======

i18n extensions and utilities

Put this in an initializer

    Er18Ern::RailsApp.setup!

Put this in script/ermahgerd

    require 'er18ern'

    translator = Er18Ern::Translator.new
    translator.locales_dir = File.expand_path('../../config/locales/', __FILE__)
    translator.google_translator_hax_locale_dirs = File.expand_path('../../config/locale_hax/', __FILE__)

    translator.generate_ermahgerd!
    translator.resave_en!
    translator.save_jp!
    translator.save_engrish!
    translator.generate_google_translations! #have to do this last because it could override the matching of the jp and engrish

Use copy/paste with google translate to:
  locale_hax/GOOGLE_TRANSLATE_INPUT (en) --> locale_hax/GOOGLE_TRANSLATE_OUTPUT (jp)
  locale_hax/GOOGLE_TRANSLATE_OUTPUT (jp) --> ?? --> ?? --> ?? --> locale_hax/GOOGLE_TRANSLATE_AGAIN (engrish)

TODO: write some tests!