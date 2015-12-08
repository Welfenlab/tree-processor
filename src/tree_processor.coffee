
markdownItGraph = require './md_graph'
d3 = require 'd3'
dagreD3 = require 'dagre-d3'
uuid = require 'node-uuid'

parseTree = require './parser'

treeProcessor = (tokens, graph_template, error_template) ->
  render = dagreD3.render()
  register: (mdInstance, postProcessors) ->
    markdownItGraph(tokens).register mdInstance, (graphStr) ->
      try
        graph = new dagreD3.graphlib.Graph().setGraph({});

        parseTree graphStr, graph

        id = "tree-dg-" + uuid.v4()
        postProcessors.registerElemenbById id, (elem, done) ->
            d3.select(elem).call(render, graph)
            svgElem = elem.getElementsByClassName('output')[0]
            svgHeight = svgElem?.getBoundingClientRect().height || 0
            elem.style.height = svgHeight + 22

            tags = elem.getElementsByTagName('path')
            [].forEach.call tags, (e) ->
              e.setAttribute 'marker-end', ''

            done()

        # graph was parsed succesful
        return graph_template id: id

      # parsing errors..
      catch e
        return error_template error: e

    return null

module.exports = treeProcessor
