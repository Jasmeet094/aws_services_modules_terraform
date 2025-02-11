provider "aws" {
  alias  = "requester_acct"
  region = "us-east-1"
}

provider "aws" {
  alias  = "accepter_acct"
  region = "us-east-1"
}
