#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

class Dotfile
  attr_reader :local_path, :repo_path

  def initialize(local_path:, repo_path:)
    @local_path = local_path
    @repo_path = repo_path
  end

  def sync_to_repo
    unless File.exist?(local_path)
      puts "File #{local_path} does not exist. Skipping sync..."
      return
    end

    unless File.exist?(repo_path)
      puts "File #{repo_path} in repo does not yet exist... Copying..."
      copy_file(local_path, repo_path, preserve_mtime: true)
      return
    end

    local_file_mtime = File.mtime(local_path)
    repo_file_mtime = File.mtime(repo_path)

    local_older = local_file_mtime < repo_file_mtime

    same_content = FileUtils.compare_file(local_path, repo_path)

    if local_older && !same_content
      puts "Local file looks older than repo and has different contents so its likely out of date. Skipping..."
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
      puts "Local file #{local_path} looks newer than repo file #{repo_path} and has different contents."
      puts "Run `./dotfiles.rb update` first?"
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

def home_dir
  @home_dir ||= Dir.home
end

def on_shopify_computer?
  Dir.exist?("#{home_dir}/src/github.com/Shopify")
end

def on_spin?
  !ENV.fetch("SPIN", nil).nil?
end

def on_personal_computer?
  !on_shopify_computer? && !on_spin?
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
  ]
end

def personal_dotfiles
  @personal_dotfiles ||= if on_personal_computer?
    puts "Detected: Personal Macbook 🤪"

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
      Dotfile.new(local_path: "#{home_dir}/install_rubymine_on_spin.sh", repo_path: "shopify/install_rubymine_on_spin.sh"),
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

  if File.exist?("#{home_dir}/.zshrc")
    FileUtils.mv("#{home_dir}/.zshrc", "#{home_dir}/.zshrc.original")
  end

  system('ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended')

  if File.exist?("#{home_dir}/.zshrc")
    FileUtils.rm("#{home_dir}/.zshrc")
  end
end

def install_plugin_by_url(url)
  name = url.split('/').last
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

def install_everything
  install_oh_my_zsh
  install_oh_my_zsh_plugins
  install_dotfiles

  puts "Done installing everything!"
end

def update_everything
  update_dotfiles

  puts "Done updating everything!"
end

def run_it!
  command = ARGV.shift

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

run_it!
