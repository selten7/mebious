SQLITE3 = sqlite3

BUNDLE = bundle
RUBOCOP = $(BUNDLE) exec rubocop

SCHEMAS = $(wildcard models/schemas/*.sql)

setup: vendor data/mebious.db public/images

data/mebious.db: data
	cat $(SCHEMAS) | $(SQLITE3) $@

data public/images:
	mkdir -p $@

vendor/bundle:
	$(BUNDLE) install --path vendor/bundle

vendor: vendor/bundle

clean:
	$(RM) -r vendor/
.PHONY: clean

distclean:
	$(RM) -r data/ public/images/
.PHONY: distclean

lint: rubocop
.PHONY: lint

rubocop:
	$(RUBOCOP)
.PHONY: rubocop

rubocop-fix:
	$(RUBOCOP) -a
.PHONY: rubocop-fix
