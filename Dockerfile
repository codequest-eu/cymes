FROM ruby:2.6.3

# Install system dependencies
RUN apt-get update -y && apt-get install -y \
  build-essential \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  libqt5webkit5-dev \
  qt5-qmake \
  xvfb

RUN gem install bundler:1.17.2
RUN QMAKE=/usr/lib/x86_64-linux-gnu/qt5/bin/qmake gem install capybara-webkit

# Setup app user, group and home directory
ENV APP_HOME="/app/src"
RUN groupadd -r app --gid=999
RUN useradd -r -g app --uid=999 --home-dir="${APP_HOME}" --shell="/bin/bash" app
RUN mkdir -p "${APP_HOME}"
RUN chown -R app:app "${APP_HOME}"

USER app:app
WORKDIR ${APP_HOME}

# Install ruby dependencies
ENV BUNDLE_PATH="${APP_HOME}/bundle"
ADD --chown=app:app . ./
ENV QMAKE=/usr/lib/x86_64-linux-gnu/qt5/bin/qmake
ENV QT_QPA_PLATFORM=offscreeeen
RUN bundle install --no-cache --frozen
RUN bundle config --delete frozen

# Add app code
ADD --chown=app:app . ./

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "help"]
