# Agent Guidelines for i3 Configuration Repository

## Build/Lint/Test Commands

### Linting and Formatting
- **Pre-commit hooks**: `pre-commit run --all-files` (includes black, flake8, isort, codespell, shfmt, shellcheck)
- **Python formatting**: `black .`
- **Python imports**: `isort .`
- **Python linting**: `flake8 .`
- **Shell formatting**: `shfmt -w .`
- **Shell linting**: `shellcheck **/*.sh`

### Testing
This is a configuration repository with no traditional unit tests. Manual testing of i3 configurations is required.

### Single Test/File Commands
- **Lint specific Python file**: `flake8 path/to/file.py`
- **Format specific Python file**: `black path/to/file.py`
- **Check specific shell script**: `shellcheck path/to/script.sh`

## Code Style Guidelines

### Python Code Style
- **Python version**: 3.12+
- **Formatting**: Black (4-space indentation, 88 char line length)
- **Imports**: isort (alphabetical, stdlib first, then third-party, then local)
- **Type hints**: Use modern type annotations (list[Type], dict[Key, Value])
- **Dataclasses**: Prefer dataclasses for simple data structures
- **Naming**: snake_case for variables/functions, PascalCase for classes
- **Error handling**: Use try/except with specific exceptions, log errors appropriately
- **Docstrings**: Use triple quotes for module/class/function documentation

### Shell Script Style
- **Shebang**: `#!/bin/bash` or `#!/usr/bin/env bash`
- **Error handling**: `set -e` for strict error checking
- **Variables**: Use `readonly` for constants, `local` for function variables
- **Functions**: Document with comments, use descriptive names
- **Quotes**: Always quote variables, use double quotes for strings

### Configuration Files
- **EditorConfig**: Follow .editorconfig settings (spaces, UTF-8, final newlines)
- **YAML**: 2-space indentation for YAML files
- **JSON**: Consistent formatting for layout files

### General Guidelines
- **Comments**: Use clear, descriptive comments for complex logic
- **Security**: Never log or expose sensitive information
- **Dependencies**: Check pyproject.toml before adding new Python dependencies
- **Git**: Use meaningful commit messages, follow conventional commits when possible</content>
<parameter name="filePath">AGENTS.md