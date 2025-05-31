# Create the OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# IAM role to be assumed by GitHub Actions via OIDC
resource "aws_iam_role" "github_oidc_deploy" {
  name = "${local.bot_name}-github-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            # Adjust with your actual repo and branch
            "token.actions.githubusercontent.com:sub" = "repo:${local.repo}:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# Policy for ECS + ECR deployments
resource "aws_iam_policy" "github_oidc_policy" {
  name        = "${local.bot_name}-github-oidc-policy"
  description = "Allow ECS and ECR deployment from GitHub Actions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",

          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "ecs:DescribeServices",

          "iam:PassRole",

          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "github_oidc_policy_attach" {
  role       = aws_iam_role.github_oidc_deploy.name
  policy_arn = aws_iam_policy.github_oidc_policy.arn
}
