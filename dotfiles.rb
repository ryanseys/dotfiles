#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

class Dotfiles
  def initialize
    @home_dir = Dir.home
  end

  class Dotfile
    attr_reader :local_path, :repo_path

    def initialize(local_path:, repo_path:)
      @local_path = local_path
      @repo_path = repo_path
    end

    def sync_to_repo
      unless File.exist?(local_path)
        puts "[SKIPPED] File #{local_path} does not exist."
        return
      end

      unless File.exist?(repo_path)
        puts "[UPDATED] File #{repo_path} in repo does not yet exist. Copied from local."
        copy_file(local_path, repo_path, preserve_mtime: true)
        return
      end

      local_file_mtime = File.mtime(local_path)
      repo_file_mtime = File.mtime(repo_path)

      local_older = local_file_mtime < repo_file_mtime

      same_content = FileUtils.compare_file(local_path, repo_path)

      if local_older && !same_content
        puts "[SKIPPED] Local file is older than repo and has different contents so it's likely out of date."
        return
      end

      copy_file(local_path, repo_path, preserve_mtime: true)
    end

    def install
      unless File.exist?(local_path)
        puts "File #{local_path} does not yet exist... Copying..."
        copy_file(repo_path, local_path, preserve_mtime: true)
        return
      end

      local_file_mtime = File.mtime(local_path)
      repo_file_mtime = File.mtime(repo_path)

      local_newer = local_file_mtime > repo_file_mtime
      same_content = FileUtils.compare_file(local_path, repo_path)

      if local_newer && !same_content
        puts "[WARNING] Local file #{local_path} looks newer than repo file #{repo_path} and has different contents."
        puts "[WARNING] Run `./dotfiles.rb update` first?"
        return
      end

      copy_file(repo_path, local_path, preserve_mtime: true)
    end

    private

    def copy_file(from, to, preserve_mtime: false)
      puts "Copying #{from} to #{to}..."
      FileUtils.mkdir_p(File.dirname(to))
      FileUtils.cp(from, to, preserve: preserve_mtime)
    end
  end

  attr_reader :home_dir

  def on_shopify_computer?
    @on_shopify_computer ||= Dir.exist?("#{home_dir}/src/github.com/Shopify")
  end

  def on_spin?
    @on_spin ||= !ENV.fetch("SPIN", nil).nil?
  end

  def on_personal_computer?
    @on_personal_computer ||= !on_shopify_computer? && !on_spin?
  end

  def common_dotfiles
    @common_dotfiles ||= [
      Dotfile.new(local_path: "#{home_dir}/.aliases", repo_path: "common/aliases"),
      Dotfile.new(local_path: "#{home_dir}/.hushlogin", repo_path: "common/hushlogin"),
      Dotfile.new(local_path: "#{home_dir}/.gitignore_global", repo_path: "common/gitignore_global"),
      Dotfile.new(local_path: "#{home_dir}/.vimrc", repo_path: "common/vimrc"),
      Dotfile.new(local_path: "#{home_dir}/.gitconfig", repo_path: "common/gitconfig"),
      Dotfile.new(local_path: "#{home_dir}/.gitconfig_1pass", repo_path: "common/gitconfig_1pass"),
      Dotfile.new(local_path: "#{home_dir}/.zshrc", repo_path: "common/zshrc"),
      Dotfile.new(local_path: "#{home_dir}/.pryrc", repo_path: "common/pryrc"),
      Dotfile.new(local_path: "#{home_dir}/.irbrc", repo_path: "common/irbrc"),
      Dotfile.new(local_path: "#{home_dir}/.aprc", repo_path: "common/aprc"),
      Dotfile.new(local_path: "#{home_dir}/.oh-my-zsh/themes/ryanseys.zsh-theme", repo_path: "common/ryanseys.zsh-theme"),
      Dotfile.new(local_path: "#{home_dir}/bin/convert_utc.rb", repo_path: "common/bin/convert_utc.rb"),
      Dotfile.new(local_path: "#{home_dir}/bin/mine", repo_path: "common/bin/mine"),
    ]
  end

  def personal_dotfiles
    @personal_dotfiles ||= if on_personal_computer?
      [
        Dotfile.new(local_path: "#{home_dir}/.gitconfig_local", repo_path: "personal/gitconfig"),
        Dotfile.new(local_path: "#{home_dir}/.aliases_local", repo_path: "personal/aliases"),
        Dotfile.new(local_path: "#{home_dir}/.ruby-version", repo_path: "personal/ruby-version"),
        Dotfile.new(local_path: "#{home_dir}/.zshrc_local", repo_path: "personal/zshrc"),
        Dotfile.new(local_path: "#{home_dir}/.gemrc", repo_path: "personal/gemrc"),
      ]
    end
  end

  def spin_dotfiles
    @spin_dotfiles ||= if on_spin?
      puts "Detected: Spin 🌀"

      [
        Dotfile.new(local_path: "#{home_dir}/.gitconfig_local", repo_path: "shopify/gitconfig"),
        Dotfile.new(local_path: "#{home_dir}/.aliases_local", repo_path: "shopify/aliases"),
        Dotfile.new(local_path: "#{home_dir}/.zshrc_local", repo_path: "shopify/zshrc"),
      ]
    end
  end

  def shopify_dotfiles
    @shopify_dotfiles ||= if on_shopify_computer? && !on_spin?
      puts "Detected: Shopify Macbook 👨🏼‍💻"

      [
        Dotfile.new(local_path: "#{home_dir}/.gitconfig_local", repo_path: "shopify/gitconfig"),
        Dotfile.new(local_path: "#{home_dir}/.aliases_local", repo_path: "shopify/aliases"),
        Dotfile.new(local_path: "#{home_dir}/.gitmessage", repo_path: "shopify/gitmessage"),
        Dotfile.new(local_path: "#{home_dir}/.zshrc_local", repo_path: "shopify/zshrc"),
      ]
    end
  end

  def dotfiles
    @all_dotfiles ||= [common_dotfiles, personal_dotfiles, shopify_dotfiles, spin_dotfiles].flatten.compact
  end

  def install_dotfiles
    puts "Installing dotfiles..."

    dotfiles.each(&:install)

    puts "Done installing dotfiles!\n"
  end

  def update_dotfiles
    puts "Syncing computer dotfiles to this repo..."

    dotfiles.each(&:sync_to_repo)

    puts "Done syncing dotfiles! Don't forget to review the changes and push!"
  end

  def oh_my_zsh_installed?
    File.exist?("#{home_dir}/.oh-my-zsh/oh-my-zsh.sh")
  end

  def install_oh_my_zsh
    if oh_my_zsh_installed?
      puts "Oh My Zsh is already installed!"
      return
    end

    puts "Installing Oh My Zsh..."

    FileUtils.mv("#{home_dir}/.zshrc", "#{home_dir}/.zshrc.original") if File.exist?("#{home_dir}/.zshrc")

    system('ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended')

    return unless File.exist?("#{home_dir}/.zshrc")

    FileUtils.rm("#{home_dir}/.zshrc")
  end

  def install_plugin_by_url(url)
    name = url.split("/").last
    install_dir = "#{home_dir}/.oh-my-zsh/custom/plugins/#{name}"

    if Dir.exist?(install_dir)
      puts "Plugin #{name} already installed."
      return
    end

    puts "Cloning #{url} to #{install_dir}"
    system("git clone #{url} #{install_dir}")
  end

  def install_oh_my_zsh_plugins
    install_plugin_by_url("https://github.com/zsh-users/zsh-completions")
    install_plugin_by_url("https://github.com/zsh-users/zsh-autosuggestions")
    install_plugin_by_url("https://github.com/zsh-users/zsh-history-substring-search")
    install_plugin_by_url("https://github.com/zsh-users/zsh-syntax-highlighting")
  end

  MINIMUM_RUBY_VERSION = Gem::Version.new("3.1.0")

  def install_ruby_install
    print "Checking if have ruby-install..."
    ruby_install_installed = system("which ruby-install", out: File::NULL)

    if ruby_install_installed
      puts "✅ Installed."
    else
      puts "❌ Not installed."
      puts "Installing ruby-install..."
      system("brew install ruby-install")
    end
  end

  def check_ruby_installed_with_ruby_install
    puts "Checking if Ruby is installed with ruby-install..."
    current_ruby_installed = `which ruby` # /Users/ryanseys/.rubies/ruby-3.3.4/bin/ruby

    installed_with_ruby_install = current_ruby_installed.include?("rubies")

    if installed_with_ruby_install
      puts "Ruby installed and configured with ruby-install. ✅"
    else
      puts "❌ Not installed."
      puts "Please install ruby-install first."
      exit 1
    end
  end

  def install_rails
    check_ruby_installed_with_ruby_install
  end

  def install_homebrew
    print "Checking if Homebrew is installed..."
    homebrew_installed = system("which brew", out: File::NULL)

    if homebrew_installed
      puts "✅ Installed."
    else
      puts "❌ Not installed."
      puts "Installing Homebrew..."
      system('NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
    end
  end

  def install_homebrew_package(package_name)
    print "Checking if #{package_name} is installed..."

    if homebrew_package_installed?(package_name)
      puts "✅ Installed."
    else
      puts "❌ Not installed."
      puts "Installing #{package_name}..."
      system("brew install #{package_name}")
    end
  end

  def installed_homebrew_packages
    @installed_homebrew_packages ||= `brew list`.split("\n").to_set
  end

  def installed_homebrew_casks
    @installed_homebrew_casks ||= `brew list --cask`.split("\n").to_set
  end

  def homebrew_package_installed?(package_name)
    installed_homebrew_packages.include?(package_name)
  end

  def homebrew_cask_installed?(package_name)
    installed_homebrew_casks.include?(package_name)
  end

  HOMEBREW_PACKAGES = [
    "autoconf",
    "ack",
    "bash",
    "chruby",
    "cloudflared",
    "ctags",
    "coreutils", # GNU core utilities
    "curl",
    "dockutil",
    "docker",
    "docker-compose",
    "ffmpeg",
    "fzf",
    "font-inconsolata",
    "gnupg",
    "go",
    "git",
    "git-lfs",
    "htop",
    "gh", # GitHub CLI
    "jq",
    "kafka",
    "llvm",
    "nginx",
    "nmap",
    "node",
    "openssl@3",
    "podman",
    "podman-compose",
    "postgresql@16",
    "python@3.12",
    "rename",
    "redis",
    "rust",
    "sqlite",
    "stripe-cli",
    "shellcheck",
    "ssh3",
    "trash",
    "tree",
    "tmux",
    "tower",
    "watch",
    "wget",
    "yarn",
    "vim",
    "zsh",
  ]

  HOMEBREW_CASKS = [
    "1password",
    "appcleaner",
    "betterdisplay",
    "calibre",
    "cloudflare-warp",
    "chatgpt",
    "discord",
    "firefox",
    "google-chrome",
    "google-drive",
    "imageoptim",
    "iterm2",
    "jan",
    "keepingyouawake",
    "logi-options-plus",
    "logseq",
    "monitorcontrol",
    "notion",
    "ollama",
    "podman-desktop",
    "raycast",
    "rectangle",
    "rubymine",
    "slack",
    "spotify",
    "the-unarchiver",
    "tableplus",
    "todoist",
    "tor-browser",
    "visual-studio-code",
    "warp", # warp.dev
    "whatsapp",
    "zoom",
  ]

  def install_homebrew_cask_package(cask_name)
    print "Checking if cask #{cask_name} is installed... "

    if homebrew_cask_installed?(cask_name)
      puts "✅ Installed."
    else
      puts "❌ Not installed."
      puts "Installing #{cask_name}..."
      system("brew install --cask #{cask_name} --force")
    end
  end

  def install_homebrew_packages
    return puts "Skipping homebrew install on work computer" unless on_personal_computer?
    return puts "Homebrew not installed" unless system("which brew", out: File::NULL)

    HOMEBREW_PACKAGES.each do |package|
      install_homebrew_package(package)
    end
  end

  def install_homebrew_cask_packages
    return puts "Skipping homebrew install on work computer" unless on_personal_computer?
    return puts "Homebrew not installed" unless system("which brew", out: File::NULL)

    puts "Installing Homebrew cask packages..."

    HOMEBREW_CASKS.each do |package|
      install_homebrew_cask_package(package)
    end
  end

  def install_everything
    ENV["HOMEBREW_NO_ANALYTICS"] = "1"
    ENV["HOMEBREW_NO_GITHUB_API"] = "1"

    install_homebrew
    install_homebrew_packages
    install_homebrew_cask_packages
    install_ruby_install
    install_rails

    install_oh_my_zsh
    install_oh_my_zsh_plugins
    install_dotfiles

    puts "Done installing everything!"
  end

  def update_homebrew_packages
    return unless on_personal_computer?

    puts "Running brew update..."
    system("brew update")

    puts "Running brew upgrade..."
    system("brew upgrade")

    puts "Running brew cleanup..."
    system("brew cleanup")

    puts "Running brew doctor..."
    system("brew doctor")

    puts "Done updating Homebrew packages!"
  end

  def update_mac_os
    return unless on_personal_computer?

    puts "Updating macOS..."

    system("softwareupdate -ia")

    puts "Done updating macOS!"
  end

  def update_everything
    update_dotfiles
    update_homebrew_packages
    update_mac_os

    puts "Done updating everything!"
  end

  def run_it!
    command = ARGV.shift

    puts "Detected: Personal Macbook 🤪" if on_personal_computer?
    puts "Detected: Shopify Macbook 👨🏼‍💻" if on_shopify_computer?
    puts "Detected: Spin Environment 🌀" if on_spin?

    case command
    when "install"
      install_everything
    when "update"
      update_everything
    else
      puts "Usage: #{$PROGRAM_NAME} install|update"
      exit 1
    end
  end
end

Dotfiles.new.run_it!
