class Ats::KeywordMatcher
  def self.call(resume_text, keywords)
    text = resume_text.to_s.gsub(/\s+/, " ")
    result = { exact: [], variant: [], missing: [] }

    Array(keywords).each do |entry|
      bucket, extra = classify(text, entry)
      result[bucket] << entry.slice("keyword", "importance").merge(extra)
    end

    result
  end

private

  def self.pattern_for(term)
    /(?<![[:alnum:]])#{Regexp.escape(term)}(?![[:alnum:]])/i
  end

  def self.classify(text, entry)
    return [ :exact, {} ] if text.match?(pattern_for(entry["keyword"]))

    found = Array(entry["variants"]).find { |variant| text.match?(pattern_for(variant)) }
    return [ :variant, { "found_as" => found } ] if found

    [ :missing, {} ]
  end
end
