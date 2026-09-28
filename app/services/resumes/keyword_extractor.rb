class Resumes::KeywordExtractor
  def self.call(job_description_text)
    client = OpenAI::Client.new

    response = client.chat.completions.create(
      model: "gpt-4o",
      messages: [
        {
          role: "system",
          content: "Extract the skills, tools, and technologies named in the job description. " \
                   "Only include terms that actually appear in the text; never add keywords the posting does not mention. " \
                   "Mark a keyword required or nice_to_have based on how the posting frames it. " \
                   "For each, list common alternate names or spellings as variants."
        },
        {
          role: "user",
          content: "Job Description:\n\n#{job_description_text}"
        }
      ],
      tools: [ keyword_extractor_tool ],
      tool_choice: { type: "function", function: { name: "keyword_extractor" } }
    )

    tool_call = response.choices.first.message.tool_calls.first
    JSON.parse(tool_call.function.arguments)["keywords"]
  end

  def self.keyword_extractor_tool
    {
      type: "function",
      function: {
        name: "keyword_extractor",
        description: "Extracts keywords from a job description",
        parameters: {
          type: "object",
          properties: {
            keywords: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  keyword: { type: "string", description: "A skill, tool, or technology named in the job description." },
                  importance: { type: "string", enum: [ "required", "nice_to_have" ] },
                  variants: { type: "array", items: { type: "string" }, description: "Common alternate names or spellings, e.g. Postgres for PostgreSQL." }
                },
                required: [ "keyword", "importance", "variants" ]
              }
            }
          },
          required: [ "keywords" ]
        }
      }
    }
  end
end
