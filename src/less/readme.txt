#**********************************************************************#
# Instructions to install and compile LESS to css via the command line #
#**********************************************************************#

http://lesscss.org/usage/#using-less-environments

# mac
brew install nodejs
brew install npm

# linux/cygwin
apt-get install nodejs
apt-get install npm

# install LESS
npm i less --save-dev

# compile less to css (from hotwire directory)
lessc src/less/hotwire.less stylesheets/hotwire.css