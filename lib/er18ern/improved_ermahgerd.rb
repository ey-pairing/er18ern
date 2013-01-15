require 'ermahgerd'

module Er18Ern
  module ImprovedErmahgerd

    def self.translate(words)
      words.gsub(/([{]?)([&]?)\w+/) do |word|
        if $1 == "{" || $2 == "&"
          word
        else
          translate_word(word.upcase)
        end
      end
    end

    def self.translate_word(word)
      case word
      when "ENGINE"
        "ERNGIN"
      when "YARD"
        "YERD"
      else
        Ermahgerd.translate_word(word)
      end
    end

  end

  class Translator
    attr_accessor :locales_dir, :google_translator_hax_locale_dirs

    def en_source_yaml
      @en_source_yaml ||= YAML::load_file(File.expand_path('en.yml', self.locales_dir))
    end

    def generate_ermahgerd!
      traverse = Proc.new do |x, translator|
        if x.is_a?(Hash)
          result = {}
          x.each do |k, v|
            result[k] = traverse.call(v, translator)
          end
          result
        else
          translator.call(x)
        end
      end

      errm = {}
      errm['ermahgerd'] = en_source_yaml["en"]

      #save ermahgerd
      File.open(File.expand_path('ermahgerd.yml', self.locales_dir), "w") do |fp|
        fp.write(traverse.call(errm, lambda{|x| ImprovedErmahgerd.translate(x)}).to_yaml)
      end
    end

    def resave_en!
      #re-save EN
      File.open(File.expand_path('en.yml', self.locales_dir), "w") do |fp|
        fp.write(en_source_yaml.to_yaml)
      end
    end

    def found_keys
      @found_keys ||= begin
        found_keys = {}
        key_collector = Proc.new do |x, key_prefix|
          if x.is_a?(Hash)
            result = {}
            x.each do |k, v|
              result[k] = key_collector.call(v, "#{key_prefix}.#{k}")
            end
            result
          else
            found_keys[key_prefix] = x
          end
        end
        key_collector.call(en_source_yaml["en"], "")
        found_keys
      end
    end

    def generate_google_translations!
      vals = found_keys.values.uniq.map do |val|
        strip_string(val)
      end

      File.open(File.expand_path('GOOGLE_TRANSLATE_INPUT', self.google_translator_hax_locale_dirs), "w") do |fp|
        fp.write(vals.join("\n---\n"))
      end
    end

    def save_engrish!
      enstuff = File.read(File.expand_path('GOOGLE_TRANSLATE_INPUT', self.google_translator_hax_locale_dirs)).split("\n---\n")
      engrishstuff = File.read(File.expand_path('GOOGLE_TRANSLATE_AGAIN', self.google_translator_hax_locale_dirs)).split("\n---\n")
      engrish = doitstuff(enstuff, found_keys, "engrish", engrishstuff)

      File.open(File.expand_path('engrish.yml', self.locales_dir), "w") do |fp|
        fp.write(engrish.to_yaml)
      end
    end

    def save_jp!
      enstuff = File.read(File.expand_path('GOOGLE_TRANSLATE_INPUT', self.google_translator_hax_locale_dirs)).split("\n---\n")
      jpstuff = File.read(File.expand_path('GOOGLE_TRANSLATE_OUTPUT', self.google_translator_hax_locale_dirs)).split("\n---\n")
      jp = doitstuff(enstuff, found_keys, "jp", jpstuff)

      File.open(File.expand_path('jp.yml', self.locales_dir), "w") do |fp|
        fp.write(jp.to_yaml)
      end
    end

    def copy_missing_into!(place)
      en_source_yaml["en"]
      output = YAML::load_file(File.expand_path("#{place}.yml", self.locales_dir))
      traverse = Proc.new do |x, y|
        if x.is_a?(Hash)
          x.each do |k, v|
            y[k] ||= v
            traverse.call(v, y[k])
          end
        end
      end
      traverse.call(en_source_yaml["en"], output[place])
      File.open(File.expand_path("#{place}.yml", self.locales_dir), "w") do |fp|
        fp.write(output.to_yaml)
      end
    end

    private

    def doitstuff(enstuff, found_keys, locale, stuff)
      lookup = {}
      found_keys.each do |k, v|
        if index = enstuff.index(strip_string(v))
          lookup[k] = stuff && stuff[index]
        end
      end

      jp = {locale => {}}
      lookup.each do |k, v|
        hash = jp[locale]
        last = nil
        k.split(".").each do |key_part|
          unless key_part.empty?
            last_hash = hash
            last = Proc.new do |str|
              en_string = found_keys[k]
              en_string_parts = strip_string(en_string).split("***")
              jp_string_parts = str.split("***")
              en_string_parts.each_with_index do |part, index|
                jp_corresponding = jp_string_parts[index] || "" # "MISSING TRANSLATION"
                en_string = en_string.gsub(part.to_s, jp_corresponding)
              end
              last_hash[key_part] = en_string
            end
            hash[key_part] ||= {}
            hash = hash[key_part]
          end
        end
        last.call(v)
      end
      jp
    end

    def strip_string(str)
      str.gsub(/([%]?)([&]?)([{]?)\w+([;]?)([}]?)/) do |word|
        if $1 == "%" || $2 == "&"
          "***"
        else
          word
        end
      end
    end

  end
end