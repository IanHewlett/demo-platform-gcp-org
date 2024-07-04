resource "google_workflows_workflow" "file_processing_workflow" {
  name            = "file-processing-workflow"
  project         = var.project_name
  region          = var.region
  description     = "File Processing Workflow"
  service_account = var.workflow_sa

  user_env_vars = {
    url = "https://timeapi.io/api/Time/current/zone?timeZone=Europe/Amsterdam"
  }

  source_contents = <<-EOF
  # This is a sample workflow. You can replace it with your source code.
  #
  # This workflow does the following:
  # - reads current time and date information from an external API and stores
  #   the response in currentTime variable
  # - retrieves a list of Wikipedia articles related to the day of the week
  #   from currentTime
  # - returns the list of articles as an output of the workflow
  #
  # Note: In Terraform you need to escape the $$ or it will cause errors.

  - getCurrentTime:
      call: http.get
      args:
          url: $${sys.get_env("url")}
      result: currentTime
  - readWikipedia:
      call: http.get
      args:
          url: https://en.wikipedia.org/w/api.php
          query:
              action: opensearch
              search: $${currentTime.body.dayOfWeek}
      result: wikiResult
  - returnOutput:
      return: $${wikiResult.body[1]}
EOF
}

resource "google_eventarc_trigger" "file-intake-trigger" {
  for_each = toset(var.trigger_buckets)

  name                    = "${each.value}-trigger"
  project                 = var.project_name
  location                = var.region
  event_data_content_type = "application/json"
  service_account         = var.workflow_sa

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }

  matching_criteria {
    attribute = "bucket"
    value     = each.value
  }

  destination {
    workflow = google_workflows_workflow.file_processing_workflow.id
  }
}
