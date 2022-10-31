#最新版のRuby
FROM ruby:3.0.2
# # 必要なパッケージのインストール
# -Sの効果で、エラーメッセージが出力される。
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# パッケージリスト更新後、railsとDBに必要なパッケージインストール
# -qqはエラー以外は表示しない
RUN apt-get update -qq && \
    apt-get install -y nodejs npm \
                       postgresql-client \
                       yarn
RUN npm install n -g 
RUN n 16.13.1

# 作業ディレクトリの作成、設定
RUN mkdir /rails-hotel-search-line-bot

##作業ディレクトリ名をAPP_ROOTに割り当てて、以下$APP_ROOTで参照
ENV APP_ROOT /rails-hotel-search-line-bot
WORKDIR $APP_ROOT

# ホスト側（ローカル）のGemfileを追加する（ローカルのGemfileは【３】で作成）
ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

# Gemfileのbundle install
RUN bundle install
COPY . /rails-hotel-search-line-bot
