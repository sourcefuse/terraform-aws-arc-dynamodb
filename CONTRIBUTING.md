# Contributing to AWS ARC DynamoDB Module

We welcome contributions to the AWS ARC DynamoDB module! This document provides guidelines for contributing to the project.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/terraform-aws-arc-dynamodb.git
   cd terraform-aws-arc-dynamodb
   ```
3. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Guidelines

### Code Standards

- **Naming Conventions**: Use `snake_case` for variables, outputs, and resources
- **Documentation**: Include descriptions for all variables and outputs
- **Security**: Never hardcode sensitive information like passwords or keys
- **Formatting**: Maintain consistent code formatting using `terraform fmt`

### Terraform Best Practices

- Use meaningful resource and variable names
- Add appropriate comments for complex logic
- Follow the established module structure
- Include comprehensive validation blocks for input variables
- Use local values for complex expressions or repeated calculations

### Commit Message Format

We use semantic versioning in commit messages. Include the version bump type in your commit message:

```bash
# For breaking changes
git commit -m "feat: add new DynamoDB feature #major"

# For new features
git commit -m "feat: add autoscaling support #minor"

# For bug fixes
git commit -m "fix: resolve capacity validation issue #patch"
```

**Version Bump Types:**
- `#major` - Breaking changes
- `#minor` - New features (backward compatible)
- `#patch` - Bug fixes (backward compatible)

If no version type is specified, `#patch` is assumed by default.

### Pre-commit Hooks

We use pre-commit hooks to maintain code quality. Install and configure them:

```bash
# Install pre-commit
pip install pre-commit

# Install the git hook scripts
pre-commit install

# Run against all files (optional)
pre-commit run --all-files
```

The pre-commit configuration includes:
- YAML linting
- Terraform validation and formatting
- Documentation generation
- Go formatting (for tests)

### Testing

#### Terraform Validation

Before submitting a PR, ensure your code passes validation:

```bash
terraform init
terraform validate
terraform fmt -check -recursive
```

#### Unit Tests

We use [Terratest](https://terratest.gruntwork.io/) for testing. To run tests:

```bash
cd test/
go mod init github.com/sourcefuse/terraform-aws-arc-dynamodb
go get github.com/gruntwork-io/terratest/modules/terraform
go test
```

#### Integration Tests

For integration testing, ensure you have:
- Valid AWS credentials configured
- Appropriate IAM permissions
- Access to the AWS regions used in tests

### Documentation

- Update the main `README.md` if you add new features
- Add examples for new functionality in the `examples/` directory
- Include README files for new examples
- Update the usage guide in `docs/module-usage-guide/README.md`

## Submitting Changes

### Pull Request Process

1. **Update Documentation**: Ensure all documentation is updated
2. **Add Tests**: Include appropriate tests for new functionality
3. **Run Pre-commit**: Ensure all pre-commit hooks pass
4. **Create PR**: Open a pull request with a clear description

### PR Requirements

- **Clear Description**: Explain what changes you made and why
- **Reference Issues**: Link to any related issues
- **Breaking Changes**: Clearly document any breaking changes
- **Test Results**: Include test results if applicable

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows the style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

## Code Review Process

### Review Criteria

- **Functionality**: Does the code work as intended?
- **Security**: Are there any security concerns?
- **Performance**: Are there any performance implications?
- **Maintainability**: Is the code easy to understand and maintain?
- **Testing**: Is the code adequately tested?

### Automated Checks

All PRs undergo automated checks:
- **Security Scanning**: Snyk security analysis
- **Code Quality**: SonarCloud analysis
- **Terraform Validation**: Syntax and best practices
- **Documentation**: Ensure docs are up to date

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Workflow

1. **Version Bump**: Automated based on commit messages
2. **Changelog**: Auto-generated from commit history
3. **Tagging**: Git tags created for releases
4. **Registry Update**: Terraform Registry automatically updated

## Getting Help

### Resources

- **Documentation**: Check the `docs/` directory
- **Examples**: Review examples in the `examples/` directory
- **Issues**: Search existing issues on GitHub
- **Discussions**: Start a discussion for questions

### Support Channels

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Documentation**: Comprehensive guides in the `docs/` folder

## Recognition

We appreciate all contributions! Contributors will be:
- Listed in release notes
- Credited in the repository
- Invited to join our contributor community

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code:

- **Be Respectful**: Treat everyone with respect and consideration
- **Be Inclusive**: Welcome contributions from people of all backgrounds
- **Be Collaborative**: Work together constructively
- **Be Professional**: Maintain professional standards in all interactions

## License

By contributing to this project, you agree that your contributions will be licensed under the Apache 2.0 License.

---

Thank you for contributing to the AWS ARC DynamoDB module! Your contributions help make this project better for everyone.

For questions about contributing, please open an issue or start a discussion on GitHub.
