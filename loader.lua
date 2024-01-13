function load_obj_file(file_path)
  local triangles = {}
  local lines_iterator
  if love then
    lines_iterator = love.filesystem.lines(file_path)
  else
    lines_iterator = io.lines(file_path)
  end
  local indexable_vertex_position_xyz = {}
  local indexable_vertex_normal_xyz = {}
  for line in lines_iterator do
    local type = line:match "(%S+) .+"
    if type == "v" then
      -- vertex
      local x, y, z = line:match "v (%S+) (%S+) (%S+)"
      local vertex_position_xyz = { tonumber(x), tonumber(y), tonumber(z) }
      table.insert(indexable_vertex_position_xyz, vertex_position_xyz)
    elseif type == "vn" then
      -- vertex normal
      local x, y, z = line:match "vn (%S+) (%S+) (%S+)"
      local vertex_normal_xyz = { tonumber(x), tonumber(y), tonumber(z) }
      table.insert(indexable_vertex_normal_xyz, vertex_normal_xyz)
    elseif type == "f" then
      -- face (it's specific for triangulated-mesh: exactly 3 vertices)
      local v1, vn1, v2, vn2, v3, vn3 = line:match "f (%d+)//(%d+) (%d+)//(%d+) (%d+)//(%d+)"
      local triangle = {}
      triangle.vertex_position_indices = { tonumber(v1), tonumber(v2), tonumber(v3) }
      triangle.vertex_normal_indices = { tonumber(vn1), tonumber(vn2), tonumber(vn3) }
      table.insert(triangles, triangle)
    end
  end
  return { triangles, indexable_vertex_position_xyz, indexable_vertex_normal_xyz }
end
