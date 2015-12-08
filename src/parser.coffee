
parseTree = (string, graph) ->
  brackets = 0
  count = 0
  parrents = []
  tempName = ""
  name = ""
  countName = ""
  parrent = ""
  
  addName = ->
    if !tempName
      return
    name = tempName
    tempName = ""
    countName = name + count++

  addToGraph = (graph) ->
    shape = "circle"
    if name == "#" || name == ''
      shape = "rect"
      name = ""
    #console.log "adding name '#{name}' with countname '#{countName}'"
    graph.setNode(countName, { label: name, shape: shape})

    if parrent
      graph.setEdge(parrent, countName, {label:""})

  prevChar = ""
  pos = 0
  #console.log string.length
  # i should refactor this
  while pos < string.length
    c = string[pos++]
    switch c
      when ' '
        if tempName
          addName()
          addToGraph(graph)
      when '('
        brackets++
        if string[pos] == ')'
          brackets--
          #console.log pos, string
          tempName = '#'
          addName()
          addToGraph(graph)
          pos++
        else
          addName()
          addToGraph(graph) # add root
          parrent = countName
          parrents.push(parrent)
      when ')'
        brackets--
        addName()
        if prevChar != ')'
          addToGraph(graph)
        parrents.pop()
        parrent = parrents[parrents.length-1]
      else
        if c != '\n'
          tempName += c
    if c != ' '
      prevChar = c

  if brackets > 0
    console.log "wrong number of brackets #{brackets}"

module.exports = parseTree