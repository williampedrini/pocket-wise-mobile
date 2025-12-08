# Setup Guide

This guide provides step-by-step instruction to set up the project development environment.

---

## 🚀 Claude Code Quick Start

Claude Code is Anthropic's terminal-based AI coding assistant. It understands your entire codebase, executes commands, edits files, and manages git workflows through natural language prompts.

### 📦 Installation

Use Homebrew to install Claude Code on macOS. This is the recommended installation method as it handles dependencies and provides automatic updates.

```bash
brew install --cask claude-code
```

### ▶️ First Run

Navigate to your project directory and launch Claude Code. On first run, you'll be prompted to authenticate.

```bash
claude
```

🔐 Authenticate via Claude Console or Pro/Max subscription

### ⚡ Essential Commands

These slash commands are available within a Claude Code session. Type them directly in the prompt to execute.

| Command    | Description                           |
|------------|----------------------------------------|
| `/init`    | 📝 Generate CLAUDE.md for your project |
| `/help`    | ❓ Show all available commands          |
| `/clear`   | 🧹 Clear conversation context          |
| `/compact` | 📦 Compress long conversations         |
| `/cost`    | 💰 Check token usage & spending        |
| `/bug`     | 🐛 Report issues to Anthropic          |

### 🛠️ CLI Flags

These flags are passed when launching Claude Code from your terminal. They modify startup behavior and permissions.

```bash
claude --version          # Check version
claude --help             # Show options
claude "your prompt"      # Start with initial prompt
claude --permission-mode acceptEdits  # Auto-accept file edits
```

### 💡 Tips

Best practices to get the most out of Claude Code in your daily workflow.

- ✅ Run `/init` on existing projects — it's optional but helpful
- 🔄 Homebrew install auto-updates automatically
- 📁 CLAUDE.md = persistent project context
- 🎯 Use `/compact` when conversations get long

---

## 📐 Ruler Setup Guide

Ruler centralizes AI coding assistant instructions, distributing them to agent-specific configuration files (Claude Code, Copilot, Cursor, Junie, etc.). Instead of maintaining separate instruction files for each tool, you write once and Ruler generates the rest.

### ✅ Prerequisites

Ruler requires Node.js 18 or higher. Install via Homebrew and verify the installation.

```bash
brew install node
node --version
npm --version
```

### 📦 Install Ruler

Install Ruler globally via npm to make the `ruler` command available system-wide.

```bash
npm install -g @intellectronica/ruler
```

### ⚙️ How It Works

Ruler uses a central instructions file and a configuration file to generate agent-specific outputs. This keeps your coding standards consistent across all AI tools.

1. Write your coding standards in `.ruler/instructions.md`
2. Configure target agents in `.ruler/ruler.toml`
3. Run `ruler apply` to generate agent-specific files (CLAUDE.md, .github/copilot-instructions.md, etc.)

### 🛠️ Commands

Core Ruler commands for managing your AI assistant configurations.

| Command                             | Description                          |
|-------------------------------------|--------------------------------------|
| `ruler apply`                       | Apply rules to all configured agents |
| `ruler apply --agents claude,junie` | Apply to specific agents             |
| `ruler apply --dry-run`             | Preview changes without writing      |
| `ruler revert`                      | Remove generated config files        |