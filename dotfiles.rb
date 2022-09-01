#!/usr/bin/env ruby

require "fileutils"

class Dotfile
  attr_reader :from, :to

  def initialize(from:, to:)
    @from = from
    @to = to
  end

  def update
    copy_file(from, to)
  end

  def install
    copy_file(to, from)
  end

  private

  def copy_file(from, to)
    puts "Copying #{from} to #{to}..."
    FileUtils.cp(from, to)
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
    Dotfile.new(from: "#{home_dir}/.aliases", to: "common/aliases"),
    Dotfile.new(from: "#{home_dir}/.hushlogin", to: "common/hushlogin"),
    Dotfile.new(from: "#{home_dir}/.gitignore_global", to: "common/gitignore_global"),
    Dotfile.new(from: "#{home_dir}/.vimrc", to: "common/vimrc"),
    Dotfile.new(from: "#{home_dir}/.gitconfig", to: "common/gitconfig"),
    Dotfile.new(from: "#{home_dir}/.zshrc", to: "common/zshrc"),
    Dotfile.new(from: "#{home_dir}/.pryrc", to: "common/pryrc"),
    Dotfile.new(from: "#{home_dir}/.irbrc", to: "common/irbrc"),
    Dotfile.new(from: "#{home_dir}/.ruby-version", to: "common/ruby-version"),
    Dotfile.new(from: "#{home_dir}/.oh-my-zsh/themes/ryanseys.zsh-theme", to: "common/ryanseys.zsh-theme"),
  ]
end

def personal_dotfiles
  @personal_dotfiles ||= if on_personal_computer?
    puts "Detected: Personal Macbook 🤪"

    [
      Dotfile.new(from: "#{home_dir}/.gitconfig_local", to: "personal/gitconfig"),
      Dotfile.new(from: "#{home_dir}/.aliases_local", to: "personal/aliases"),
      Dotfile.new(from: "#{home_dir}/.ruby-version", to: "personal/ruby-version"),
      Dotfile.new(from: "#{home_dir}/.zshrc_local", to: "personal/zshrc"),
    ]
  end
end

def spin_dotfiles
  @spin_dotfiles ||= if on_spin?
    puts "Detected: Spin 🌀"

    [
      Dotfile.new(from: "#{home_dir}/.gitconfig_local", to: "shopify/gitconfig"),
      Dotfile.new(from: "#{home_dir}/install_rubymine_on_spin.sh", to: "shopify/install_rubymine_on_spin.sh"),
      Dotfile.new(from: "#{home_dir}/.aliases_local", to: "shopify/aliases"),
      Dotfile.new(from: "#{home_dir}/.zshrc_local", to: "shopify/zshrc"),
    ]
  end
end

def shopify_dotfiles
  @shopify_dotfiles ||= if on_shopify_computer?
    puts "Detected: Shopify Macbook 👨🏼‍💻"

    [
      Dotfile.new(from: "#{home_dir}/.gitconfig_local", to: "shopify/gitconfig"),
      Dotfile.new(from: "#{home_dir}/.aliases_local", to: "shopify/aliases"),
      Dotfile.new(from: "#{home_dir}/.gitmessage", to: "shopify/gitmessage"),
      Dotfile.new(from: "#{home_dir}/.zshrc_local", to: "shopify/zshrc"),
    ]
  end
end

def dotfiles
  @all_dotfiles ||= [common_dotfiles, personal_dotfiles, shopify_dotfiles, spin_dotfiles].flatten.compact
end

def install_dotfiles
  puts "Installing dotfiles..."

  dotfiles.each do |dotfile|
    dotfile.install
  end

  puts "Done installing dotfiles!\n"
end

def update_dotfiles
  puts "Updating dotfiles..."

  dotfiles.each do |dotfile|
    dotfile.update
  end

  puts "Done updating dotfiles!\n"
end

def has_oh_my_zsh?
  !ENV.fetch("ZSH", nil).nil?
end

def install_oh_my_zsh
  return if has_oh_my_zsh?

  system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
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
  install_dotfiles
  install_oh_my_zsh
  install_oh_my_zsh_plugins

  puts "Done installing everything!"
end

def update_everything
  update_dotfiles

  puts "Done updating everything!"
end

def run_it!
  command = ARGV.shift

  if command == "install"
    install_everything
  elsif command == "update"
    update_everything
  else
    puts "Usage: #{$0} install|update"
    exit 1
  end
end

run_it!
