require_relative '../wraps/wrapped_issue'

module RedmineDiscord
    class NewIssueEmbed
        def initialize(context)
            @wrapped_issue = WrappedIssue.new context[:issue]
        end

        def to_embed_array
            # prepare fields in heading embed
            heading_fields = [
                @wrapped_issue.to_author_field,
                @wrapped_issue.to_assignee_field,
                @wrapped_issue.to_due_date_field,
                @wrapped_issue.to_estimated_hours_field,
                @wrapped_issue.to_priority_field,
            ].select {|field| field != nil}

            description_field = @wrapped_issue.to_description_field

            if description_field != nil then
                heading_fields.push get_separator_field
                heading_fields.push description_field
            end

            heading_url = @wrapped_issue.resolve_absolute_url rescue ""

            return [{
                'url' => heading_url,
                'title' => "[New issue] #{@wrapped_issue.to_heading_title}",
                'color' => get_fields_color,
                'fields' => heading_fields
            }]
        end
    
    private
        def get_fields_color
            return 65280
        end

        def get_separator_field
            return {
                'name' => '---------------------------',
                'value' => "\u200b",
                'inline' => false
            }
        end
    end
end