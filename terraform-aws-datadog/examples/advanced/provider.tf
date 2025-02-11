terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "2.16.0"
    }
  }
}

provider "datadog" {
  # api_key = var.datadog_api_key
  # app_key = var.datadog_app_key
}

## SET VIA tf vars by uncommenting the above settings or export the following environment variables
// export DD_API_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
// export DD_APP_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
