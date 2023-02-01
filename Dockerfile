FROM ruby:2.6.5-alpine
ARG RAILS_ENV=production
ENV RAILS_ENV="${RAILS_ENV}"
ENV APP_VERSION=${TAG}
RUN apk update
RUN apk add bash build-base libxml2-dev libxslt-dev postgresql postgresql-dev nodejs vim yarn libc6-compat curl git which wkhtmltopdf ttf-ubuntu-font-family imagemagick
RUN apk add --no-cache \
        wkhtmltopdf \
        xvfb \
        ttf-dejavu ttf-droid ttf-freefont ttf-liberation \
    ;

RUN ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf;
RUN chmod +x /usr/local/bin/wkhtmltopdf;
RUN mkdir /app
WORKDIR /app
COPY hiringplatform-ruby/Gemfile* ./
RUN gem install bundler && bundle config https://gem.fury.io/engineerai/ nvHuX-OXxLY2OpiQkFVfgnYgd4CszdA
COPY hiringplatform-ruby/ .
RUN bundle install
RUN mkdir /app/public/uploads
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
RUN /bin/bash entrypoint.sh
RUN rails assets:clobber
RUN rails assets:precompile
RUN rails db:migrate
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "puma", "-b", "0.0.0.0", "-p", "3000"]
