function load_obj_file(file_path)
  local triangles = {}
  local lines_iterator
  if love then
    lines_iterator = love.filesystem.lines(file_path)
  else
    lines_iterator = io.lines(file_path)
  end
  local index_vertex = {}
  local index_vertex_normal = {}
  for line in lines_iterator do
    local type = line:match"(%S+) .+"
    if type=="v" then
      -- vertex
      local x,y,z = line:match "v (%S+) (%S+) (%S+)"
      local vertex={ x=tonumber(x), y=tonumber(y), z=tonumber(z) }
      table.insert(index_vertex, vertex)
    elseif type=="vn" then
      -- vertex normal
      local x,y,z = line:match "vn (%S+) (%S+) (%S+)"
      local vertex_normal={ x=tonumber(x), y=tonumber(y), z=tonumber(z) }
      table.insert(index_vertex_normal, vertex_normal)
    elseif type=="f" then
      -- face (it's specific for triangulated-mesh: exactly 3 vertices)
      local v1,vn1,v2,vn2,v3,vn3 = line:match "f (%d+)//(%d+) (%d+)//(%d+) (%d+)//(%d+)"
      local triangle = { index_vertex[tonumber(v1)],
        index_vertex[tonumber(v2)], index_vertex[tonumber(v3)] }
      triangle[1].normal = index_vertex_normal[tonumber(vn1)]
      triangle[2].normal = index_vertex_normal[tonumber(vn2)]
      triangle[3].normal = index_vertex_normal[tonumber(vn3)]
      table.insert(triangles, triangle)
    end
  end
  return triangles
end
