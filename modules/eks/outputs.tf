output "eks_endpoint" {
  value       = aws_eks_cluster.eks.endpoint
  description = "The endpoint for the EKS cluster."
}
