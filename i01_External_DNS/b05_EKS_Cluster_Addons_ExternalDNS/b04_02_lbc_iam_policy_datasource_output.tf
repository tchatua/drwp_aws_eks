# LBC IAM Policy

output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.response_body
}
