# AWS Official MCP servers

## Overview

AWS MCP (Model Context Protocol) Servers are specialized servers developed by AWS Labs that enhance AI applications' interactions with AWS services. These servers provide AI assistants like Claude with contextual access to AWS documentation, guidance, and best practices, enabling more accurate and efficient cloud-native development through a standardized client-server architecture.

<https://awslabs.github.io/mcp/>

## Key Benefits

- **Improved Output Quality**: Provides relevant, up-to-date AWS information to AI assistants
- **Latest Documentation**: Access to current AWS documentation and service capabilities
- **Workflow Automation**: Enables automation of complex AWS-related workflows
- **Domain Expertise**: Delivers specialized knowledge about AWS services and best practices

## Server Categories

AWS Labs provides MCP servers organized into the following categories:

1. **Documentation**: Access to AWS documentation and knowledge bases
2. **Infrastructure & Deployment**: Tools for infrastructure management and deployment
3. **AI & Machine Learning**: Integration with AWS AI/ML services
4. **Data & Analytics**: Data processing and analytics capabilities
5. **Developer Tools & Support**: Development and debugging support
6. **Integration & Messaging**: Event-driven and messaging services
7. **Cost & Operations**: Cost management and operational tools
8. **Healthcare & Lifesciences**: Industry-specific services

## Notable MCP Servers

- **AWS API MCP Server**: Direct AWS API interaction
- **AWS Documentation MCP Server**: AWS documentation access
- **AWS Knowledge MCP Server**: AWS best practices and guidance
- **Bedrock Knowledge Bases Retrieval MCP Server**: Knowledge base integration
- **Service-Specific Servers**: DynamoDB, EKS, Lambda, S3, and more

## Deployment Options

- **Local Servers**: Best for development, testing, and offline work
- **Remote Servers**: Ideal for team collaboration, scalability, and automatic updates

## Use Cases

- Cloud-native application development with AI assistance
- Infrastructure as Code (IaC) with intelligent AWS service recommendations
- Automated AWS resource management and optimization
- Context-aware troubleshooting and debugging
- Best practices guidance for AWS architectures

These servers enable AI assistants to provide intelligent, context-aware support for AWS-related tasks, improving development velocity and code quality.

## Add at user scope in claude code

```shell
claude mcp add --transport stdio --scope user awsdoc -e AWS_DOCUMENTATION_PARTITION=aws -- uvx awslabs.aws-documentation-mcp-server@latest
```

```shell
claude mcp add --transport stdio --scope user awseks -- uvx awslabs.eks-mcp-server@latest --allow-sensitive-data-access
```
