sleight
=======

A lean, opinionated static site builder.

Everything will be modular a la Vue.js: the building block is the folder, which will contain an HTML template, a CSS file, a JS file, and a data folder. The resources will be auto-included based on the folder structure, and e.g. CSS will apply to the current folder and all children folders. The end result will be flattened.

To do:

- [ ] Start over with node instead of ruby
- [ ] Still use Handlebars? Or Mustache, or...?

- [ ] Combine templates with data
  - [ ] Convert single JSON file with corresponding single Handlebars template to HTML (was done in ruby)
  - [ ] Convert folder of JSON files with corresponding single Handlebars template to HTML (was done in ruby)
  - [ ] Give Handlebars access to JSON "in scope"; e.g. create a file which lists the JSON files in the folder
  - [ ] Combine nested templates
- [ ] Copy CSS, JS to resources
  - [ ] Name by original folder path
- [ ] Convert Markdown files to HTML
- [ ] Convert Markdown in JSON to HTML before combining with templates
- [ ] Add JS and CSS references automatically based on original location
- [ ] Copy all other files to _output preserving directory tree
  - [ ] Pretty URLs for HTML files
- [ ] Typography, special abbreviations, fractions, sitemap, rss/atom should be handled with existing node libraries
