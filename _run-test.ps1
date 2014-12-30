bundle install
if( $LASTEXITCODE -ne 0 ) {
	throw "Failed bundle install with $LASTEXITCODE"
}
bundle exec jekyll serve --drafts -w --config ".\_config.yml,.\_config.dev.yml"