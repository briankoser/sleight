sleight
=======

A lean, opinionated static site builder.

To do:

- [ ] Combine templates with data
  - Pretty URLs
  - Preserve the directory tree
  - [x] Convert single JSON file with corresponding single Handlebars template to HTML
  - [x] Convert folder of JSON files with corresponding single Handlebars template to HTML
  - [ ] Give Handlebars access to JSON "in scope"; e.g. create a file which lists the JSON files in the folder
  - [ ] Combine nested templates
- [ ] Copy CSS, JS to resources
  - [ ] Name by original folder path
- [ ] Convert Markdown files to HTML
- [ ] Convert Markdown in JSON to HTML before combining with templates
- [ ] Add JS and CSS references automatically based on original location
- [ ] Copy all other files to _output preserving directory tree
  - [ ] Pretty URLs for HTML files
- [ ] span with class around special abbreviations
- [ ] span with class around fractions
- [ ] smartypants?
- [ ] Implement as gulp plugin so I can also combine CSS, combine JS, minify PNGs, lint, remove BOM, live reload
- [ ] sitemap
- [ ] rss/atom
- [ ] Make generic by removing recipe site-specific data
