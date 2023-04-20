workspace extends ../workspace.dsl {
    model {       
        deploymentEnvironment "Production" {
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"
                route53 = infrastructureNode "Route 53" {
                        tags "Amazon Web Services - Route 53"
                    }
                deploymentNode "US-East-1" {
                    tags ""
                    loadBalancer = infrastructureNode "Elastic Load Balancer"{
                        tags "Amazon Web Services - Elastic Load Balancing"
                    }
                    deploymentNode "Autoscaling Group" {
                        tags "Amazon Web Services - Auto Scaling"
                        deploymentNode "Amazon EC2" {
                            tags "Amazon Web Services - EC2"
                            apiAppInstance = containerInstance apiApp
                        }
                    }
                    deploymentNode "Amazon RDS" {
                        tags "Amazon Web Services - RDS Amazon RDS instance"
                        deploymentNode "Oracle" {
                            tags "Amazon Web Services - RDS Oracle instance"
                            dbInstance = containerInstance database
                        }
                    }
                }
            }
        }
        # Relationship
        route53 -> loadBalancer "Forward requests to [HTTPS]"
        loadBalancer -> apiAppInstance "Forward requests to [HTTPS]"
    }

    views {
        # deployment <software-system> <environment> <key> <description>
        deployment iBankingSys "Production" "Dep-002-PROD" "Production Deployment for Sample App" {
            include *
            autoLayout lr
        }

        theme "https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json"
    }
}