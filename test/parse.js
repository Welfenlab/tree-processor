var assert = require('assert')
var parser = require('../lib/parser.js')

function graph () {
  this.nodes = []
  this.edges = []
}

graph.prototype.setNode = function (name, options) {
  // NOTE: hacky, I don't know how dagre handels multiple nodes/edged with the same name
  for (var i = this.nodes.length - 1; i >= 0; i--) {
    if (this.nodes[i].name === name)
      return
  }
  this.nodes.push({name: name, options: options})
}

graph.prototype.setEdge = function (from, to, options) {
  // NOTE: hacky, see setNode
  for (var i = this.edges.length - 1; i >= 0; i--) {
    if (this.edges[i].from === from && this.edges[i].to === to)
      return
  }
  this.edges.push({from: from, to: to, options: options})
}

graph.prototype.findNode = function (name) {
  for (var i = this.nodes.length - 1; i >= 0; i--) {
    var node = this.nodes[i]
    if (node.options.label === name)
      return node
  }
  return NaN
}

graph.prototype.hasEdge = function (from, to) {
  from = this.findNode(from).name
  to = this.findNode(to).name
  for (var i = this.edges.length - 1; i >= 0; i--) {
    var edge = this.edges[i]
    if (edge.from === from && edge.to === to || edge.to === from && edge.from === to)
      return true
  }
  return false
}

describe('parser', function () {
  describe('A(B C)', function () {
    var graphStr = 'A(B C)'
    var g = new graph()
    parser(graphStr, g)

    it('check number of nodes', function () {
      assert.equal(3, g.nodes.length)
    })
    it('check number of nodes', function () {
      assert.equal(2, g.edges.length)
    })
    it('check edges', function () {
      assert.equal(true, g.hasEdge('A', 'B'))
      assert.equal(true, g.hasEdge('A', 'C'))
    })
  })

  describe('A(B C(D ()))', function () {
    var graphStr = 'A(B C(D ()))'
    var g = new graph()
    parser(graphStr, g)

    it('check number of nodes', function () {
      assert.equal(5, g.nodes.length)
    })
    it('check number of nodes', function () {
      assert.equal(4, g.edges.length)
    })
    it('check edges', function () {
      assert.equal(true, g.hasEdge('A', 'B'))
      assert.equal(true, g.hasEdge('A', 'C'))
      assert.equal(true, g.hasEdge('C', 'D'))
      assert.equal(true, g.hasEdge('C', ''))
    })
  })
})
