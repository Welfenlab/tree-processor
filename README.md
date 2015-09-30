# more-markdown / tree-processor

A plugin for `more-markdown` that renders graphs in tree preorder notation.

# Installation

You first need a [more-markdown](https://github.com/Welfenlab/more-markdown) setup.
Then you can install it via:

```
npm install @more-markdown/tree-processor
```

# Usage

```
var moreMarkdown = require('more-markdown');
var treeProcessor = require('@more-markdown/tree-processor');

// create a processor that writes the final html
// to the element with the id 'output'
var proc = moreMarkdown.create('output', processors: [treeProcessor]);

proc.render("```tree" +
"A(B(D E(F))C)"
"```");
```
