class Resumes::Analyzer
  def self.call(raw_text)
    client = OpenAI::Client.new

    response = client.chat.completions.create(
      model: "gpt-4o",
      messages: [
        { role: "user", content: "Extract structured data from this resume:\n\n#{raw_text}" }
      ],
      tools: [resume_extraction_tool],
      tool_choice: { type: "function", function: { name: "extract_resume" } }
    )

    tool_call = response.choices.first.message.tool_calls.first
    JSON.parse(tool_call.function.arguments)
  end

  def self.resume_extraction_tool
    {
      type: "function",
      function: {
        name: "extract_resume",
        description: "Extracts structured fields from resume text",
        parameters: {
          type: "object",
          properties: {
            summary: { type: "string" },
            skills: { type: "array", items: { type: "string" } },
            total_years_experience: { type: "number" },
            roles: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  title: { type: "string" },
                  company: { type: "string" },
                  duration: { type: "string" }
                }
              }
            }
          },
          required: ["skills", "roles"]
        }
      }
    }
  end
end