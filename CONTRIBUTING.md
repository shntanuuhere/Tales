# Contributing to Tales

Thank you for considering contributing to Tales! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## Codebase Structure

Please familiarize yourself with our [codebase structure](CODEBASE_STRUCTURE.md) before contributing. The project follows clean architecture principles with a feature-based approach.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list to avoid duplicates. When you create a bug report, include as many details as possible:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior vs. actual behavior
- Screenshots if applicable
- Your environment details (OS, Flutter version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- Use a clear and descriptive title
- Provide a detailed description of the suggested enhancement
- Explain why this enhancement would be useful
- Include mockups or examples if possible

### Pull Requests

- Fill in the required template
- Follow the Flutter style guide
- Include tests when applicable
- Update documentation as needed
- Make sure all tests pass

## Development Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/tales.git`
3. Set up the development environment as described in the README.md
4. Create a new branch for your changes: `git checkout -b feature/your-feature-name`

## Style Guides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

### Dart Style Guide

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Run `flutter analyze` before submitting to ensure your code has no issues
- Use meaningful variable and function names

### Architecture Guidelines

- Follow clean architecture principles
- Organize code by feature, not by layer
- Use dependency injection for all dependencies
- Write tests for all layers
- Document your code with comments and README files
- Keep the UI layer separate from business logic

## Additional Notes

### Issue and Pull Request Labels

This project uses labels to categorize issues and pull requests:

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements or additions to documentation
- `good first issue`: Good for newcomers

Thank you for contributing to Tales!