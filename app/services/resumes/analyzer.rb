class Resumes::Analyzer
  def self.call(raw_text, job_description)
    client = OpenAI::Client.new

    response = client.chat.completions.create(
      model: "gpt-4o",
      messages: [
        {
          role: "system",
          content: "Judge the match only from the supplied text, and never invent skills, metrics, or experience. Suggested wording may clarify what the resume already says."
        },
        {
          role: "user",
          content: "Resume:\n\n#{raw_text}\n\nJob Description:\n\n#{job_description}\n\nCompare the resume against the job description."
        }
      ],
      tools: [comparison_result_tool],
      tool_choice: { type: "function", function: { name: "comparison_result" } }
    )

    tool_call = response.choices.first.message.tool_calls.first
    JSON.parse(tool_call.function.arguments)
  end

  def self.comparison_result_tool
    {
      type: "function",
      function: {
        name: "comparison_result",
        description: "Generates a comparison result between a resume and a job description",
        parameters: {
          type: "object",
          properties: {
            overall_score: { type: "integer" },
            summary: { type: "string" },
            matched_requirements: { type: "array", items: { type: "string" } },
            missing_requirements: { type: "array", items: { type: "string" } },
            keyword_gaps: { type: "array", items: { type: "string" } },
            wording_suggestions: { type: "array", items: { type: "object", properties: { original: { type: "string" }, suggested: { type: "string" }, reason: { type: "string" } } } },
            total_years_experience: { type: "integer" },
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
          required: ["overall_score", "summary", "matched_requirements", "missing_requirements"]
        }
      }
    }
  end
end