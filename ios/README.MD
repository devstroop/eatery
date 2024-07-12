# Ensure rbenv is initialized
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
source ~/.zshrc  # or source ~/.bashrc

# Reinstall CocoaPods
gem uninstall cocoapods
gem install cocoapods
pod setup

# Clear existing pods and reinstall
rm -rf Pods/
pod install

# Update RubyGems
gem update --system

# Verify gem paths
which gem
which pod
gem env
