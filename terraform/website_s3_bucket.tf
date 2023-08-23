resource "aws_s3_bucket" "website_bucket" {
  bucket = "victor-website-assets-bucket"
  
  tags = {
    Name        = "victor-website-assets-bucket"
    Environment = "dev"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "../src/index.html"
  etag = filemd5("../src/index.html")
}