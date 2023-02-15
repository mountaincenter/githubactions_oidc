data "http" "github_actions_openid_configuration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "github_actions" {
  url = jsondecode(data.http.github_actions_openid_configuration.response_body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.github_actions.certificates[*].sha1_fingerprint
}

data "aws_iam_policy_document" "example_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::384657981262:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # 特定のリポジトリの特定のブランチからのみ認証を許可する
    # condition {
    #   test     = "StringEquals"
    #   variable = "token.actions.githubusercontent.com:sub"
    #   values   = ["repo:<GitHubユーザー名>/<GitHubリポジトリ名>:ref:refs/heads/<ブランチ名>"]
    # }
    # 特定のリポジトリの全てのワークフローから認証を許可する場合はこっち
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:mountaincenter/githubactions_oidc:*"]
    }
  }
}

resource "aws_iam_role" "example" {
  name               = "oidc-example-role"
  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json
}

# 任意のポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.example.name
}