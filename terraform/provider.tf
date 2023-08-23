provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files = ["~/.aws/config"]
  skip_metadata_api_check = true
}